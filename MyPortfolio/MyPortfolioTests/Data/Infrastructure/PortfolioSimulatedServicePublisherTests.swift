//
//  PortfolioSimulatedServicePublisherTests.swift
//  MyPortfolioTests
//
//  Created by Lana Salai on 16.4.25..
//

import XCTest
import Combine
@testable import MyPortfolio

final class PortfolioSimulatedServicePublisherTests: XCTestCase {
    func test_fetchPortfolioPublisher_invokesDataSourceFetch() {
        let dataSourceSpy = RemotePortfolioDataSourceSpy()
        let sut = PortfolioSimulatedServicePublisher(dataSource: dataSourceSpy, 
                                                     simulationService: PercentagesSimulationServiceSpy())
        trackForMemoryLeaks(dataSourceSpy)
        trackForMemoryLeaks(sut)
        
        _ = sut.fetchPortfolioPublisher()
        
        XCTAssertEqual(dataSourceSpy.messages, [.fetchPortfolio])
    }
    
    func test_fetchPortfolioPublisher_failsOnDataSourceError() {
        let dataSourceSpy = RemotePortfolioDataSourceSpy()
        let sut = PortfolioSimulatedServicePublisher(dataSource: dataSourceSpy, 
                                                     simulationService: PercentagesSimulationServiceSpy())
        trackForMemoryLeaks(dataSourceSpy)
        trackForMemoryLeaks(sut)
        let expectedError = anyNSError()
        let expectation = expectation(description: "Wait for completion")
        
        let subscriber = sut.fetchPortfolioPublisher()
            .sink(receiveCompletion: { completion in
                if case let .failure(error as NSError) = completion {
                    XCTAssertEqual(error, expectedError)
                } else {
                    XCTFail("Expected to fail with: \(expectedError)")
                }
                expectation.fulfill()
            }, receiveValue: { _ in
                XCTFail("Expected to fail with: \(expectedError)")
            })
        
        dataSourceSpy.complete(with: expectedError)
        subscriber.cancel()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_fetchPortfolioPublisher_callsStartSimulationWithCorrectCount() {
        let dataSourceStub = RemotePortfolioDataSourceStub()
        dataSourceStub.stub = makeRemotePortfolio()
        let simulationServiceSpy = PercentagesSimulationServiceSpy()
        let sut = PortfolioSimulatedServicePublisher(dataSource: dataSourceStub,
                                                     simulationService: simulationServiceSpy)
        trackForMemoryLeaks(dataSourceStub)
        trackForMemoryLeaks(simulationServiceSpy)
        trackForMemoryLeaks(sut)
        
        _ = sut.fetchPortfolioPublisher()
        
        XCTAssertEqual(simulationServiceSpy.messages, [.generatePercentagesPublisher(count: 2)])
    }
    
    func test_fetchPortfolioPublisher_deliversManipulatedPortfolio() {
        let dataSourceSpy = RemotePortfolioDataSourceSpy()
        let simulationServiceStub = PercentagesSimulationServiceStub()
        simulationServiceStub.stub = [0.1, -0.1]
        let sut = PortfolioSimulatedServicePublisher(dataSource: dataSourceSpy,
                                                     simulationService: simulationServiceStub)
        trackForMemoryLeaks(dataSourceSpy)
        trackForMemoryLeaks(simulationServiceStub)
        trackForMemoryLeaks(sut)
        let expectation = expectation(description: "Wait for completion")
        
        let subscriber = sut.fetchPortfolioPublisher()
            .sink(receiveCompletion: { completion in
                XCTFail("Expected to receive portfolio")
            }, receiveValue: { manipulatedPortfolio in
                XCTAssertEqual(manipulatedPortfolio.balance.netValue, 29.0)
                XCTAssertEqual(manipulatedPortfolio.balance.pnl, 22.0)
                XCTAssertEqual(manipulatedPortfolio.balance.pnlPercentage, 2200.0/7)
                XCTAssertEqual(manipulatedPortfolio.positions[0].marketValue, 11.00)
                XCTAssertEqual(manipulatedPortfolio.positions[0].pnl, 7.00)
                XCTAssertEqual(manipulatedPortfolio.positions[0].pnlPercentage, 700.00/4)
                XCTAssertEqual(manipulatedPortfolio.positions[1].marketValue, 18.00)
                XCTAssertEqual(manipulatedPortfolio.positions[1].pnl, 15.00)
                XCTAssertEqual(manipulatedPortfolio.positions[1].pnlPercentage, 500)
                expectation.fulfill()
            })
        
        dataSourceSpy.complete(with: makeRemotePortfolio())
        subscriber.cancel()
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_fetchPortfolioPublisher_doesNotCompleteWhenSUTnstanceIsDeallocated() {
        let dataSourceSpy = RemotePortfolioDataSourceSpy()
        let simulatedServiceSpy = PercentagesSimulationServiceSpy()
        var sut: PortfolioSimulatedServicePublisher? = PortfolioSimulatedServicePublisher(dataSource: dataSourceSpy, simulationService: simulatedServiceSpy)
        
        _ = sut?.fetchPortfolioPublisher()
        
        sut = nil
        dataSourceSpy.complete(with: makeRemotePortfolio())
        XCTAssertTrue(simulatedServiceSpy.messages.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeRemotePortfolio() -> RemotePortfolio {
        let instrument = RemoteInstrument(ticker: UUID().uuidString,
                                          name: UUID().uuidString,
                                          exchange: UUID().uuidString,
                                          currency: UUID().uuidString,
                                          lastTradedPrice: 10)
        let position1 = RemotePosition(instrument: instrument,
                                      quantity: 1,
                                      averagePrice: 5,
                                      cost: 4,
                                      marketValue: 10,
                                      pnl: 6,
                                      pnlPercentage: 150)
        let position2 = RemotePosition(instrument: instrument,
                                      quantity: 2,
                                      averagePrice: 1,
                                      cost: 3,
                                      marketValue: 20,
                                      pnl: 17,
                                       pnlPercentage: 1700.00/3)
        let balance = RemoteBalance(netValue: 30,
                                    pnl: 23,
                                    pnlPercentage: 2300.00/7)
        let portfolio = RemotePortfolio(balance: balance,
                                        positions: [position1, position2])
        return portfolio
    }
}

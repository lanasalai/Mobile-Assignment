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
                                                     simulationService: PercentagesSimulationServiceStub())
        
        _ = sut.fetchPortfolioPublisher()
        
        XCTAssertEqual(dataSourceSpy.messages, [.fetchPortfolio])
    }
    
    func test_fetchPortfolioPublisher_failsOnDataSourceError() {
        let dataSourceSpy = RemotePortfolioDataSourceSpy()
        let sut = PortfolioSimulatedServicePublisher(dataSource: dataSourceSpy, 
                                                     simulationService: PercentagesSimulationServiceStub())
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
        
        _ = sut.fetchPortfolioPublisher()
        
        XCTAssertEqual(simulationServiceSpy.messages, [.generatePercentagesPublisher(count: 2)])
    }
    
    func test_fetchPortfolioPublisher_deliversManipulatedPortfolio() {
        let dataSourceSpy = RemotePortfolioDataSourceSpy()
        let simulationServiceStub = PercentagesSimulationServiceStub()
        simulationServiceStub.stub = [0.1, -0.1]
        let sut = PortfolioSimulatedServicePublisher(dataSource: dataSourceSpy,
                                                     simulationService: simulationServiceStub)
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
    
    // MARK: - Helpers
    
    private final class PercentagesSimulationServiceStub: PercentagesSimulationService {
        var stub: [Double]?
        
        func generatePercentagesPublisher(count: Int) -> AnyPublisher<[Double], Never> {
            guard let percentages = stub else {
                fatalError("Stub value is missing")
            }
            return Just(percentages).eraseToAnyPublisher()
        }
    }
    
    private final class PercentagesSimulationServiceSpy: PercentagesSimulationService {
        var messages = [Message]()
        
        enum Message: Equatable {
            case generatePercentagesPublisher(count: Int)
        }
        
        func generatePercentagesPublisher(count: Int) -> AnyPublisher<[Double], Never> {
            messages.append(.generatePercentagesPublisher(count: count))
            return Just([]).eraseToAnyPublisher()
        }
    }
    
    private final class RemotePortfolioDataSourceStub: RemotePortfolioDataSource {
        var stub: RemotePortfolio?
        
        func fetchPortfolio(_ completion: @escaping (RemotePortfolioDataSource.Result) -> Void) {
            guard let portfolio = stub else {
                fatalError("Stub value is missing")
            }
            completion(.success(portfolio))
        }
    }
    
    private final class RemotePortfolioDataSourceSpy: RemotePortfolioDataSource {
        private var _messages = [(message: Message, completion: (RemotePortfolioDataSource.Result) -> Void)]()
        var messages: [Message] {
            _messages.map(\.message)
        }
        
        enum Message: Equatable {
            case fetchPortfolio
        }
        
        func fetchPortfolio(_ completion: @escaping (RemotePortfolioDataSource.Result) -> Void) {
            _messages.append((message: .fetchPortfolio, completion: completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            _messages[index].completion(.failure(error))
        }
        
        func complete(with remotePortfolio: RemotePortfolio, at index: Int = 0) {
            _messages[index].completion(.success(remotePortfolio))
        }
    }
    
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

//
//  PortfolioSimulatedServicePublisherTests.swift
//  MyPortfolioTests
//
//  Created by Lana Salai on 16.4.25..
//

import XCTest
@testable import MyPortfolio

final class PortfolioSimulatedServicePublisherTests: XCTestCase {
    func test_fetchPortfolioPublisher_invokesDataSourceFetch() {
        let dataSourceSpy = RemotePortfolioDataSourceSpy()
        let sut = PortfolioSimulatedServicePublisher(dataSource: dataSourceSpy)
        
        _ = sut.fetchPortfolioPublisher()
        
        XCTAssertEqual(dataSourceSpy.messages, [.fetchPortfolio])
    }
    
    func test_fetchPortfolioPublisher_failsOnDataSourceError() {
        let dataSourceSpy = RemotePortfolioDataSourceSpy()
        let sut = PortfolioSimulatedServicePublisher(dataSource: dataSourceSpy)
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
    }
}

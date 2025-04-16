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
    }
}

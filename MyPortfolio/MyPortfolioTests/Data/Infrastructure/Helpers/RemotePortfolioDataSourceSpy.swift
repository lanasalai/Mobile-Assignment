//
//  RemotePortfolioDataSourceSpy.swift
//  MyPortfolioTests
//
//  Created by Lana Salai on 16.4.25..
//

import Foundation
@testable import MyPortfolio

final class RemotePortfolioDataSourceSpy: RemotePortfolioDataSource {
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

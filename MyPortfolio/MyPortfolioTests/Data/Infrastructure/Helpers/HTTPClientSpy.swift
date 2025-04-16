//
//  HTTPClientSpy.swift
//  MyPortfolioTests
//
//  Created by Lana Salai on 16.4.25..
//

import Foundation
@testable import MyPortfolio

final class HTTPClientSpy: HTTPClient {
    private var _messages = [(request: URLRequest, completion: (HTTPClient.Result) -> Void)]()
    var messages: [URLRequest] {
        _messages.map(\.request)
    }
    
    func perform(_ request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) {
        _messages.append((request: request, completion: completion))
    }
    
    func complete(with error: Error, at index: Int = 0) {
        _messages[index].completion(.failure(error))
    }
    
    func complete(withStatus status: Int, data: Data, at index: Int = 0) {
        let response = HTTPURLResponse(url: messages[index].url!, statusCode: status, httpVersion: nil, headerFields: nil)!
        _messages[index].completion(.success((data, response)))
    }
}

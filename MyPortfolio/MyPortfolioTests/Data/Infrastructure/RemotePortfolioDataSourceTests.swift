//
//  RemotePortfolioDataSourceTests.swift
//  MyPortfolioTests
//
//  Created by Lana Salai on 15.4.25..
//

import XCTest
@testable import MyPortfolio

final class RemotePortfolioDataSourceTests: XCTestCase {
    func test_fetchPortfolio_performsClientRequest() {
        let httpClient = HTTPClientSpy()
        let expectedRequest = URLRequest(url: URL(string: "any-url")!)
        let requestProvider = PortfolioRequestProviderStub()
        requestProvider.stub = expectedRequest
        let sut = RemotePortfolioDataSourceImpl(httpClient: httpClient, requestProvider: requestProvider)
        
        sut.fetchPortfolio { _ in }
        
        XCTAssertEqual(httpClient.messages, [expectedRequest])
    }
    
    private final class HTTPClientSpy: HTTPClient {
        private var _messages = [(request: URLRequest, completion: (HTTPClient.Result) -> Void)]()
        var messages: [URLRequest] {
            _messages.map(\.request)
        }
        
        func perform(_ request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) {
            _messages.append((request: request, completion: completion))
        }
    }
    
    private final class PortfolioRequestProviderStub: URLRequestProvider {
        var url: URL = URL(string: "any-url")!
        var httpMethod: MyPortfolio.HTTPMethod = .get
        var stub: URLRequest?
        
        func makeRequest() -> URLRequest {
            guard let request = stub else {
                fatalError("Missing stub value")
            }
            return request
        }
    }
}

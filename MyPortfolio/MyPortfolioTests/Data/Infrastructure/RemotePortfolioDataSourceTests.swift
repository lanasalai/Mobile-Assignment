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
    
    func test_fetchPortfolio_failsWithClientError() {
        let httpClient = HTTPClientSpy()
        let expectedError = NSError(domain: "", code: 0)
        let sut = RemotePortfolioDataSourceImpl(httpClient: httpClient, requestProvider: PortfolioRequestProviderStub())
        let expectation = XCTestExpectation(description: "Wait for completion")
        
        sut.fetchPortfolio { result in
            if case let .failure(error as NSError) = result {
                XCTAssertEqual(error, expectedError)
            } else {
                XCTFail("Expected to fail with: \(expectedError)")
            }
            expectation.fulfill()
        }
        
        httpClient.complete(with: expectedError)
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_fetchPortfolio_failsWithUnexpectedErrorOnNon200HttpStatus() {
        let httpClient = HTTPClientSpy()
        let expectedError = RemotePortfolioResponseMapper.Error.unexpectedError
        let sut = RemotePortfolioDataSourceImpl(httpClient: httpClient, requestProvider: PortfolioRequestProviderStub())
        let expectation = XCTestExpectation(description: "Wait for completion")
        
        sut.fetchPortfolio { result in
            if case let .failure(error as RemotePortfolioResponseMapper.Error) = result {
                XCTAssertEqual(error, expectedError)
            } else {
                XCTFail("Expected to fail with: \(expectedError)")
            }
            expectation.fulfill()
        }
        
        httpClient.complete(withStatus: 400, data: Data())
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: Helpers
    
    private final class HTTPClientSpy: HTTPClient {
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

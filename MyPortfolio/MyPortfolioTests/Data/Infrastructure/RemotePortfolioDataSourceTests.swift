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
        let (sut, collaborators) = makeSUT()
        let expectedRequest = URLRequest(url: URL(string: "any-url")!)
        collaborators.requestProvider.stub = expectedRequest
        
        sut.fetchPortfolio { _ in }
        
        XCTAssertEqual(collaborators.httpClient.messages, [expectedRequest])
    }
    
    func test_fetchPortfolio_failsWithClientError() {
        let (sut, collaborators) = makeSUT()
        let expectedError = NSError(domain: "", code: 0)
        
        expect(sut, toCompleteWith: .failure(expectedError)) {
            collaborators.httpClient.complete(with: expectedError)
        }
    }
    
    func test_fetchPortfolio_failsWithUnexpectedErrorOnNon200HttpStatus() {
        let (sut, collaborators) = makeSUT()
        let expectedError = RemotePortfolioResponseMapper.Error.unexpectedError
        
        expect(sut, toCompleteWith: .failure(expectedError)) {
            collaborators.httpClient.complete(withStatus: 400, data: Data())
        }
    }
    
    func test_fetchPortfolio_failsWithInvalidDataErrorOn200HttpStatus() {
        let (sut, collaborators) = makeSUT()
        let expectedError = RemotePortfolioResponseMapper.Error.invalidData
        
        expect(sut, toCompleteWith: .failure(expectedError)) {
            collaborators.httpClient.complete(withStatus: 200, data: Data("invalid-data".utf8))
        }
    }
    
    func test_fetchPortfolio_deliversPortfolioOn200HttpStatus() throws {
        let (sut, collaborators) = makeSUT()
        let (expectedPortfolio, data) = try makePortfolioData()
        
        expect(sut, toCompleteWith: .success(expectedPortfolio)) {
            collaborators.httpClient.complete(withStatus: 200, data: data)
        }
    }
    
    // MARK: Helpers
    
    private struct Collaborators {
        let httpClient: HTTPClientSpy
        let requestProvider: PortfolioRequestProviderStub
    }
    
    private func makeSUT(file: StaticString = #file,
                         line: UInt = #line) -> (sut: RemotePortfolioDataSource,
                               collaborators: Collaborators) {
        let httpClient = HTTPClientSpy()
        let requestProvider = PortfolioRequestProviderStub()
        let sut = RemotePortfolioDataSourceImpl(httpClient: httpClient,
                                                requestProvider: requestProvider)
        let collaborators = Collaborators(httpClient: httpClient, requestProvider: requestProvider)
        
        trackForMemoryLeaks(httpClient, file: file, line: line)
        trackForMemoryLeaks(requestProvider, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, collaborators)
    }
    
    private func expect(_ sut: RemotePortfolioDataSource, 
                        toCompleteWith expectedResult: RemotePortfolioDataSource.Result,
                        when action: () -> Void) {
        let expectation = expectation(description: "Wait for completion")
        sut.fetchPortfolio { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
                XCTAssertEqual(receivedError, expectedError)
            case let (.failure(receivedError as RemotePortfolioResponseMapper.Error), .failure(expectedError as RemotePortfolioResponseMapper.Error)):
                XCTAssertEqual(receivedError, expectedError)
            case let (.success(receivedPortfolio), .success(expectedPortfolio)):
                XCTAssertEqual(receivedPortfolio, expectedPortfolio)
            default:
                XCTFail("Expected \(expectedResult), received \(receivedResult)")
            }
            expectation.fulfill()
        }
        
        action()
        wait(for: [expectation], timeout: 1.0)
    }
    
    private func makePortfolioData() throws -> (model: RemotePortfolio, json: Data) {
        let doubleValue = 12345.00
        let instrument = RemoteInstrument(ticker: UUID().uuidString,
                                          name: UUID().uuidString,
                                          exchange: UUID().uuidString,
                                          currency: UUID().uuidString,
                                          lastTradedPrice: doubleValue)
        let position = RemotePosition(instrument: instrument, 
                                      quantity: doubleValue,
                                      averagePrice: doubleValue,
                                      cost: doubleValue,
                                      marketValue: doubleValue,
                                      pnl: doubleValue,
                                      pnlPercentage: doubleValue)
        let balance = RemoteBalance(netValue: doubleValue, 
                                    pnl: doubleValue,
                                    pnlPercentage: doubleValue)
        let portfolio = RemotePortfolio(balance: balance, 
                                        positions: [position])
        
        var instrumentJson: [String: Any] = [:]
        instrumentJson["ticker"] = instrument.ticker
        instrumentJson["name"] = instrument.name
        instrumentJson["exchange"] = instrument.exchange
        instrumentJson["currency"] = instrument.currency
        instrumentJson["lastTradedPrice"] = instrument.lastTradedPrice
        
        var positionJson: [String: Any] = [:]
        positionJson["instrument"] = instrumentJson
        positionJson["quantity"] = position.quantity
        positionJson["averagePrice"] = position.averagePrice
        positionJson["cost"] = position.cost
        positionJson["marketValue"] = position.marketValue
        positionJson["pnl"] = position.pnl
        positionJson["pnlPercentage"] = position.pnlPercentage
        
        var balanceJson: [String: Any] = [:]
        balanceJson["netValue"] = balance.netValue
        balanceJson["pnl"] = balance.pnl
        balanceJson["pnlPercentage"] = balance.pnlPercentage
        
        var portfolioJson: [String: Any] = [:]
        portfolioJson["balance"] = balanceJson
        portfolioJson["positions"] = [positionJson]
        
        var json: [String: Any] = [:]
        json["portfolio"] = portfolioJson
        
        let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        return (portfolio, jsonData)
    }
    
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

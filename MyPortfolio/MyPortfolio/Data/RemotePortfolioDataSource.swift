//
//  RemotePortfolioDataSource.swift
//  MyPortfolio
//
//  Created by Lana Salai on 12.4.25..
//

import Foundation

protocol RemotePortfolioDataSource {
    typealias Result = Swift.Result<RemotePortfolio, Error>
    
    func fetchPortfolio(_ completion: @escaping (Result) -> Void)
}

class RemotePortfolioDataSourceImpl: RemotePortfolioDataSource {
    private let httpClient: HTTPClient
    private let requestProvider: URLRequestProvider
    
    typealias Result = RemotePortfolioDataSource.Result
    
    init(httpClient: HTTPClient, requestProvider: URLRequestProvider) {
        self.httpClient = httpClient
        self.requestProvider = requestProvider
    }
    
    func fetchPortfolio(_ completion: @escaping (Result) -> Void) {
        httpClient.perform(requestProvider.makeRequest()) { result in
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .success((data, response)):
                completion(self.mapResponse(data, response))
            }
        }
    }
    
    private func mapResponse(_ data: Data, _ response: HTTPURLResponse) -> Result {
        Result { try RemotePortfolioResponseMapper.map(data, response) }
    }
}

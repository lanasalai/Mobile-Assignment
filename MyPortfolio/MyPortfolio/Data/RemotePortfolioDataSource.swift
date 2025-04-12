//
//  RemotePortfolioDataSource.swift
//  MyPortfolio
//
//  Created by Lana Salai on 12.4.25..
//

import Foundation

protocol RemotePortfolioDataSource {
    typealias Result = Swift.Result<RemotePortfolio, Error>
    
}

class RemotePortfolioDataSourceImpl: RemotePortfolioDataSource {
    private let httpClient: HTTPClient
    private let request: URLRequest
    
    typealias Result = RemotePortfolioDataSource.Result
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
        //TODO: - remove from here
        var request = URLRequest(url: URL(string: "https://dummyjson.com/c/60b7-70a6-4ee3-bae8")!)
        request.httpMethod = "GET"
        self.request = request
    }
    
    func fetchPortfolio(_ completion: @escaping (Result) -> Void) {
        httpClient.perform(request) { result in
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

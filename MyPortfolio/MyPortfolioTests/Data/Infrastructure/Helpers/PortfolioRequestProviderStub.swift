//
//  PortfolioRequestProviderStub.swift
//  MyPortfolioTests
//
//  Created by Lana Salai on 16.4.25..
//

import Foundation
@testable import MyPortfolio

final class PortfolioRequestProviderStub: URLRequestProvider {
    var url: URL = anyURL()
    var httpMethod: HTTPMethod = .get
    var stub: URLRequest?
    
    func makeRequest() -> URLRequest {
        guard let request = stub else {
            fatalError("Missing stub value")
        }
        return request
    }
}

//
//  URLRequestProvider.swift
//  MyPortfolio
//
//  Created by Lana Salai on 12.4.25..
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

protocol URLRequestProvider {
    var url: URL { get }
    var httpMethod: HTTPMethod { get }
}

extension URLRequestProvider {
    func makeRequest() -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        return request
    }
}

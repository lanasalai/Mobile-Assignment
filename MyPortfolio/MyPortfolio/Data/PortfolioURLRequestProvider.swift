//
//  PortfolioURLRequestProvider.swift
//  MyPortfolio
//
//  Created by Lana Salai on 12.4.25..
//

import Foundation

struct PortfolioURLRequestProvider: URLRequestProvider {
    var url: URL
    let httpMethod: HTTPMethod = .get
}

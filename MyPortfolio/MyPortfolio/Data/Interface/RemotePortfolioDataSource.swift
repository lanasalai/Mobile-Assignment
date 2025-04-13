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

//
//  RemotePortfolioPublisher.swift
//  MyPortfolio
//
//  Created by Lana Salai on 12.4.25..
//

import Combine

protocol RemotePortfolioPublisher {
    func fetchPortfolioPublisher() -> AnyPublisher<RemotePortfolio, Error>
}

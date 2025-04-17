//
//  PortfolioPublisher.swift
//  MyPortfolio
//
//  Created by Lana Salai on 12.4.25..
//

import Combine

protocol PortfolioPublisher {
    func fetchPortfolioPublisher() -> AnyPublisher<ManipulatedPortfolio, Error>
}

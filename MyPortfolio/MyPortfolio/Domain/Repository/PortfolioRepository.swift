//
//  PortfolioRepository.swift
//  MyPortfolio
//
//  Created by Lana Salai on 12.4.25..
//

import Combine

protocol PortfolioRepository {
    func fetchPortfolio() -> AnyPublisher<Portfolio, Error>
}

//
//  ObserveSimulatedPortfolioUseCase.swift
//  MyPortfolio
//
//  Created by Lana Salai on 13.4.25..
//

import Combine

class ObserveSimulatedPortfolioUseCase {
    private let repository: PortfolioRepository
    
    init(repository: PortfolioRepository) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<Portfolio, Error> {
        repository.fetchPortfolio()
    }
}

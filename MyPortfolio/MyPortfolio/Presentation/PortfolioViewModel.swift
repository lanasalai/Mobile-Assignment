//
//  PortfolioViewModel.swift
//  MyPortfolio
//
//  Created by Lana Salai on 14.4.25..
//

import Foundation
import Combine

class PortfolioViewModel {
    private let observePortfolioUseCase: ObserveSimulatedPortfolioUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(observePortfolioUseCase: ObserveSimulatedPortfolioUseCase) {
        self.observePortfolioUseCase = observePortfolioUseCase
    }
    
    func startObserving() {
        observePortfolioUseCase.execute()
            .sink(receiveCompletion: { _ in}) { portfolio in
                print(portfolio.balance)
            }
            .store(in: &cancellables)
    }
}

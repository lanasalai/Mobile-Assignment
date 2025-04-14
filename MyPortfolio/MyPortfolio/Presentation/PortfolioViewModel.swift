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
    
    @Published var portfolio: Portfolio = .empty
    
    init(observePortfolioUseCase: ObserveSimulatedPortfolioUseCase) {
        self.observePortfolioUseCase = observePortfolioUseCase
    }
    
    func startObserving() {
        observePortfolioUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in}) { [weak self] in
                self?.portfolio = $0 }
            .store(in: &cancellables)
    }
}

extension Portfolio {
    static let empty = Portfolio(balance: Balance(netValue: 0, pnl: 0, pnlPercentage: 0), positions: [])
}

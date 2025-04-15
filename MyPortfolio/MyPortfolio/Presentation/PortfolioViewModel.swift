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
    
    @Published var portfolio: PortfolioUIModel = .empty
    
    init(observePortfolioUseCase: ObserveSimulatedPortfolioUseCase) {
        self.observePortfolioUseCase = observePortfolioUseCase
    }
    
    func startObserving() {
        observePortfolioUseCase.execute()
            .map { $0.toUIModel() }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in}) { [weak self] in
                self?.portfolio = $0
            }
            .store(in: &cancellables)
    }
}

private extension Portfolio {
    func toUIModel() -> PortfolioUIModel {
        PortfolioUIModel(balance: balance.toUIModel(), positions: positions.map { $0.toUIModel() })
    }
}

private extension Balance {
    func toUIModel() -> BalanceUIModel {
        BalanceUIModel(netValue: netValue.twoDecimalString(),
                       pnlPercentage: "\(pnlPercentage.twoDecimalString()) %",
                       pnlColor: pnlPercentage > 0 ? .green : .red)
    }
}

private extension Position {
    func toUIModel() -> PositionUIModel {
        PositionUIModel(name: instrument.name,
                        color: Ticker(rawValue: instrument.ticker)?.color ?? .clear,
                        lastTradedPrice: instrument.lastTradedPrice.twoDecimalString(),
                        quantity: "\(quantity.twoDecimalString()) \(instrument.ticker)",
                        marketValue: marketValue.twoDecimalString(),
                        pnlPercentage: "\(pnlPercentage.twoDecimalString()) %",
                        pnlColor: pnlPercentage > 0 ? .green : .red)
    }
}

private extension Double {
    func twoDecimalString() -> String {
        String(format: "%0.2f", self)
    }
}

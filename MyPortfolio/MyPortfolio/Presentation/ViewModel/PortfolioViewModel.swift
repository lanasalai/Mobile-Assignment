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
        let positionsUIModels = positions.map { $0.toUIModel() }
        return PortfolioUIModel(balance: balance.toUIModel(), 
                                positions: positionsUIModels,
                                chartModel: ChartUIModel(values: positions.map { $0.marketValue },
                                                         colors: positionsUIModels.map { $0.color }))
    }
}

private extension Balance {
    func toUIModel() -> BalanceUIModel {
        BalanceUIModel(netValue: netValue.twoDecimalString(),
                       pnlPercentage: "\(pnlPercentage.twoDecimalString()) %",
                       pnlColor: pnlPercentage > 0 ? MyColor.positive : MyColor.negative)
    }
}

private extension Position {
    func toUIModel() -> PositionUIModel {
        PositionUIModel(name: instrument.name,
                        color: Ticker(rawValue: instrument.ticker)?.color ?? .clear,
                        lastTradedPrice: currencySymbol(instrument.currency) + instrument.lastTradedPrice.twoDecimalString(),
                        quantity: "\(quantity.twoDecimalString()) \(instrument.ticker)",
                        marketValue: currencySymbol(instrument.currency) + marketValue.twoDecimalString(),
                        pnlPercentage: "\(pnlPercentage.twoDecimalString()) %",
                        pnlColor: pnlPercentage > 0 ? MyColor.positive : MyColor.negative)
    }
}

private extension Double {
    func twoDecimalString() -> String {
        String(format: "%0.2f", self)
    }
}

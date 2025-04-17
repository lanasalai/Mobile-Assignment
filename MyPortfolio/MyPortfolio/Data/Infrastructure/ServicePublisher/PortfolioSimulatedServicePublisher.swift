//
//  PortfolioSimulatedServicePublisher.swift
//  MyPortfolio
//
//  Created by Lana Salai on 12.4.25..
//

import Foundation
import Combine

class PortfolioSimulatedServicePublisher: PortfolioPublisher {
    private let dataSource: RemotePortfolioDataSource
    private let simulationService: PercentagesSimulationService
    private let subject = PassthroughSubject<ManipulatedPortfolio, Error>()
    private var cancellables = Set<AnyCancellable>()
    
    init(dataSource: RemotePortfolioDataSource, 
         simulationService: PercentagesSimulationService) {
        self.dataSource = dataSource
        self.simulationService = simulationService
    }
    
    func fetchPortfolioPublisher() -> AnyPublisher<ManipulatedPortfolio, any Error> {
        dataSource.fetchPortfolio { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .failure(error):
                self.subject.send(completion: .failure(error))
            case let .success(remotePortfolio):
                self.simulationService.generatePercentagesPublisher(count: remotePortfolio.positions.count)
                    .sink { percentages in
                        if percentages.count == remotePortfolio.positions.count {
                            let manipulatedPortfolio = remotePortfolio.manipulate(priceChanges: percentages)
                            self.subject.send(manipulatedPortfolio)
                        }
                    }
                    .store(in: &cancellables)
            }
        }
        return subject.eraseToAnyPublisher()
    }
}

private extension RemotePortfolio {
    func manipulate(priceChanges: [Double]) -> ManipulatedPortfolio {
        ManipulatedPortfolio(positions: positions.enumerated().map { index, position in
            position.manipulate(priceChangePercentage: priceChanges[index]) })
    }
}

private extension RemotePosition {
    func manipulate(priceChangePercentage change: Double) -> ManipulatedPosition {
        ManipulatedPosition(instrument: instrument.manipulate(priceChangePercentage: change),
                            quantity: quantity,
                            averagePrice: averagePrice,
                            cost: cost)
    }
}

private extension RemoteInstrument {
    func manipulate(priceChangePercentage change: Double) -> ManipulatedInstrument {
        let newTradedPrice = lastTradedPrice * (1.0 + change)
        return ManipulatedInstrument(ticker: ticker,
                                     name: name,
                                     exchange: exchange,
                                     currency: currency,
                                     lastTradedPrice: newTradedPrice)
    }
}

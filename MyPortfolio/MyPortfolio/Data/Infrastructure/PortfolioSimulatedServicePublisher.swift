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
    private let subject = PassthroughSubject<ManipulatedPortfolio, Error>()
    private var timer: AnyCancellable?
    
    init(dataSource: RemotePortfolioDataSource) {
        self.dataSource = dataSource
    }
    
    func fetchPortfolioPublisher() -> AnyPublisher<ManipulatedPortfolio, any Error> {
        dataSource.fetchPortfolio { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .failure(error):
                self.subject.send(completion: .failure(error))
            case let .success(remotePortfolio):
                self.startSimulation(with: remotePortfolio)
            }
        }
        
        return subject.eraseToAnyPublisher()
    }
    
    private func startSimulation(with initial: RemotePortfolio) {
        timer = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                let priceChanges = (0..<initial.positions.count).map { _ in
                    Bool.random() ? -0.1 : 0.1
                }
                self.subject.send(initial.manipulate(priceChanges: priceChanges))
            })
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

//(Bool.random() ? -0.1 : 0.1)
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

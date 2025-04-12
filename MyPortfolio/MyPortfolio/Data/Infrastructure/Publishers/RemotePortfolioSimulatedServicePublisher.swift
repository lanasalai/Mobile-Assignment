//
//  RemotePortfolioSimulatedServicePublisher.swift
//  MyPortfolio
//
//  Created by Lana Salai on 12.4.25..
//

import Foundation
import Combine

class RemotePortfolioSimulatedServicePublisher: RemotePortfolioPublisher {
    private let dataSource: RemotePortfolioDataSource
    private let subject = PassthroughSubject<ManipulatedPortfolio, Error>()
    private var timer: AnyCancellable?
    
    init(dataSource: RemotePortfolioDataSource) {
        self.dataSource = dataSource
    }
    
    func fetchPortfolioPublisher() -> AnyPublisher<ManipulatedPortfolio, any Error> {
        dataSource.fetchPortfolio { result in
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
            .sink(receiveValue: { _ in
                self.subject.send(initial.manipulate())
            })
    }
}

private extension RemotePortfolio {
    func manipulate() -> ManipulatedPortfolio {
        ManipulatedPortfolio(positions: positions.map { $0.manipulate() })
    }
}

private extension RemotePosition {
    func manipulate() -> ManipulatedPosition {
        ManipulatedPosition(instrument: instrument.manipulate(),
                            quantity: quantity,
                            averagePrice: averagePrice,
                            cost: cost)
    }
}

private extension RemoteInstrument {
    func manipulate() -> ManipulatedInstrument {
        let newTradedPrice = lastTradedPrice * (1.0 + (Bool.random() ? -0.1 : 0.1))
        return ManipulatedInstrument(ticker: ticker,
                                     name: name,
                                     exchange: exchange,
                                     currency: currency,
                                     lastTradedPrice: newTradedPrice)
    }
}

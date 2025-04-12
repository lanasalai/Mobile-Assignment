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
    private let subject = PassthroughSubject<RemotePortfolio, Error>()
    private var timer: AnyCancellable?
    
    init(dataSource: RemotePortfolioDataSource) {
        self.dataSource = dataSource
    }
    
    func fetchPortfolioPublisher() -> AnyPublisher<RemotePortfolio, any Error> {
        dataSource.fetchPortfolio { result in
            if case let .success(portfolio) = result {
                self.startSimulation(with: portfolio)
            }
        }
        
        return subject.eraseToAnyPublisher()
    }
    
    private func startSimulation(with initial: RemotePortfolio) {
        timer = Timer.publish(every: 3.0, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: { _ in
                let manipulatedPortfolio = initial.manipulate()
                self.subject.send(manipulatedPortfolio.toRemote())
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

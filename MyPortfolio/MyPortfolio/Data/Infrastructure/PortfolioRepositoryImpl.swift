//
//  PortfolioRepositoryImpl.swift
//  MyPortfolio
//
//  Created by Lana Salai on 12.4.25..
//

import Combine

class PortfolioRepositoryImpl: PortfolioRepository {
    private let service: RemotePortfolioPublisher
    
    init(service: RemotePortfolioPublisher) {
        self.service = service
    }
    
    func fetchPortfolio() -> AnyPublisher<Portfolio, Error> {
        service.fetchPortfolioPublisher()
            .map { $0.toEntity() }
            .eraseToAnyPublisher()
    }
}

private extension ManipulatedPortfolio {
    func toEntity() -> Portfolio {
        Portfolio(balance: balance.toEntity(), 
                  positions: positions.map { $0.toEntity() })
    }
}

private extension ManipulatedBalance {
    func toEntity() -> Balance {
        Balance(netValue: netValue, 
                pnl: pnl,
                pnlPercentage: pnlPercentage)
    }
}

private extension ManipulatedPosition {
    func toEntity() -> Position {
        Position(instrument: instrument.toEntity(), 
                 quantity: quantity,
                 averagePrice: averagePrice,
                 cost: cost,
                 marketValue: marketValue,
                 pnl: pnl,
                 pnlPercentage: pnlPercentage)
    }
}

private extension ManipulatedInstrument {
    func toEntity() -> Instrument {
        Instrument(ticker: ticker, 
                   name: name,
                   exchange: exchange,
                   currency: currency,
                   lastTradedPrice: lastTradedPrice)
    }
}





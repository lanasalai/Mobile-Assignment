//
//  ManipulatedInstrument.swift
//  MyPortfolio
//
//  Created by Lana Salai on 12.4.25..
//

struct ManipulatedInstrument {
    let ticker: String
    let name: String
    let exchange: String
    let currency: String
    var lastTradedPrice: Double
}

extension ManipulatedInstrument {
    func toRemote() -> RemoteInstrument {
        RemoteInstrument(ticker: self.ticker,
                         name: self.name,
                         exchange: self.exchange,
                         currency: self.currency,
                         lastTradedPrice: self.lastTradedPrice)
    }
}

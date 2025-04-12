//
//  ManipulatedPosition.swift
//  MyPortfolio
//
//  Created by Lana Salai on 12.4.25..
//

struct ManipulatedPosition {
    let instrument: ManipulatedInstrument
    let quantity: Double
    let averagePrice: Double
    let cost: Double
    var marketValue: Double {
        quantity * instrument.lastTradedPrice
    }
    var pnl: Double {
        marketValue - cost
    }
    var pnlPercentage: Double {
        (pnl * 100) / cost
    }
}

extension ManipulatedPosition {
    func toRemote() -> RemotePosition {
        RemotePosition(instrument: self.instrument.toRemote(),
                       quantity: self.quantity,
                       averagePrice: self.averagePrice,
                       cost: self.cost,
                       marketValue: self.marketValue,
                       pnl: self.pnl,
                       pnlPercentage: self.pnlPercentage)
    }
}

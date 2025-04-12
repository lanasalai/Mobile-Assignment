//
//  ManipulatedPortfolio.swift
//  MyPortfolio
//
//  Created by Lana Salai on 12.4.25..
//

struct ManipulatedPortfolio {
    var balance: ManipulatedBalance {
        let sumOfMarketValues = positions.reduce(0) { $0 + $1.marketValue }
        let sumOfPnl = positions.reduce(0) { $0 + $1.pnl }
        let sumOfCosts = positions.reduce(0) { $0 + $1.cost }
        return ManipulatedBalance(netValue: sumOfMarketValues,
                                  pnl: sumOfPnl,
                                  pnlPercentage: (sumOfPnl * 100) / sumOfCosts)
    }
    var positions: [ManipulatedPosition]
}

extension ManipulatedPortfolio {
    func toRemote() -> RemotePortfolio {
        RemotePortfolio(balance: self.balance.toRemote(), positions: self.positions.map { $0.toRemote() })
    }
}

//
//  MutablePortfolio.swift
//  MyPortfolio
//
//  Created by Lana Salai on 12.4.25..
//

struct MutablePortfolio {
    var balance: MutableBalance {
        let sumOfMarketValues = positions.reduce(0) { $0 + $1.marketValue }
        let sumOfPnl = positions.reduce(0) { $0 + $1.pnl }
        let sumOfCosts = positions.reduce(0) { $0 + $1.cost }
        let mutableBalance = MutableBalance(netValue: sumOfMarketValues,
                                            pnl: sumOfPnl,
                                            pnlPercentage: (sumOfPnl * 100) / sumOfCosts)
        return mutableBalance
    }
    var positions: [MutablePosition]
}

extension MutablePortfolio {
    func toRemote() -> RemotePortfolio {
        RemotePortfolio(balance: self.balance.toRemote(), positions: self.positions.map { mutablePosition in
            mutablePosition.toRemote()
        })
    }
}

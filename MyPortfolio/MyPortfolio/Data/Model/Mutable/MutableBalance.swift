//
//  MutableBalance.swift
//  MyPortfolio
//
//  Created by Lana Salai on 12.4.25..
//

struct MutableBalance {
    var netValue: Double
    var pnl: Double
    var pnlPercentage: Double
}

extension MutableBalance {
    func toRemote() -> RemoteBalance {
        RemoteBalance(netValue: self.netValue, pnl: self.pnl, pnlPercentage: self.pnlPercentage)
    }
}

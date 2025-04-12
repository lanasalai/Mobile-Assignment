//
//  RemotePortfolio.swift
//  MyPortfolio
//
//  Created by Lana Salai on 12.4.25..
//

struct RemotePortfolio: Decodable {
    let balance: RemoteBalance
    let positions: [RemotePosition]
    
    var calculatedBalanceNet: Double {
        let balance = positions.reduce(0) { $0 + $1.marketValue }
        print("Remote calculated balance: \(balance)")
        return balance
    }
}

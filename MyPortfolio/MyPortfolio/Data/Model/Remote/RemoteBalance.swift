//
//  RemoteBalance.swift
//  MyPortfolio
//
//  Created by Lana Salai on 12.4.25..
//

struct RemoteBalance: Decodable, Equatable {
    let netValue: Double
    let pnl: Double
    let pnlPercentage: Double
}

//
//  RemotePosition.swift
//  MyPortfolio
//
//  Created by Lana Salai on 12.4.25..
//

struct RemotePosition: Decodable {
    let instrument: RemoteInstrument
    let quantity: Double
    let averagePrice: Double
    let cost: Double
    let marketValue: Double
    let pnl: Double
    let pnlPercentage: Double
}

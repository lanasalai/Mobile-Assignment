//
//  RemoteInstrument.swift
//  MyPortfolio
//
//  Created by Lana Salai on 12.4.25..
//

struct RemoteInstrument: Decodable {
    let ticker: String
    let name: String
    let exchange: String
    let currency: String
    let lastTradedPrice: Double
}

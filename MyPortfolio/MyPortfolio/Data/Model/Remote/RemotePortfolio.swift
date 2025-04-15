//
//  RemotePortfolio.swift
//  MyPortfolio
//
//  Created by Lana Salai on 12.4.25..
//

struct RemotePortfolio: Decodable, Equatable {
    let balance: RemoteBalance
    let positions: [RemotePosition]
}

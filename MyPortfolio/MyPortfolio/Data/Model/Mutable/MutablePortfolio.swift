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
    static func fromRemote(_ remotePortfolio: RemotePortfolio) -> MutablePortfolio {
        let mutablePortfolio = MutablePortfolio(positions: remotePortfolio.positions.map { remotePosition in
            let mutablePosition = MutablePosition.fromRemote(remotePosition)
            return mutablePosition
        })
        return mutablePortfolio
    }
    
    func toRemote() -> RemotePortfolio {
        RemotePortfolio(balance: self.balance.toRemote(), positions: self.positions.map { mutablePosition in
            mutablePosition.toRemote()
        })
    }
}

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

struct MutablePosition {
    let instrument: MutableInstrument
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

extension MutablePosition {
    static func fromRemote(_ remotePosition: RemotePosition) -> MutablePosition {
        let mutablePosition = MutablePosition(instrument: MutableInstrument.fromRemote(remotePosition.instrument),
                                              quantity: remotePosition.quantity,
                                              averagePrice: remotePosition.averagePrice,
                                              cost: remotePosition.cost)
        return mutablePosition
    }
    
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

struct MutableInstrument {
    let ticker: String
    let name: String
    let exchange: String
    let currency: String
    var lastTradedPrice: Double
}

extension MutableInstrument {
    static func fromRemote(_ remoteInstrument: RemoteInstrument) -> MutableInstrument {
        let newTradedPrice = remoteInstrument.lastTradedPrice * (1.0 + (Bool.random() ? -0.1 : 0.1))
        let mutableInstrument = MutableInstrument(ticker: remoteInstrument.ticker,
                                                  name: remoteInstrument.name,
                                                  exchange: remoteInstrument.exchange,
                                                  currency: remoteInstrument.currency,
                                                  lastTradedPrice: newTradedPrice)
        return mutableInstrument
    }
    
    func toRemote() -> RemoteInstrument {
        RemoteInstrument(ticker: self.ticker,
                         name: self.name,
                         exchange: self.exchange,
                         currency: self.currency,
                         lastTradedPrice: self.lastTradedPrice)
    }
}

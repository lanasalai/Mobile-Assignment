//
//  PortfolioUIModel.swift
//  MyPortfolio
//
//  Created by Lana Salai on 15.4.25..
//

struct PortfolioUIModel {
    var balance: BalanceUIModel
    var positions: [PositionUIModel]
    var chartModel: ChartUIModel
}

extension PortfolioUIModel {
    static let empty = PortfolioUIModel(balance: BalanceUIModel(netValue: "", pnlPercentage: "", pnlColor: .clear), 
                                        positions: [],
                                        chartModel: ChartUIModel(entries: [], colors: []))
}

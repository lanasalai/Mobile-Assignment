//
//  PortfolioUIModel.swift
//  MyPortfolio
//
//  Created by Lana Salai on 15.4.25..
//

struct PortfolioUIModel {
    var balance: BalanceUIModel
    var positions: [PositionUIModel]
}

extension PortfolioUIModel {
    static let empty = PortfolioUIModel(balance: BalanceUIModel(netValue: "", pnlPercentage: ""), positions: [])
}

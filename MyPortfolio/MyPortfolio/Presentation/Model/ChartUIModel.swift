//
//  ChartUIModel.swift
//  MyPortfolio
//
//  Created by Lana Salai on 17.4.25..
//

import DGCharts

struct ChartUIModel {
    let entries: [PieChartDataEntry]
    let colors: [Color]
}

extension ChartUIModel {
    static func create(from positions: [Position]) -> ChartUIModel {
        let entries = positions.map { PieChartDataEntry(value: $0.marketValue) }
        let colors = positions.map { Ticker(rawValue: $0.instrument.ticker)?.color ?? .clear}

        return ChartUIModel(entries: entries, colors: colors)
    }
}

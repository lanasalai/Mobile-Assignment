//
//  HeaderView.swift
//  MyPortfolio
//
//  Created by Lana Salai on 14.4.25..
//

import UIKit
import DGCharts

class HeaderView: UICollectionReusableView {
    static let identifier = String(describing: HeaderView.self)
    
    private let balanceLabel = UILabel()
    private let pnlLabel = UILabel()
    private let pieChartView = PieChartView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        setupChart()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    func configure(balance: BalanceUIModel, chartModel: ChartUIModel) {
        balanceLabel.text = balance.netValue
        pnlLabel.text = balance.pnlPercentage
        pnlLabel.textColor = balance.pnlColor
        configureChartWithModel(chartModel)
    }
}

extension HeaderView {
    func layout() {
        balanceLabel.adjustsFontForContentSizeCategory = true
        balanceLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        balanceLabel.textColor = MyColor.primaryText
        
        pnlLabel.adjustsFontForContentSizeCategory = true
        pnlLabel.font = UIFont.preferredFont(forTextStyle: .body)
        
        [balanceLabel, pnlLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            balanceLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            balanceLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            pnlLabel.centerXAnchor.constraint(equalTo: balanceLabel.centerXAnchor),
            pnlLabel.topAnchor.constraint(equalTo: balanceLabel.bottomAnchor, constant: 10)
        ])
        
        pieChartView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(pieChartView)
        
        NSLayoutConstraint.activate([
            pieChartView.centerXAnchor.constraint(equalTo: centerXAnchor),
            pieChartView.centerYAnchor.constraint(equalTo: centerYAnchor),
            pieChartView.widthAnchor.constraint(equalToConstant: 300),
            pieChartView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func setupChart() {
        pieChartView.legend.enabled = false
        pieChartView.holeRadiusPercent = 0.95
        pieChartView.holeColor = .clear
        pieChartView.rotationEnabled = false
        pieChartView.highlightPerTapEnabled = false
    }
    
    private func configureChartWithModel(_ model: ChartUIModel) {
        let dataSet = PieChartDataSet(entries: model.entries, label: "")
        dataSet.colors = model.colors
        dataSet.drawValuesEnabled = false
        dataSet.sliceSpace = 2
        pieChartView.data = PieChartData(dataSet: dataSet)
        pieChartView.notifyDataSetChanged()
    }
}

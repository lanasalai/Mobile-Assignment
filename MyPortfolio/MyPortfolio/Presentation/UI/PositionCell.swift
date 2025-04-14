//
//  PositionCell.swift
//  MyPortfolio
//
//  Created by Lana Salai on 14.4.25..
//

import UIKit

class PositionCell: UICollectionViewCell {
    static let identifier = String(describing: PositionCell.self)
    
    let colorView = UIView()
    let nameLabel = UILabel()
    let lastTradedPriceLabel = UILabel()
    let quantityLabel = UILabel()
    let marketValueLabel = UILabel()
    let pnlLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .gray
        layer.cornerRadius = 6
        layer.masksToBounds = true
        setupSubviews()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    //TODO: implement
    func configure() {
        colorView.backgroundColor = .yellow
        nameLabel.text = "Name"
        lastTradedPriceLabel.text = "last traded price"
        quantityLabel.text = "quantity"
        marketValueLabel.text = "market value"
        pnlLabel.text = "pnl%"
        pnlLabel.textColor = .green
    }
}

extension PositionCell {
    func setupSubviews() {
        nameLabel.adjustsFontForContentSizeCategory = true
        nameLabel.font = UIFont.preferredFont(forTextStyle: .body)
        nameLabel.textColor = .label
        
        lastTradedPriceLabel.adjustsFontForContentSizeCategory = true
        lastTradedPriceLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        lastTradedPriceLabel.textColor = .secondaryLabel

        quantityLabel.adjustsFontForContentSizeCategory = true
        quantityLabel.font = UIFont.preferredFont(forTextStyle: .body)
        quantityLabel.textColor = .label

        marketValueLabel.adjustsFontForContentSizeCategory = true
        marketValueLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        marketValueLabel.textColor = .purple

        pnlLabel.adjustsFontForContentSizeCategory = true
        pnlLabel.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    func layout() {
        let verticalSpacing = CGFloat(4)
        let horizontalSpacing = CGFloat(8)
        let inset = CGFloat(10)
        
        let leftStack = UIStackView(arrangedSubviews: [nameLabel, lastTradedPriceLabel])
        leftStack.axis = .vertical
        leftStack.spacing = verticalSpacing
        
        let rightStackV = UIStackView(arrangedSubviews: [quantityLabel, marketValueLabel])
        rightStackV.axis = .vertical
        rightStackV.spacing = verticalSpacing
        rightStackV.alignment = .trailing
        
        let rightStackH = UIStackView(arrangedSubviews: [pnlLabel, rightStackV])
        rightStackH.axis = .horizontal
        rightStackH.spacing = horizontalSpacing

        let mainStack = UIStackView(arrangedSubviews: [colorView, leftStack, UIView(), rightStackH])
        mainStack.axis = .horizontal
        mainStack.spacing = horizontalSpacing
        mainStack.alignment = .center
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(mainStack)

        NSLayoutConstraint.activate([
            colorView.widthAnchor.constraint(equalToConstant: 15),
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset)
        ])
    }
}

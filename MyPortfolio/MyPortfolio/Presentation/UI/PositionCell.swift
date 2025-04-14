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
    }
}

extension PositionCell {
    func layout() {
        colorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(colorView)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.adjustsFontForContentSizeCategory = true
        nameLabel.font = UIFont.preferredFont(forTextStyle: .body)
        nameLabel.textColor = .label
        contentView.addSubview(nameLabel)
        
        lastTradedPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        lastTradedPriceLabel.adjustsFontForContentSizeCategory = true
        lastTradedPriceLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        lastTradedPriceLabel.textColor = .secondaryLabel
        contentView.addSubview(lastTradedPriceLabel)
        
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
        quantityLabel.adjustsFontForContentSizeCategory = true
        quantityLabel.font = UIFont.preferredFont(forTextStyle: .body)
        quantityLabel.textColor = .label
        contentView.addSubview(quantityLabel)
        
        marketValueLabel.translatesAutoresizingMaskIntoConstraints = false
        marketValueLabel.adjustsFontForContentSizeCategory = true
        marketValueLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        marketValueLabel.textColor = .purple
        contentView.addSubview(marketValueLabel)
        
        pnlLabel.translatesAutoresizingMaskIntoConstraints = false
        pnlLabel.adjustsFontForContentSizeCategory = true
        pnlLabel.font = UIFont.preferredFont(forTextStyle: .body)
        pnlLabel.textColor = .green
        contentView.addSubview(pnlLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 20),
            
            nameLabel.leadingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: inset),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            nameLabel.trailingAnchor.constraint(greaterThanOrEqualTo: pnlLabel.leadingAnchor, constant: inset),
            
            lastTradedPriceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            lastTradedPriceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: inset),
            
            quantityLabel.leadingAnchor.constraint(equalTo: pnlLabel.trailingAnchor, constant: inset),
            quantityLabel.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            quantityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            
            marketValueLabel.trailingAnchor.constraint(equalTo: quantityLabel.trailingAnchor),
            marketValueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: lastTradedPriceLabel.trailingAnchor, constant: inset),
            marketValueLabel.topAnchor.constraint(equalTo: lastTradedPriceLabel.topAnchor),
            
            pnlLabel.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            pnlLabel.bottomAnchor.constraint(equalTo: quantityLabel.bottomAnchor)
        ])
    }
}

//
//  HeaderView.swift
//  MyPortfolio
//
//  Created by Lana Salai on 14.4.25..
//

import UIKit

class HeaderView: UICollectionReusableView {
    static let identifier = String(describing: HeaderView.self)
    
    var balanceLabel = UILabel()
    var pnlLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    //TODO: implement
    func configure(balance: String, pnl: String) {
        balanceLabel.text = balance
        pnlLabel.text = pnl
        pnlLabel.textColor = .green
    }
}

extension HeaderView {
    func layout() {
        balanceLabel.adjustsFontForContentSizeCategory = true
        balanceLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        balanceLabel.textColor = .white
        
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
    }
}

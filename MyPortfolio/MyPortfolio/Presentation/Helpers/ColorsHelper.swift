//
//  ColorsHelper.swift
//  MyPortfolio
//
//  Created by Lana Salai on 15.4.25..
//

import UIKit

enum Ticker: String {
    case SXR8
    case GOOG
    case TPR
    case QCOM
    case TSCO

    var color: UIColor {
        switch self {
        case .SXR8: return .yellow
        case .GOOG: return .systemPink
        case .TPR: return .green
        case .QCOM: return .cyan
        case .TSCO: return .red
        }
    }
}

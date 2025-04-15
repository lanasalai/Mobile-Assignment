//
//  ColorsHelper.swift
//  MyPortfolio
//
//  Created by Lana Salai on 15.4.25..
//

import UIKit

typealias Color = UIColor

struct MyColor {
    static let primaryBackground = UIColor.primaryBackground
    static let secondaryBackground = UIColor.secondaryBackground
    static let primaryText = UIColor.white
    static let secondaryText = UIColor.white
    static let accentText = UIColor.accentPurple
    static let positive = UIColor.positive
    static let negative = UIColor.negative
}

enum Ticker: String {
    case SXR8
    case GOOG
    case TPR
    case QCOM
    case TSCO

    var color: UIColor {
        switch self {
        case .SXR8: return .accentOrange
        case .GOOG: return .accentPink
        case .TPR: return .accentGreen
        case .QCOM: return .accentYellow
        case .TSCO: return .accentBlue
        }
    }
}

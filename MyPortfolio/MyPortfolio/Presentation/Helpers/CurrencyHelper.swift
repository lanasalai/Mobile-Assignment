//
//  CurrencyHelper.swift
//  MyPortfolio
//
//  Created by Lana Salai on 15.4.25..
//

enum Currency: String {
    case USD, EUR, GBP

    var symbol: String {
        switch self {
        case .USD: return "$"
        case .EUR: return "€"
        case .GBP: return "£"
        }
    }
}

func currencySymbol(_ currency: String) -> String {
    Currency(rawValue: currency)?.symbol ?? currency
}

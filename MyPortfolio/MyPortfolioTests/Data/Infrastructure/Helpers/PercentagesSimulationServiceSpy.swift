//
//  PercentagesSimulationServiceSpy.swift
//  MyPortfolioTests
//
//  Created by Lana Salai on 16.4.25..
//

import Foundation
import Combine
@testable import MyPortfolio

final class PercentagesSimulationServiceSpy: PercentagesSimulationService {
    var messages = [Message]()
    
    enum Message: Equatable {
        case generatePercentagesPublisher(count: Int)
    }
    
    func generatePercentagesPublisher(count: Int) -> AnyPublisher<[Double], Never> {
        messages.append(.generatePercentagesPublisher(count: count))
        return Just([]).eraseToAnyPublisher()
    }
}

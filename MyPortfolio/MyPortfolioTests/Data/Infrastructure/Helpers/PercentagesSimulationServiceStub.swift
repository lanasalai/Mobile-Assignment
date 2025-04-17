//
//  PercentagesSimulationServiceStub.swift
//  MyPortfolioTests
//
//  Created by Lana Salai on 16.4.25..
//

import Foundation
import Combine
@testable import MyPortfolio

final class PercentagesSimulationServiceStub: PercentagesSimulationService {
    var stub: [Double]?
    
    func generatePercentagesPublisher(count: Int) -> AnyPublisher<[Double], Never> {
        guard let percentages = stub else {
            fatalError("Stub value is missing")
        }
        return Just(percentages).eraseToAnyPublisher()
    }
}

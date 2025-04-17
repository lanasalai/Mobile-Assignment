//
//  PercentagesSimulationService.swift
//  MyPortfolio
//
//  Created by Lana Salai on 16.4.25..
//

import Combine

protocol PercentagesSimulationService {
    func generatePercentagesPublisher(count: Int) -> AnyPublisher<[Double], Never>
}

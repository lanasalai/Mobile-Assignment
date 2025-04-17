//
//  PercentagesSimulationServiceImpl.swift
//  MyPortfolio
//
//  Created by Lana Salai on 16.4.25..
//

import Foundation
import Combine

final class PercentagesSimulationServiceImpl: PercentagesSimulationService {
    private var timer: AnyCancellable?
    private let generatePercentage: () -> Double
    private let subject = PassthroughSubject<[Double], Never>()
    
    init(generatePercentage: @escaping () -> Double) {
        self.generatePercentage = generatePercentage
    }
    
    func generatePercentagesPublisher(count: Int) -> AnyPublisher<[Double], Never> {
        timer = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: { [weak self] _ in
                let percentages = (0..<count).compactMap { [weak self] _ in
                    self?.generatePercentage()
                }
                self?.subject.send(percentages)
            })
        return subject.eraseToAnyPublisher()
    }
}

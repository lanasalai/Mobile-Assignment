//
//  RemotePortfolioPublisher.swift
//  MyPortfolio
//
//  Created by Lana Salai on 12.4.25..
//

import Foundation
import Combine

protocol RemotePortfolioPublisher {
    func fetchPortfolioPublisher() -> AnyPublisher<RemotePortfolio, Error>
}

class SimpleRemotePortfolioPublisher: RemotePortfolioPublisher {
    private let dataSource: RemotePortfolioDataSource
    
    init(dataSource: RemotePortfolioDataSource) {
        self.dataSource = dataSource
    }
    
    func fetchPortfolioPublisher() -> AnyPublisher<RemotePortfolio, Error> {
        Future { promise in
            self.dataSource.fetchPortfolio { result in
                promise(result)
            }
        }
        .eraseToAnyPublisher()
    }
}

class SimulatedRemotePortfolioServicePublisher: RemotePortfolioPublisher {
    private let dataSource: RemotePortfolioDataSource
    private let subject = PassthroughSubject<RemotePortfolio, Error>()
    private var timer: AnyCancellable?
    
    init(dataSource: RemotePortfolioDataSource) {
        self.dataSource = dataSource
    }
    
    func fetchPortfolioPublisher() -> AnyPublisher<RemotePortfolio, any Error> {
        dataSource.fetchPortfolio { result in
            if case let .success(portfolio) = result {
                self.startSimulation(with: portfolio)
            }
        }
        
        return subject.eraseToAnyPublisher()
    }
    
    private func startSimulation(with initial: RemotePortfolio) {
        timer = Timer.publish(every: 3.0, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: { _ in
                let manipulatedPortfolio = MutablePortfolio.fromRemote(initial)
                self.subject.send(manipulatedPortfolio.toRemote())
            })
    }
}

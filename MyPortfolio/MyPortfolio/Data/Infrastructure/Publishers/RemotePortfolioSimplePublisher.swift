//
//  RemotePortfolioSimplePublisher.swift
//  MyPortfolio
//
//  Created by Lana Salai on 12.4.25..
//

import Combine

class RemotePortfolioSimplePublisher {
    private let dataSource: RemotePortfolioDataSource
    
    init(dataSource: RemotePortfolioDataSource) {
        self.dataSource = dataSource
    }
    
    func fetchPortfolioPublisher() -> AnyPublisher<RemotePortfolio, Error> {
        Future { [weak self] promise in
            guard let self = self else { return }
            self.dataSource.fetchPortfolio { result in
                promise(result)
            }
        }
        .eraseToAnyPublisher()
    }
}

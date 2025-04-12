//
//  RemotePortfolioSimplePublisher.swift
//  MyPortfolio
//
//  Created by Lana Salai on 12.4.25..
//

import Combine

class RemotePortfolioSimplePublisher: RemotePortfolioPublisher {
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

//
//  RemotePortfolioDataSourceStub.swift
//  MyPortfolioTests
//
//  Created by Lana Salai on 16.4.25..
//

import Foundation
@testable import MyPortfolio

final class RemotePortfolioDataSourceStub: RemotePortfolioDataSource {
    var stub: RemotePortfolio?
    
    func fetchPortfolio(_ completion: @escaping (RemotePortfolioDataSource.Result) -> Void) {
        guard let portfolio = stub else {
            fatalError("Stub value is missing")
        }
        completion(.success(portfolio))
    }
}

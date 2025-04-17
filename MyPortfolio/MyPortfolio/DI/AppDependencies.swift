//
//  AppDependencies.swift
//  MyPortfolio
//
//  Created by Lana Salai on 16.4.25..
//

import Foundation

private let url = URL(string: "https://dummyjson.com/c/60b7-70a6-4ee3-bae8")!

let httpClient: HTTPClient = {
    URLSessionHTTPClient()
}()

let portfolioRequestProvider: URLRequestProvider = {
    PortfolioURLRequestProvider(url: url)
}()

let remotePortfolioDataSource: RemotePortfolioDataSource = {
    RemotePortfolioDataSourceImpl(httpClient: httpClient,
                                  requestProvider: portfolioRequestProvider)
}()

let portfolioServicePublisher: PortfolioPublisher = {
    PortfolioSimulatedServicePublisher(dataSource: remotePortfolioDataSource,
                                       simulationService: PercentagesSimulationServiceImpl(generatePercentage: {
        Bool.random() ? 0.1 : -0.1
    }))
}()

let portfolioRepository: PortfolioRepository = {
    PortfolioRepositoryImpl(service: portfolioServicePublisher)
}()

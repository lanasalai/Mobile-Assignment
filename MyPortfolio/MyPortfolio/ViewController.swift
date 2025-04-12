//
//  ViewController.swift
//  MyPortfolio
//
//  Created by Lana Salai on 12.4.25..
//

import UIKit
import Combine

class ViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //TODO: remove
        let dataSource = RemotePortfolioDataSourceImpl(httpClient: URLSessionHTTPClient(),
                                                       requestProvider: PortfolioURLRequestProvider(url: URL(string: "https://dummyjson.com/c/60b7-70a6-4ee3-bae8")!))
        let simplePublisher = RemotePortfolioSimplePublisher(dataSource: dataSource)
        let servicePublisher = RemotePortfolioSimulatedServicePublisher(dataSource: dataSource)
        
        servicePublisher.fetchPortfolioPublisher()
            .sink { _ in
                
            } receiveValue: { remotePortfolio in
                print(remotePortfolio.balance.netValue)
            }
            .store(in: &cancellables)
    }


}


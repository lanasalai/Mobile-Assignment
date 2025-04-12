//
//  ViewController.swift
//  MyPortfolio
//
//  Created by Lana Salai on 12.4.25..
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //TODO: remove
        let dataSource = RemotePortfolioDataSourceImpl(httpClient: URLSessionHTTPClient(),
                                                       requestProvider: PortfolioURLRequestProvider(url: URL(string: "https://dummyjson.com/c/60b7-70a6-4ee3-bae8")!))
        dataSource.fetchPortfolio { result in
            switch result {
            case let .failure(error):
                print(error)
            case let .success(remotePortfolio):
                print(remotePortfolio)
            }
        }
    }


}


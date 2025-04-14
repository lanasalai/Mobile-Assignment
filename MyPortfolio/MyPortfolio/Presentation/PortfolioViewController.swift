//
//  PortfolioViewController.swift
//  MyPortfolio
//
//  Created by Lana Salai on 12.4.25..
//

import UIKit
import Combine

class PortfolioViewController: UIViewController {
    private let repository: PortfolioRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: PortfolioRepository) {
        self.repository = repository
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //TODO: remove
        repository.fetchPortfolio()
            .sink { _ in } receiveValue: { portfolio in
                print(portfolio.balance.netValue)
            }
            .store(in: &cancellables)
    }


}


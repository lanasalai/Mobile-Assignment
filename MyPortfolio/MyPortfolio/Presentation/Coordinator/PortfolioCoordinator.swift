//
//  PortfolioCoordinator.swift
//  MyPortfolio
//
//  Created by Lana Salai on 17.4.25..
//

import UIKit

class PortfolioCoordinator: Coordinator {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let useCase = ObserveSimulatedPortfolioUseCase(repository: portfolioRepository)
        let viewModel = PortfolioViewModel(observePortfolioUseCase: useCase)
        let viewController = PortfolioViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: false)
    }
}

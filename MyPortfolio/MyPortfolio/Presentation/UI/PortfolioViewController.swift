//
//  PortfolioViewController.swift
//  MyPortfolio
//
//  Created by Lana Salai on 12.4.25..
//

import UIKit

class PortfolioViewController: UIViewController {
    private let viewModel: PortfolioViewModel
    private var collectionView: UICollectionView!
    
    init(viewModel: PortfolioViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        viewModel.startObserving()
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.dataSource = self
        collectionView.register(PositionCell.self, forCellWithReuseIdentifier: PositionCell.identifier)
        view.addSubview(collectionView)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let item = CompositionalLayout.item(width: .fractionalWidth(1), height: .fractionalHeight(1), spacing: 2)
        let group = CompositionalLayout.verticalGroup(width: .fractionalWidth(1), height: .estimated(80), item: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension PortfolioViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //TODO: LANA - change
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PositionCell.identifier, for: indexPath) as! PositionCell
        cell.configure()
        return cell
    }
}


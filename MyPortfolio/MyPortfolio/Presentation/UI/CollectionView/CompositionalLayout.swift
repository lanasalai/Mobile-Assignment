//
//  CompositionalLayout.swift
//  MyPortfolio
//
//  Created by Lana Salai on 14.4.25..
//

import UIKit

struct CompositionalLayout {
    static func item(width: NSCollectionLayoutDimension, 
                     height: NSCollectionLayoutDimension,
                     spacing: CGFloat) -> NSCollectionLayoutItem {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: width,
                                                                             heightDimension: height))
        item.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        return item
    }
    
    static func verticalGroup(width: NSCollectionLayoutDimension,
                              height: NSCollectionLayoutDimension,
                              item: NSCollectionLayoutItem,
                              count: Int) -> NSCollectionLayoutGroup {
        let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: width,
                                                                                        heightDimension: height),
                                                     subitem: item,
                                                     count: count)
        return group
    }
    
    static func header(width: NSCollectionLayoutDimension,
                       height: NSCollectionLayoutDimension) -> NSCollectionLayoutBoundarySupplementaryItem {
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: width, 
                                                                                                    heightDimension: height),
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        return header
    }
}

//
//  ViewController.swift
//  CompositionalLayouts
//
//  Created by Sergio on 03/08/22.
//

import UIKit

class ViewController: UICollectionViewController {
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Int>
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, Int>
    
    private lazy var cellProvider: DataSource.CellProvider = { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_id", for: indexPath)
        cell.backgroundColor = .label
        return cell
    }
    
    private lazy var dataSource: DataSource = {
        return DataSource(collectionView: self.collectionView, cellProvider: self.cellProvider)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell_id")
        
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems([0, 1, 2, 3])
        
        self.dataSource.apply(snapshot, animatingDifferences: false)
    }

    init() {
        super.init(collectionViewLayout: {
            let individualItem = NSCollectionLayoutItem(layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(2/3)
            ))
            individualItem.contentInsets = .init(
                top: 1,
                leading: 1,
                bottom: 1,
                trailing: 1
            )
            
            let tripletItem = NSCollectionLayoutItem(layoutSize: .init(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalHeight(1)
            ))
            tripletItem.contentInsets = .init(
                top: 1,
                leading: 1,
                bottom: 1,
                trailing: 1
            )
            let tripletGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(2/9)
            ), subitems: [tripletItem, tripletItem, tripletItem])
            
            let totalGroup = NSCollectionLayoutGroup.vertical(layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(8/9)
            ), subitems: [individualItem, tripletGroup])
            
            return UICollectionViewCompositionalLayout(section: .init(group: totalGroup))
        }())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

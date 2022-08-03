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
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(
                top: 2,
                leading: 16,
                bottom: 2,
                trailing: 16
            )
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(2/3)
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [item]
            )
            return UICollectionViewCompositionalLayout(section: .init(group: group))
        }())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

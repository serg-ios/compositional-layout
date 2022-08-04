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
    
    private lazy var supplementaryViewProvider: DataSource.SupplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
        if kind == "badge_kind" {
            let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "badge_id", for: indexPath)
            reusableView.backgroundColor = .lightGray
            reusableView.isHidden = indexPath.section > 0
            return reusableView
        } else if kind == "header_kind" {
            let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header_id", for: indexPath)
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = .preferredFont(forTextStyle: .largeTitle)
            label.text = "HEADER"
            label.textColor = .label
            reusableView.addSubview(label)
            label.topAnchor.constraint(equalTo: reusableView.topAnchor).isActive = true
            label.leadingAnchor.constraint(equalTo: reusableView.leadingAnchor).isActive = true
            label.trailingAnchor.constraint(equalTo: reusableView.trailingAnchor).isActive = true
            label.bottomAnchor.constraint(equalTo: reusableView.bottomAnchor).isActive = true
            return reusableView
        }
        return nil
    }
    
    private lazy var dataSource: DataSource = {
        return DataSource(collectionView: self.collectionView, cellProvider: self.cellProvider)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell_id")
        self.collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: "badge_kind", withReuseIdentifier: "badge_id")
        self.collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: "header_kind", withReuseIdentifier: "header_id")
        
        self.dataSource.supplementaryViewProvider = self.supplementaryViewProvider
        
        var snapshot = Snapshot()
        snapshot.appendSections([0, 1])
        snapshot.appendItems([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], toSection: 0)
        snapshot.appendItems([13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25], toSection: 1)
        
        self.dataSource.apply(snapshot, animatingDifferences: false)
    }

    init() {
        super.init(collectionViewLayout: {
            let badge = NSCollectionLayoutSupplementaryItem(layoutSize: .init(
                widthDimension: .fractionalWidth(1/20),
                heightDimension: .fractionalWidth(1/20)
            ), elementKind: "badge_kind", containerAnchor: .init(edges: [.top, .trailing], fractionalOffset: .init(x: -1, y: 1)))

            let individualItem = NSCollectionLayoutItem(layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(2/3)
            ), supplementaryItems: [badge])
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
            
            let trailingItem = NSCollectionLayoutItem(layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1/2)
            ))
            trailingItem.contentInsets = .init(
                top: 1,
                leading: 1,
                bottom: 1,
                trailing: 1
            )
            let trailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: .init(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalHeight(1)
            ), subitems: [trailingItem, trailingItem])
            
            let leadingItem = NSCollectionLayoutItem(layoutSize: .init(
                widthDimension: .fractionalWidth(2/3),
                heightDimension: .fractionalHeight(1)
            ))
            leadingItem.contentInsets = .init(
                top: 1,
                leading: 1,
                bottom: 1,
                trailing: 1
            )
            let differentSizesGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(4/9)
            ), subitems: [leadingItem, trailingGroup])
            
            let differentSizesGroupReversed = NSCollectionLayoutGroup.horizontal(layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(4/9)
            ), subitems: [trailingGroup, leadingItem])
            
            let totalGroup = NSCollectionLayoutGroup.vertical(layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(18/9)
            ), subitems: [individualItem, tripletGroup, differentSizesGroup, differentSizesGroupReversed, tripletGroup])
            
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(44)
            ), elementKind: "header_kind", alignment: .top)
            
            let section = NSCollectionLayoutSection(group: totalGroup)
            section.boundarySupplementaryItems = [header]
            
            return UICollectionViewCompositionalLayout(section: section)
        }())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

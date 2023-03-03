//
//  HomeViewController.swift
//  movieMatch-iOS
//
//  Created by BOONGKI KWAK on 2023/03/02.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class HomeViewController: UIViewController {
    
    // IB Outlets
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var headerContentLabel: UILabel!
    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    // Property
    let regularCustomFont = "Sunflower-Light"
    let mediumCustomFont = "Sunflower-Medium"
    
    let movieViewModel = MovieViewModel()
    let disposeBag = DisposeBag()
    
    // Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        headerStyle()
        self.movieCollectionView.register(GenreCell.uinib, forCellWithReuseIdentifier: GenreCell.reuseIdentifier)
        
        movieCollectionView.collectionViewLayout = createBasicListLayout()
        
        func createBasicListLayout() -> UICollectionViewLayout {
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.45),
                                                  heightDimension: .fractionalWidth(0.45 * 1.2))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .estimated(100))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                            subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 10 // Set the minimum spacing between groups to 10 points
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10) // Set the section's content insets
            
            let layout = UICollectionViewCompositionalLayout(section: section)
            let config = UICollectionViewCompositionalLayoutConfiguration()
            config.scrollDirection = .horizontal // Set the scroll direction to horizontal
            layout.configuration = config
            
            return layout
        }
        
        // Bind data to collection view
        movieViewModel.movieList
            .asDriver(onErrorJustReturn: [])
            .drive(movieCollectionView.rx.items(cellIdentifier: GenreCell.reuseIdentifier, cellType: GenreCell.self)) { index, movie, cell in
                if let url = URL(string: movie.image!) {
                    cell.configure(with: url)
                }
                
            }
            .disposed(by: disposeBag)
    }
    
    // Method
    func headerStyle() {
        headerTitleLabel.font = UIFont(name: mediumCustomFont, size: 21.0)
        headerContentLabel.font = UIFont(name: regularCustomFont, size: 13.0)
    }
    
    
    
}

//extension HomeViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let cellWidth = self.movieCollectionView.frame.width / 2 * 0.8
//        let cellHeight = cellWidth * 1.2
//        return CGSize(width: cellWidth, height: cellHeight)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 10 // Set the minimum spacing between cells in the same column to 10 points
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 10 // Set the minimum spacing between cells in the same row to 10 points
//    }
//}

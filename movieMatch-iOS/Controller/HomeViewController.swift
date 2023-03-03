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
    
    // MARK: - IB Outlets
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var headerContentLabel: UILabel!
    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    // MARK: - Property
    let regularCustomFont = "Sunflower-Light"
    let mediumCustomFont = "Sunflower-Medium"
    
    let movieViewModel = MovieViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        headerStyle()
        self.movieCollectionView.register(GenreCell.uinib, forCellWithReuseIdentifier: GenreCell.reuseIdentifier)
        fetchMovies()
        movieCollectionView.collectionViewLayout = createBasicListLayout()
        
    }
    
    // MARK: - METHOD
    
    // header 스타일
    func headerStyle() {
        headerTitleLabel.font = UIFont(name: mediumCustomFont, size: 21.0)
        headerContentLabel.font = UIFont(name: regularCustomFont, size: 13.0)
    }
    
    // 데이터
    func fetchMovies() {
        movieViewModel.movieList
            .asDriver(onErrorJustReturn: [])
            .drive(movieCollectionView.rx.items(cellIdentifier: GenreCell.reuseIdentifier, cellType: GenreCell.self)) { index, movie, cell in
                if let url = URL(string: movie.image!) {
                    cell.configureImage(with: url)
                }
                if let title = movie.title {
                    cell.configureTitle(with: title)
                }
            }
            .disposed(by: disposeBag)
    }
    
    // 콜렉션뷰 레이아웃
    func createBasicListLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.45),
                                              heightDimension: .fractionalWidth(0.45 * 1.2))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let spacing = CGFloat(10)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: spacing, bottom: 0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                               heightDimension: .estimated(100))
        
        // Use the NSCollectionLayoutSpacing object to specify the spacing between items
        let groupSpacing = NSCollectionLayoutSpacing.fixed(spacing)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        group.interItemSpacing = groupSpacing
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .horizontal
        layout.configuration = config
        
        return layout
    }
    
}

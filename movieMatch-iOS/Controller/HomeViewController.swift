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
    //var movieSearchByNationViewModel = MovieSearchByNationViewModel()
    //var movieSearchByGenreViewModel = MovieSearchByGenreViewModel()
    
    let regularCustomFont = "Sunflower-Light"
    let mediumCustomFont = "Sunflower-Medium"
    let disposeBag = DisposeBag()
    var genre: String = "1"
    var nation: String = "US"
    var movieItembyNation = [MovieItem]()
    var movieItembyGenre = [MovieItem]()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        headerStyle()
        movieCollectionView.dataSource = self
        movieCollectionView.delegate = self
        // 콜렉션뷰에 셀, 헤더뷰 등록
        movieCollectionView.register(MovieCell.uinib, forCellWithReuseIdentifier: MovieCell.reuseIdentifier)
        movieCollectionView.register(NationHeaderView.self,
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                     withReuseIdentifier: NationHeaderView.reuseIdentifier)
        movieCollectionView.register(GenreHeaderView.self,
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                     withReuseIdentifier: GenreHeaderView.reuseIdentifier)
        // 콜렉션뷰의 콜렉션뷰 레이아웃
        movieCollectionView.collectionViewLayout = test()
        // 데이터 등록
        fetchMovieByNation()
        fetchMovieByGenre()
    }
    
    // MARK: - METHOD
    
    // header 스타일
    func headerStyle() {
        headerTitleLabel.font = UIFont(name: mediumCustomFont, size: 26.0)
        headerContentLabel.font = UIFont(name: regularCustomFont, size: 16.0)
    }
    
    // 데이터
    func fetchMovieByNation() {
        MovieAPI.searchbyNation(nation: nation)
            .subscribe(onNext: { result in
                switch result {
                case .success(let response):
                    self.movieItembyNation = response.items
                    for movie in self.movieItembyNation{
                        print("movieItembyNation - \(movie)")
                    }
                    DispatchQueue.main.async {
                        self.movieCollectionView.reloadData()
                    }
                case .failure(let error):
                    print("에러: \(error)")
                }
            })
            .disposed(by: disposeBag)
    }
    
    func fetchMovieByGenre() {
        MovieAPI.searchbyGenre(genre: genre)
            .subscribe(onNext: { result in
                switch result {
                case .success(let response):
                    self.movieItembyGenre = response.items
                    for movie in self.movieItembyGenre{
                        print("movieItembyGenre - \(movie)")
                    }
                    DispatchQueue.main.async {
                        self.movieCollectionView.reloadData()
                    }
                case .failure(let error):
                    print("에러: \(error)")
                }
            })
            .disposed(by: disposeBag)
    }
    
    // 콜렉션뷰 레이아웃
    func test() -> UICollectionViewLayout {
        print("testtest테스트중")
        // 콤포지셔널 레이아웃 생성
        let layout = UICollectionViewCompositionalLayout{
            // 만들게 되면 튜플 (키: 값, 키: 값) 의 묶음으로 들어옴 반환 하는 것은 NSCollectionLayoutSection 콜렉션 레이아웃 섹션을 반환해야함
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            // 아이템
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.475),
                                                  heightDimension: .fractionalWidth(0.7))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0)
            
            // 그룹
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                                   heightDimension: .estimated(100))
            let groupSpacing = NSCollectionLayoutSpacing.fixed(10)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
            group.interItemSpacing = groupSpacing
            
            if sectionIndex == 0 {
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
                let nationHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                              heightDimension: .estimated(44))
                let nationHeader = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: nationHeaderSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top)
                section.boundarySupplementaryItems = [nationHeader]
                section.orthogonalScrollingBehavior = .continuous
                return section
            } else if sectionIndex == 1 {
                let section2 = NSCollectionLayoutSection(group: group)
                section2.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
                let genreHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                             heightDimension: .estimated(44))
                let genreHeader = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: genreHeaderSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top)
                section2.boundarySupplementaryItems = [genreHeader]
                return section2
            } else {
                return nil
            }
        }
        return layout
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return movieItembyNation.count
        } else if section == 1 {
            return movieItembyGenre.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = movieCollectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseIdentifier, for: indexPath) as! MovieCell
        
        if indexPath.section == 0 {
            let title = movieItembyNation[indexPath.item].title
            let link = movieItembyNation[indexPath.item].image
            cell.configureImage(with: URL(string: link!))
            cell.configureTitle(with: title)
            return cell
        } else if indexPath.section == 1 {
            let title = movieItembyGenre[indexPath.item].title
            let link = movieItembyGenre[indexPath.item].image
            cell.configureImage(with: URL(string: link!))
            cell.configureTitle(with: title)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            if indexPath.section == 0 {
                let nationHeaderView = movieCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NationHeaderView.reuseIdentifier, for: indexPath)
                nationHeaderView.backgroundColor = .red
                return nationHeaderView
            } else if indexPath.section == 1 {
                let genreHeaderView = movieCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: GenreHeaderView.reuseIdentifier, for: indexPath)
                genreHeaderView.backgroundColor = .blue
                return genreHeaderView
            }
        default:
            fatalError("Unexpected supplementary view kind: \(kind)")
        }
        return UICollectionReusableView()
    }
}


// 콜렉션뷰 델리겟 - 액션과 관련된 것들
extension HomeViewController: UICollectionViewDelegate {
    
}

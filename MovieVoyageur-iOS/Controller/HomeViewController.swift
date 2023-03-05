//
//  HomeViewController.swift
//  MovieVoyageur-iOS
//
//  Created by BOONGKI KWAK on 2023/03/06.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class HomeViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    // MARK: - Property
    let disposeBag = DisposeBag()
    var upcomingMovieList = MovieListResponse<MovieDate, MovieResult>()
    var nowplayingMovieList = MovieListResponse<MovieDate, MovieResult>()
    var popularMovieList = MovieListResponseWithoutDate<MovieResult>()
    var topRatedMovieList = MovieListResponseWithoutDate<MovieResult>()
    
    let imageUrl = "https://image.tmdb.org/t/p/w500"
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        homeCollectionView.dataSource = self
        homeCollectionView.delegate = self
        registerCellAndHeaderAndLayout()
        fetchUpcoming()
        fetchNowPlaying()
        fetchPopular()
        fetchTopRated()
    }
    
    // MARK: - Method
    /// 콜렉션뷰 셀, 헤더, 레이아웃 등록
    func registerCellAndHeaderAndLayout() {
        homeCollectionView.register(BannerCell.uinib, forCellWithReuseIdentifier: BannerCell.reuseIdentifier)
        homeCollectionView.register(MovieCell.uinib, forCellWithReuseIdentifier: MovieCell.reuseIdentifier)
        homeCollectionView.register(SectionHeaderView.self,
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                    withReuseIdentifier: SectionHeaderView.reuseIdentifier)
        homeCollectionView.collectionViewLayout = createCompositionalLayout()
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        // 콤포지셔널 레이아웃 생성
        let layout = UICollectionViewCompositionalLayout{
            // 만들게 되면 튜플 (키: 값, 키: 값) 의 묶음으로 들어옴 반환 하는 것은 NSCollectionLayoutSection 콜렉션 레이아웃 섹션을 반환해야함
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            // 배너셀
            if sectionIndex == 0 {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7),
                                                       heightDimension: .fractionalWidth(1.0))
                let groupSpacing = NSCollectionLayoutSpacing.fixed(0)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                               subitems: [item])
                group.interItemSpacing = groupSpacing
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0)
                section.orthogonalScrollingBehavior = .continuous
                return section
            } else if sectionIndex == 1 {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),
                                                      heightDimension: .fractionalWidth(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .fractionalWidth(1/3 * 1.5 + 0.1))
                let groupSpacing = NSCollectionLayoutSpacing.fixed(0)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                               subitems: [item])
                group.interItemSpacing = groupSpacing
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0)
                section.orthogonalScrollingBehavior = .continuous
                let HeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .fractionalWidth(0.1))
                let Header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: HeaderSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top)
                section.boundarySupplementaryItems = [Header]
                return section
            } else {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/4),
                                                      heightDimension: .fractionalWidth(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .fractionalWidth(1/4 * 1.5 + 0.1))
                let groupSpacing = NSCollectionLayoutSpacing.fixed(0)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                               subitems: [item])
                group.interItemSpacing = groupSpacing
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0)
                section.orthogonalScrollingBehavior = .continuous
                let HeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .fractionalWidth(0.1))
                let Header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: HeaderSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top)
                section.boundarySupplementaryItems = [Header]
                return section
            }
        }
        return layout
    }
    
    // 데이터 등록
    func fetchUpcoming() {
        MovieAPI.fetchUpcoming()
            .subscribe(onNext: { result in
                switch result {
                case .success(let response):
                    self.upcomingMovieList = response
                    
                    DispatchQueue.main.async {
                        self.homeCollectionView.reloadData()
                    }
                case .failure(let error):
                    print("에러: \(error)")
                }
            })
            .disposed(by: disposeBag)
    }
    
    func fetchNowPlaying() {
        MovieAPI.fetchNowPlaying()
            .subscribe(onNext: { result in
                switch result {
                case .success(let response):
                    self.nowplayingMovieList = response
                    DispatchQueue.main.async {
                        self.homeCollectionView.reloadData()
                    }
                case .failure(let error):
                    print("에러: \(error)")
                }
            })
            .disposed(by: disposeBag)
    }
    
    func fetchPopular() {
        MovieAPI.fetchPopular()
            .subscribe(onNext: { result in
                switch result {
                case .success(let response):
                    self.popularMovieList = response
                    
                    DispatchQueue.main.async {
                        self.homeCollectionView.reloadData()
                    }
                case .failure(let error):
                    print("에러: \(error)")
                }
            })
            .disposed(by: disposeBag)
    }
    
    func fetchTopRated() {
        MovieAPI.fetchTopRated()
            .subscribe(onNext: { result in
                switch result {
                case .success(let response):
                    self.topRatedMovieList = response
                    DispatchQueue.main.async {
                        self.homeCollectionView.reloadData()
                    }
                case .failure(let error):
                    print("에러: \(error)")
                }
            })
            .disposed(by: disposeBag)
    }
    
    
}

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        4
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            let movieResult = upcomingMovieList.results
            return movieResult == nil ? 0 : movieResult!.count
        case 1:
            let movieResult = nowplayingMovieList.results
            return movieResult == nil ? 0 : movieResult!.count
        case 2:
            let movieResult = popularMovieList.results
            return movieResult == nil ? 0 : movieResult!.count
        case 3:
            let movieResult = topRatedMovieList.results
            return movieResult == nil ? 0 : movieResult!.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseIdentifier, for: indexPath) as! MovieCell
        
        if indexPath.section == 0 {
            let cell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.reuseIdentifier, for: indexPath) as! BannerCell
            if let movieResult: [MovieResult] = upcomingMovieList.results {
                cell.configureImage(with: URL(string: imageUrl + movieResult[indexPath.item].posterPath!))
            } else {
                print("upcomingMovieResult의 데이터가 없습니다.")
            }
            return cell
        } else if indexPath.section == 1 {
            if let movieResult: [MovieResult] = nowplayingMovieList.results {
                cell.configureImage(with: URL(string: imageUrl + movieResult[indexPath.item].posterPath!))
                cell.configureTitle(with: movieResult[indexPath.item].originalTitle)
                cell.configureDirector(with: String(movieResult[indexPath.item].voteAverage!))
            } else {
                print("nowplayingMovieResult의 데이터가 없습니다.")
            }
            return cell
        } else if indexPath.section == 2 {
            if let movieResult: [MovieResult] = popularMovieList.results {
                cell.configureImage(with: URL(string: imageUrl + movieResult[indexPath.item].posterPath!))
                cell.configureTitle(with: movieResult[indexPath.item].originalTitle)
                cell.configureDirector(with: String(movieResult[indexPath.item].voteAverage!))
            } else {
                print("popularMovieList의 데이터가 없습니다.")
            }
            return cell
        } else if indexPath.section == 3 {
            if let movieResult: [MovieResult] = topRatedMovieList.results {
                cell.configureImage(with: URL(string: imageUrl + movieResult[indexPath.item].posterPath!))
                cell.configureTitle(with: movieResult[indexPath.item].originalTitle)
                cell.configureDirector(with: String(movieResult[indexPath.item].voteAverage!))
            } else {
                print("topRatedMovieList의 데이터가 없습니다.")
            }
            return cell
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = homeCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.reuseIdentifier, for: indexPath) as! SectionHeaderView
            if indexPath.section == 1 {
                headerView.configureStyle(with: "현재 상영중")
                return headerView
            } else if indexPath.section == 2 {
                headerView.configureStyle(with: "가장 인기있는")
                return headerView
            } else if indexPath.section == 3 {
                headerView.configureStyle(with: "가장 평점높은")
                return headerView
            } else {
                return UICollectionReusableView()
            }
        default:
            fatalError("view kind 잘못된 설정이 나타났습니다.: \(kind)")
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
}



//
//  SearchViewController.swift
//  MovieVoyageur-iOS
//
//  Created by BOONGKI KWAK on 2023/03/06.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    // MARK: - IB Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchCollectionView: UICollectionView!
    
    // MARK: - Property
    let disposeBag = DisposeBag()
    var searchTermInputWorkItem: DispatchWorkItem? = nil
    var searchTerm = ""
    var searchTermList = [String?]()
    var movieResult = [MovieResult]()
    // 디바운스 타이머
    var searchWorkItem: DispatchWorkItem?
    var debounceTimer: Timer?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchCollectionView.dataSource = self
        searchCollectionView.delegate = self
        searchCollectionView.register(RecentSearchCell.uinib, forCellWithReuseIdentifier: RecentSearchCell.reuseIdentifier)
        searchCollectionView.register(SearchCell.uinib, forCellWithReuseIdentifier: SearchCell.reuseIdentifier)
        searchCollectionView.register(SearchHeaderView.self,
                                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                      withReuseIdentifier: SearchHeaderView.reuseIdentifier)
        searchCollectionView.collectionViewLayout = createCompositionalLayout()
        searchBar.delegate = self
    }
    
    // MARK: - Method
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // 이전에 예약된 딜레이가 있다면 취소
        searchWorkItem?.cancel()
        
        // 새로운 딜레이 예약
        let workItem = DispatchWorkItem { [weak self] in
            self?.fetchBySearchTerm(searchText)
            if searchText != "" {
                self?.searchTermList.append(searchText)
            }
            // 검색 결과가 나타날 때 키보드를 닫음
            searchBar.resignFirstResponder()
        }
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: workItem)
    }
    
    // 검색어로 검색결과 받아오기
    func fetchBySearchTerm(_ searchText: String) {
        MovieAPI.searchMovie(searchText)
            .subscribe(onNext: { result in
                switch result {
                case .success(let response):
                    self.movieResult = response.results!
                    DispatchQueue.main.async {
                        self.searchCollectionView.reloadData()
                    }
                case .failure(let error):
                    print("에러: \(error)")
                }
            })
            .disposed(by: disposeBag)
    }
    
    // 컴포지셔널 레이아웃
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout{
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            if sectionIndex == 0 {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
                let groupHeight =  NSCollectionLayoutDimension.fractionalWidth(0.1)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: groupHeight)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 6)
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                let HeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .fractionalWidth(0.1))
                let Header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: HeaderSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top)
                section.boundarySupplementaryItems = [Header]
                section.orthogonalScrollingBehavior = .continuous
                return section
            } else {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalWidth(0.7))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .fractionalWidth(0.7))
                let groupSpacing = NSCollectionLayoutSpacing.fixed(0)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                               subitems: [item])
                group.interItemSpacing = groupSpacing
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 10, trailing: 0)
                return section
            }
        }
        return layout
    }
    
    // MARK: - IB Actions
}

extension SearchViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            print("searchTermList.count - \(searchTermList.count)")
            return searchTermList.count
        } else {
            return movieResult.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = searchCollectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchCell.reuseIdentifier, for: indexPath) as! RecentSearchCell
            if let recentSearchTerm = searchTermList[indexPath.item] {
                print("recentSearchTerm - \(recentSearchTerm)")
                cell.configureTitle(recentSearchTerm)
            }
            return cell
        } else {
            let cell = searchCollectionView.dequeueReusableCell(withReuseIdentifier: SearchCell.reuseIdentifier, for: indexPath) as! SearchCell
            if let voteCount = movieResult[indexPath.item].voteCount {
                cell.configureRecommend(with: "추천수: " + String(voteCount))
            }
            if let voteAverage = movieResult[indexPath.item].voteAverage {
                cell.configureValue(with: "평점: " + String(voteAverage))
            }
            if let overview = movieResult[indexPath.item].overview {
                cell.configureSummary(with: "줄거리: " + overview)
            }
            if let title = movieResult[indexPath.item].title {
                cell.configureTitle(with: title)
            }
            if let posterPath = movieResult[indexPath.item].posterPath {
                cell.configureImage(with: URL(string:"https://image.tmdb.org/t/p/w500" + posterPath))
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 {
            let headerView = searchCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SearchHeaderView.reuseIdentifier, for: indexPath) as! SearchHeaderView
            headerView.parentViewController = self
            return headerView
        } else {
            return UICollectionReusableView()
        }
    }
    
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if let inputString = searchTermList[indexPath.item] {
                fetchBySearchTerm(inputString)
            }
        } else if indexPath.section == 1 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let movieDetailViewController = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
            movieDetailViewController.movieId = movieResult[indexPath.item].id!
            self.navigationController?.pushViewController(movieDetailViewController, animated: true)
            
        }
    }
}

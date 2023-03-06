//
//  MovieListViewController.swift
//  MovieVoyageur-iOS
//
//  Created by BOONGKI KWAK on 2023/03/06.
//

import UIKit

class MovieListViewController: UIViewController, ReuseIdentifiable {
    
    // MARK: - IBOutlet
    @IBOutlet weak var movieListCollectionView: UICollectionView!
    
    // MARK: - Property
    var titleText = ""
    var movieList = MovieListResponse<MovieDate, MovieResult>()
    var movieListWithoutDate = MovieListResponseWithoutDate<MovieResult>()
    var movieResult = [MovieResult]()
    let imageUrl = "https://image.tmdb.org/t/p/w500"
    let valueStr = "평점: "
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = titleText

        movieListCollectionView.dataSource = self
        movieListCollectionView.delegate = self
        registerCellAndHeaderAndLayout()
        checkData()
    }
    
    // MARK: - Method
    func registerCellAndHeaderAndLayout() {
        movieListCollectionView.register(MovieCell.uinib, forCellWithReuseIdentifier: MovieCell.reuseIdentifier)
        movieListCollectionView.register(MovieListHeaderView.self,
                                         forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                         withReuseIdentifier: MovieListHeaderView.reuseIdentifier)
        movieListCollectionView.collectionViewLayout = createCompositionalLayout()
    }
    
    // 데이터 타입 변환
    func checkData() {
        if movieList.results != nil {
            movieResult = movieList.results!
        } else {
            movieResult = movieListWithoutDate.results!
        }
    }
    
    // 컴포지셔널 레이아웃
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout{
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            let groupHeight =  NSCollectionLayoutDimension.fractionalWidth(0.6)
            
            // 그룹사이즈
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: groupHeight)
            
            // 변경할 부분
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
            
            // 그룹으로 섹션 만들기
            let section = NSCollectionLayoutSection(group: group)
            
            // 섹션에 대한 간격 설정
            section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            let HeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .fractionalWidth(0.1))
            let Header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: HeaderSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
            section.boundarySupplementaryItems = [Header]
            return section
        }
        return layout
    }
}

extension MovieListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = movieListCollectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseIdentifier, for: indexPath) as! MovieCell
        cell.configureImage(with: URL(string: imageUrl + movieResult[indexPath.item].posterPath!))
        cell.configureTitle(with: movieResult[indexPath.item].originalTitle)
        cell.configureDirector(with: valueStr + String(movieResult[indexPath.item].voteAverage!))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = movieListCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MovieListHeaderView.reuseIdentifier, for: indexPath) as! MovieListHeaderView
        headerView.parentViewController = self
        headerView.configureStyle(with: titleText)
        return headerView
    }
    
}

extension MovieListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let movieDetailViewController = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        self.navigationController?.pushViewController(movieDetailViewController, animated: true)
        movieDetailViewController.movieId = movieResult[indexPath.item].id!
    }
}


//
//  GenreViewController.swift
//  MovieVoyageur-iOS
//
//  Created by BOONGKI KWAK on 2023/03/07.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class GenreViewContoller: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet weak var genreCollectionView: UICollectionView!
    
    // MARK: - Property
    let disposeBag = DisposeBag()
    var genreList = ["Action":28, "Adventure":12, "Animation":16, "Comedy":35, "Crime":80, "Documentary":99, "Drama":18,
                     "Family":10751, "Fantasy":14, "History":36, "Horror":27, "Music":10402,"Mystery":9648,"Romance":10749,
                     "Science Fiction": 878, "Thriller":53, "War":10752]
    var genreListKeys = [String]()
    var genreId = 28
    var selectedIndex = 0
    var movieResult = [MovieResult]()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        sortDictionary()
        genreCollectionView.register(GenreCell.uinib, forCellWithReuseIdentifier: GenreCell.reuseIdentifier)
        genreCollectionView.register(SearchCell.uinib, forCellWithReuseIdentifier: SearchCell.reuseIdentifier)
        genreCollectionView.dataSource = self
        genreCollectionView.delegate = self
        genreCollectionView.collectionViewLayout = createCompositionalLayout()
        fetchByGenre(genreId)
    }
    
    // MARK: - Method
    func sortDictionary() {
        let sortedGenres = genreList.sorted(by: { $0.key < $1.key })
        let sortedGenreList = Dictionary(uniqueKeysWithValues: sortedGenres.map { ($0.key, $0.value) })
        genreList = sortedGenreList
    }
    // 장르Id로 장르가져오기
    func fetchByGenre(_ genreId: Int) {
        MovieAPI.fetchByGenre(genreId)
            .subscribe(onNext: { result in
                switch result {
                case .success(let response):
                    self.movieResult = response.results!
                    DispatchQueue.main.async {
                        self.genreCollectionView.reloadData()
                    }
                case .failure(let error):
                    print("에러: \(error)")
                }
            })
            .disposed(by: disposeBag)
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout{
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            if sectionIndex == 0 {
                let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(50),
                                                      heightDimension: .estimated(25))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: .fixed(10), trailing: nil, bottom: .fixed(10))

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .estimated(60))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                                subitems: [item])
                group.interItemSpacing = .fixed(10)

                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 20, bottom: 10, trailing: 10)

                return section
            } else {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalWidth(0.5))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .fractionalWidth(0.5))
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
}

extension GenreViewContoller: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return genreList.count
        } else {
            return movieResult.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = genreCollectionView.dequeueReusableCell(withReuseIdentifier: GenreCell.reuseIdentifier, for: indexPath) as! GenreCell
            genreListKeys = Array(genreList.keys)
            cell.configureGenreTitle(genreListKeys[indexPath.item])
            cell.backgroundColor = UIColor.white
            cell.layer.cornerRadius = 10
            cell.layer.borderColor = UIColor.systemBlue.cgColor
            cell.layer.borderWidth = 1
            
            if indexPath.item == selectedIndex {
                cell.backgroundColor = UIColor.systemBlue
                cell.layer.cornerRadius = 10
                cell.genreLabel.textColor = .white
            }
            
            return cell
        } else {
            let cell = genreCollectionView.dequeueReusableCell(withReuseIdentifier: SearchCell.reuseIdentifier, for: indexPath) as! SearchCell
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
                cell.movieImage.layer.cornerRadius = 5
            }
            return cell
        }
    }
    
}

extension GenreViewContoller: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if let value = genreList[genreListKeys[indexPath.item]] {
                selectedIndex = indexPath.item
                fetchByGenre(value)
            }
        } else if indexPath.section == 1 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let movieDetailViewController = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
            self.navigationController?.pushViewController(movieDetailViewController, animated: true)
            movieDetailViewController.movieId = movieResult[indexPath.item].id!
        }
    }
    
}

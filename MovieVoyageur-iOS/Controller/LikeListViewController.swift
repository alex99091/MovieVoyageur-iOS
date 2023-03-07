//
//  LikeListViewController.swift
//  MovieVoyageur-iOS
//
//  Created by BOONGKI KWAK on 2023/03/07.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class LikeListViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet weak var likeCollectionView: UICollectionView!
    
    // MARK: - Property
    var movieData = MovieIdData()
    var movieList = [MovieDetail]()
    let disposeBag = DisposeBag()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMovieIdListsFromUserDefaults()
        fetchMovieDetail()
        likeCollectionView.register(LikeCell.uinib, forCellWithReuseIdentifier: LikeCell.reuseIdentifier)
        likeCollectionView.dataSource = self
        likeCollectionView.delegate = self
        likeCollectionView.collectionViewLayout = createCompositionalLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMovieIdListsFromUserDefaults()
        fetchMovieDetail()
    }
    
    // MARK: - Method
    // UserDefault에 저장된값 가져오기
    func loadMovieIdListsFromUserDefaults() {
        if let savedData = UserDefaults.standard.data(forKey: "movieIdList"),
           let loadedData = try? PropertyListDecoder().decode(MovieIdData.self, from: savedData) {
            movieData.movieIdList = loadedData.movieIdList ?? []
            print("로드된 데이터를 확인 - \(String(describing: movieData.movieIdList))")
            likeCollectionView.reloadData()
        }
    }
    
    // userdefault에서 값을 삭제하는 함수
    func removeMovieIdFromUserDefaults(movieId: Int) {
        if var movieIdData = UserDefaults.standard.object(forKey: "movieIdList") as? Data,
           var movieIdList = try? PropertyListDecoder().decode(MovieIdData.self, from: movieIdData) {
            movieIdList.movieIdList?.removeAll(where: { $0 == movieId })
            movieIdData = try! PropertyListEncoder().encode(movieIdList)
            UserDefaults.standard.set(movieIdData, forKey: "movieIdList")
            likeCollectionView.reloadData()
        }
    }
    
    func fetchMovieDetail() {
        if let likeList = movieData.movieIdList {
            movieList.removeAll()
            for id in likeList {
                MovieAPI.fetchMovieDetail(id)
                    .subscribe(onNext: { result in
                        switch result {
                        case .success(let response):
                            self.movieList.append(response)
                            DispatchQueue.main.async {
                                self.likeCollectionView.reloadData()
                            }
                        case .failure(let error):
                            print("에러: \(error)")
                        }
                    })
                    .disposed(by: disposeBag)
            }
        }
        print("userdefaults 숫자 -\(String(describing: movieData.movieIdList?.count))")
        print("userdefaults 숫자 -\(movieList.count)")
    }
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout{
            // 만들게 되면 튜플 (키: 값, 키: 값) 의 묶음으로 들어옴 반환 하는 것은 NSCollectionLayoutSection 콜렉션 레이아웃 섹션을 반환해야함
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalWidth(0.3))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalWidth(0.3))
            let groupSpacing = NSCollectionLayoutSpacing.fixed(0)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
            group.interItemSpacing = groupSpacing
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
            return section
        }
        return layout
    }
}

extension LikeListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = likeCollectionView.dequeueReusableCell(withReuseIdentifier: LikeCell.reuseIdentifier, for: indexPath) as! LikeCell
        if movieList.count > 0 {
            if let title = movieList[indexPath.item].title {
                cell.configureTitle(title)
            }
            if let genre = movieList[indexPath.item].genres?[0].name {
                cell.configureGenre("장르: \(genre)")
            }
            if let backdropPath = movieList[indexPath.item].backdropPath {
                cell.configureImage(URL(string:"https://image.tmdb.org/t/p/w500" + backdropPath)!)
                cell.movieImage.layer.cornerRadius = cell.movieImage.frame.size.width / 2
                cell.movieImage.clipsToBounds = true
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

extension LikeListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let movieDetailViewController = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        self.navigationController?.pushViewController(movieDetailViewController, animated: true)
        movieDetailViewController.movieId = movieList[indexPath.item].id!
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let tryDragMove = movieList[sourceIndexPath.item]
        movieList.remove(at: sourceIndexPath.item)
        movieList.insert(tryDragMove, at: destinationIndexPath.item)
    }
    
    //    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
    //        return true
    //    }
    //    func collectionView(_ collectionView: UICollectionView, didEndEditingItemAt indexPath: IndexPath?) {
    //        if let indexPath = indexPath {
    //            if let selectedMoveId = movieList[indexPath.item].id {
    //                removeMovieIdFromUserDefaults(movieId: selectedMoveId)
    //            }
    //            movieList.remove(at: indexPath.item)
    //            likeCollectionView.reloadData()
    //        }
    //    }
}

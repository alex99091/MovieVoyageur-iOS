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
    var likeIdList = [Int]()
    var movieList = [MovieDetail]()
    let disposeBag = DisposeBag()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserDefaultData()
        fetchMovieDetail()
        likeCollectionView.register(LikeCell.uinib, forCellWithReuseIdentifier: LikeCell.reuseIdentifier)
        likeCollectionView.dataSource = self
        likeCollectionView.delegate = self
        likeCollectionView.collectionViewLayout = createCompositionalLayout()
    }
    
    // MARK: - Method
    // UserDefault에 저장된값 가져오기
    func loadUserDefaultData(){
        // 저장된 값을 출력
        if let savedData = UserDefaults.standard.data(forKey: "movieIdList"),
           let loadedData = try? PropertyListDecoder().decode(MovieIdData.self, from: savedData),
           let movieIdList = loadedData.movieIdList {
            likeIdList = movieIdList
            print("로드성공: \(likeIdList)")
        } else {
            print("로드실패")
        }
    }
    
    func fetchMovieDetail() {
        for id in likeIdList {
            MovieAPI.fetchMovieDetail(id)
                .subscribe(onNext: { result in
                    switch result {
                    case .success(let response):
                        self.movieList.append(response)
                        print("id - \(id), movieList - \(self.movieList)")
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
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout{
            // 만들게 되면 튜플 (키: 값, 키: 값) 의 묶음으로 들어옴 반환 하는 것은 NSCollectionLayoutSection 콜렉션 레이아웃 섹션을 반환해야함
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalWidth(1/3))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalWidth(1/3))
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
            } else {
                print("error: - \(movieList[indexPath.item].title)")
            }
            if let genre = movieList[indexPath.item].genres?[0].name {
                cell.configureGenre(genre)
            }
            if let backdropPath = movieList[indexPath.item].backdropPath {
                cell.configureImage(URL(string:"https://image.tmdb.org/t/p/w500" + backdropPath)!)
            }
        }
        return cell
    }
    
    
}

extension LikeListViewController: UICollectionViewDelegate {
    
}

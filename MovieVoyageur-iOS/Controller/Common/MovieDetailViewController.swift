//
//  MovieDetailViewController.swift
//  MovieVoyageur-iOS
//
//  Created by BOONGKI KWAK on 2023/03/06.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class MovieDetailViewController: UIViewController {
    
    // MARK: - IBAction
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nationLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet var labelCollection: [UILabel]!
    @IBOutlet weak var heartButton: UIButton!
    
    // MARK: - Property
    let disposeBag = DisposeBag()
    var movieId = 0
    var movieDetail = MovieDetail()
    var movieData = MovieIdData()
    var movieIdLists = [Int]()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMovieDetail()
        styleLabels()
        loadMovieIdListsFromUserDefaults()
        heartButtonStyle()
    }
    // MARK: - Method
    // userDefaults를 로드하는 ㄹunction
    func loadMovieIdListsFromUserDefaults() {
        if let savedData = UserDefaults.standard.data(forKey: "movieIdList"),
           let loadedData = try? PropertyListDecoder().decode(MovieIdData.self, from: savedData) {
            movieData.movieIdList = loadedData.movieIdList ?? []
            print("로드된 데이터를 확인 - \(String(describing: movieData.movieIdList))")
        }
    }
    // userdefaults에 저장해주는 function
    func saveMovieIdToUserDefaults(_ willSaveData: MovieIdData) {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(willSaveData), forKey: "movieIdList")
    }
    // userdefault에서 값을 삭제하는 함수
    func removeMovieIdFromUserDefaults(movieId: Int) {
        if var movieIdData = UserDefaults.standard.object(forKey: "movieIdList") as? Data,
           var movieIdList = try? PropertyListDecoder().decode(MovieIdData.self, from: movieIdData) {
            movieIdList.movieIdList?.removeAll(where: { $0 == movieId })
            movieIdData = try! PropertyListEncoder().encode(movieIdList)
            UserDefaults.standard.set(movieIdData, forKey: "movieIdList")
        }
    }
    
    func styleLabels() {
        for label in labelCollection {
            label.font = UIFont(name: "Sunflower-Light", size: 14.0)
        }
    }
    
    func heartButtonStyle() {
        if movieData.movieIdList?.contains(movieId) == true {
            heartButton.isSelected = true
        }
        var configuration = UIButton.Configuration.filled()
           configuration.baseBackgroundColor = UIColor.white
        if heartButton.isSelected {
            heartButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
            heartButton.tintColor = UIColor.red
            heartButton.configuration?.baseBackgroundColor = UIColor.white
        } else {
            heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
            heartButton.tintColor = UIColor.red
            heartButton.backgroundColor = UIColor.white
        }
    }
    
    func fetchData() {
        if let posterPathUrl = movieDetail.posterPath {
            let urlPath = "https://image.tmdb.org/t/p/w500" + posterPathUrl
            movieImageView.kf.setImage(with: URL(string: urlPath))
            movieImageView.layer.cornerRadius = 5
        }
        if movieDetail.genres?.count ?? 0 > 1 {
            if let genreText = movieDetail.genres?[0].name {
                genreLabel.text = genreText
            }
        }
        titleLabel.text = movieDetail.title
        if movieDetail.productionCountries?.count ?? 0 > 1 {
            if let countryText = movieDetail.productionCountries?[0].name {
                nationLabel.text = countryText
            }
        }
        runtimeLabel.text = String(movieDetail.runtime!) + "분"
        voteLabel.text = String(movieDetail.voteAverage!)
        summaryLabel.text = movieDetail.overview
    }
    
    func fetchMovieDetail() {
        MovieAPI.fetchMovieDetail(movieId)
            .subscribe(onNext: { result in
                switch result {
                case .success(let response):
                    self.movieDetail = response
                    DispatchQueue.main.async {
                        self.fetchData()
                        self.reloadInputViews()
                    }
                case .failure(let error):
                    print("에러: \(error)")
                }
            })
            .disposed(by: disposeBag)
    }
    @IBAction func backwardButtonTouched(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func heartButtonTouched(_ sender: Any) {
        guard let heartButton = sender as? UIButton else { return }
        heartButton.isSelected = !heartButton.isSelected
        
        loadMovieIdListsFromUserDefaults()
        
        if heartButton.isSelected {
            heartButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
            heartButton.tintColor = UIColor.red
            heartButton.configuration?.baseBackgroundColor = UIColor.white
            movieData.movieIdList?.append(movieId)
            saveMovieIdToUserDefaults(movieData)
        } else {
            heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
            heartButton.tintColor = UIColor.black
            heartButton.backgroundColor = UIColor.white
            movieData.movieIdList?.removeAll(where: { $0 == movieId })
            removeMovieIdFromUserDefaults(movieId: movieId)
        }
        
    }
    
}

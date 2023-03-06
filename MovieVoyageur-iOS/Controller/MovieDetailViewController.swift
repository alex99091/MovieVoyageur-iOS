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
    
    // MARK: - Property
    let disposeBag = DisposeBag()
    var movieId = 0
    var movieDetail = MovieDetail()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMovieDetail()
        styleLabels()
    }
    // MARK: - Method
    func styleLabels() {
        for label in labelCollection {
            label.font = UIFont(name: "Sunflower-Light", size: 14.0)
        }
    }
    
    func fetchData() {
        let urlPath = "https://image.tmdb.org/t/p/w500" + movieDetail.posterPath!
        movieImageView.kf.setImage(with: URL(string: urlPath))
        genreLabel.text = movieDetail.genres![0].name
        titleLabel.text = movieDetail.title
        nationLabel.text = movieDetail.productionCountries![0].name
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
        
    }
    
}

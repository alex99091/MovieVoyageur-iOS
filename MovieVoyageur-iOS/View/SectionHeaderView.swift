//
//  SectionHeaderView.swift
//  MovieMatch-iOS
//
//  Created by BOONGKI KWAK on 2023/03/06.
//

import UIKit

class SectionHeaderView: UICollectionReusableView, ReuseIdentifiable {
    
    let label = UILabel()
    let button = UIButton()
    weak var parentViewController: HomeViewController?
    var currentSectionIndex = -1
    var movieData: Any?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(label)
        addSubview(button)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(button.frame.width + 20)),
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: 18),
        ])
        
        button.addTarget(self, action: #selector(showMovieList), for: .touchUpInside)
    }
    
    func configureStyle(with text: String?){
        label.textColor = .black
        label.text = text
        label.font = UIFont(name: "Sunflower-Medium", size: 18.0)
        
        let buttonConfig = UIImage.SymbolConfiguration(pointSize: 18)
        let image = UIImage(systemName: "chevron.right", withConfiguration: buttonConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .black
    }
    
    @objc func showMovieList() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let movieListViewController = storyboard.instantiateViewController(withIdentifier: MovieListViewController.reuseIdentifier) as! MovieListViewController
        self.parentViewController?.navigationController?.pushViewController(movieListViewController, animated: true)
        
        switch currentSectionIndex {
        case 1:
            movieListViewController.movieList = parentViewController!.nowplayingMovieList
            movieListViewController.titleText = "현재 상영중인 영화"
        case 2:
            movieListViewController.movieListWithoutDate = parentViewController!.popularMovieList
            movieListViewController.titleText = "가장 인기있는 영화"
        case 3:
            movieListViewController.movieListWithoutDate = parentViewController!.topRatedMovieList
            movieListViewController.titleText = "가장 평점높은 영화"
        default: print("섹션을 알 수 없습니다.")
        }
    }
}

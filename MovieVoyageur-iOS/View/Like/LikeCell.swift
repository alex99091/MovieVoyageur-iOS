//
//  LikeCell.swift
//  MovieVoyageur-iOS
//
//  Created by BOONGKI KWAK on 2023/03/07.
//

import UIKit
import Kingfisher

class LikeCell: UICollectionViewCell, ReuseIdentifiable {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    
    // MARK: - Method
    func configureImage(_ imageURL: URL) {
        if let movieImage = movieImage {
            movieImage.kf.setImage(with: imageURL)
            movieImage.contentMode = .scaleToFill
        }
    }
    
    func configureTitle(_ input: String){
        if let titleLabel = titleLabel {
            titleLabel.text = input
            titleLabel.font = UIFont(name: "Sunflower-Medium", size: 15.0)
            titleLabel.textColor = .black
        }
    }
    func configureGenre(_ input: String){
        if let genreLabel = genreLabel {
            genreLabel.text = input
            genreLabel.font = UIFont(name: "Sunflower-Light", size: 12.0)
            genreLabel.textColor = .systemGray4
        }
    }
    
}

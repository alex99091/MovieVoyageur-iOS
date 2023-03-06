//
//  MovieCell.swift
//  MovieMatch-iOS
//
//  Created by BOONGKI KWAK on 2023/03/06.
//

import UIKit
import SwiftUI
import Kingfisher

class MovieCell: UICollectionViewCell, ReuseIdentifiable {
    // MARK: - IBOutlet
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDirectorLabel: UILabel!
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Method
    func configureImage(with imageURL: URL?) {
        movieImage.kf.setImage(with: imageURL)
        movieImage.contentMode = .scaleToFill
        movieImage.clipsToBounds = true
    }
    
    func configureTitle(with titleLabel: String?){
        movieTitleLabel.text = titleLabel
        movieTitleLabel.font = UIFont(name: "Sunflower-Light", size: 12.0)
    }
    
    func configureDirector(with titleLabel: String?){
        movieDirectorLabel.text = titleLabel
        movieDirectorLabel.font = UIFont(name: "Sunflower-Light", size: 12.0)
    }
    
}

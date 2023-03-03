//
//  GenreCell.swift
//  movieMatch-iOS
//
//  Created by BOONGKI KWAK on 2023/03/03.
//

import UIKit
import Kingfisher

class GenreCell: UICollectionViewCell {
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureImage(with imageURL: URL?) {
        movieImage.kf.setImage(with: imageURL)
        movieImage.contentMode = .scaleAspectFill
        movieImage.clipsToBounds = true
    }
    
    func configureTitle(with titleLabel: String?){
        movieTitleLabel.text = titleLabel
        movieTitleLabel.font = UIFont(name: "Sunflower-Light", size: 15.0)
    }
    
}

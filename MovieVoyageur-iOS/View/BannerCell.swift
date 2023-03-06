//
//  BannerCell.swift
//  MovieMatch-iOS
//
//  Created by BOONGKI KWAK on 2023/03/06.
//

import UIKit
import Kingfisher

class BannerCell: UICollectionViewCell, ReuseIdentifiable {
    
    // MARK: - IBOutlet
    @IBOutlet weak var movieImage: UIImageView!
    
    
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
    
}

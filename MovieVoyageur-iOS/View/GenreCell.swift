//
//  GenreCell.swift
//  MovieVoyageur-iOS
//
//  Created by BOONGKI KWAK on 2023/03/07.
//

import UIKit
import Kingfisher

class GenreCell: UICollectionViewCell, ReuseIdentifiable {
    
    // MARK: - IB Outlets
    @IBOutlet weak var genreLabel: UILabel!
    
    // MARK: - Life Cycle
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Method
    func configureGenreTitle(_ input: String){
        if let genreLabel = genreLabel {
            genreLabel.text = input
            genreLabel.font = UIFont(name: "Sunflower-Medium", size: 16.0)
            genreLabel.textColor = .orange
        }
    }
    
}

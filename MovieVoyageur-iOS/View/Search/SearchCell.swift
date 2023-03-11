//
//  SearchCell.swift
//  MovieVoyageur-iOS
//
//  Created by BOONGKI KWAK on 2023/03/07.
//

import UIKit
import Kingfisher

class SearchCell: UICollectionViewCell, ReuseIdentifiable {
    
    // MARK: - IB Outlet
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var recommendLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    
    // MARK: - Life Cycle
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Method
    func configureImage(with imageURL: URL?) {
        movieImage.kf.setImage(with: imageURL)
        movieImage.contentMode = .scaleToFill
        movieImage.clipsToBounds = true
    }
    
    func configureSummary(with input: String){
        summaryLabel.text = input
        summaryLabel.font = UIFont(name: "Sunflower-Light", size: 13.0)
        summaryLabel.adjustsFontSizeToFitWidth = true
    }
    func configureRecommend(with input: String){
        recommendLabel.text = input
        recommendLabel.font = UIFont(name: "Sunflower-Light", size: 16.0)
    }
    func configureValue(with input: String){
        valueLabel.text = input
        valueLabel.font = UIFont(name: "Sunflower-Light", size: 16.0)
    }
    func configureTitle(with input: String){
        titleLabel.text = input
        titleLabel.font = UIFont(name: "Sunflower-Medium", size: 20.0)
    }
    
}

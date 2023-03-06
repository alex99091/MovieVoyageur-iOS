//
//  RecentSearchCell.swift
//  MovieVoyageur-iOS
//
//  Created by BOONGKI KWAK on 2023/03/07.
//

import UIKit

class RecentSearchCell: UICollectionViewCell, ReuseIdentifiable {
    
    // MARK: - IB Outlet
    @IBOutlet weak var recentTermLabel: UILabel!
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Method
    func configureTitle(_ input: String) {
        recentTermLabel.text = input
        recentTermLabel.font = UIFont(name: "Sunflower-Medium", size: 15.0)
        recentTermLabel.adjustsFontSizeToFitWidth = true
    }
    
}

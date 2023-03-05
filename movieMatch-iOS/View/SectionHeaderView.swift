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
            
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(button.frame.width + 10)),
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: 18),
        ])
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
    
}

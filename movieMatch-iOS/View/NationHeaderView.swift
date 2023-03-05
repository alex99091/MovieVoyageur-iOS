//
//  NationHeaderView.swift
//  movieMatch-iOS
//
//  Created by BOONGKI KWAK on 2023/03/04.
//

import UIKit

class NationHeaderView: UICollectionReusableView, ReuseIdentifiable {
    
    let stackView = UIStackView()
    let buttonTitlesinKR = ["프랑스", "영국", "홍콩", "일본", "한국", "미국", "기타"]
    let buttonTitles = ["FR", "GB", "HK", "JP", "KR", "US", "ETC"]
    let buttonBackgroundColor = UIColor(red: 0.4, green: 0.8, blue: 0.6, alpha: 1.0)
    
    let buttonColors = [UIColor(red: 0.99, green: 0.72, blue: 0.5, alpha: 1.0), // FR
                              UIColor(red: 0.75, green: 0.89, blue: 0.83, alpha: 1.0), // GB
                              UIColor(red: 0.96, green: 0.73, blue: 0.81, alpha: 1.0), // HK
                              UIColor(red: 0.83, green: 0.85, blue: 0.92, alpha: 1.0), // JP
                              UIColor(red: 0.98, green: 0.89, blue: 0.72, alpha: 1.0), // KR
                              UIColor(red: 0.99, green: 0.72, blue: 0.5, alpha: 1.0), // US
                              UIColor(red: 0.75, green: 0.89, blue: 0.83, alpha: 1.0)] // ETC
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        addSubview(stackView)
        
        // Set height constraint of stack view
        stackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // Add buttons to stack view
        for i in 0..<7 {
            let button = UIButton()
            button.setTitle(buttonTitlesinKR[i], for: .normal)
            button.titleLabel?.font = UIFont(name: "Sunflower-Light", size: 14)
            button.backgroundColor = buttonColors[i]
            button.layer.cornerRadius = 6
            button.clipsToBounds = true
            stackView.addArrangedSubview(button)
        }
    }
}


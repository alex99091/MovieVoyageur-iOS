//
//  GenreHeaderView.swift
//  movieMatch-iOS
//
//  Created by BOONGKI KWAK on 2023/03/04.
//

import UIKit

class GenreHeaderView: UICollectionReusableView, ReuseIdentifiable {
    
    let stackView = UIStackView()
    let buttonTitlesinKR = ["드라마", "다큐", "코미디", "애니메이션", "스릴러", "액션", "에로"]
    let buttonTitlesinCode = ["1","10","11","15","16","19","21"]
    let buttonBackgroundColor = UIColor(red: 0.4, green: 0.8, blue: 0.6, alpha: 1.0)
    
    let buttonColors = [UIColor(red: 0.99, green: 0.72, blue: 0.5, alpha: 1.0), // 드라마
                        UIColor(red: 0.75, green: 0.89, blue: 0.83, alpha: 1.0), // 다큐
                        UIColor(red: 0.96, green: 0.73, blue: 0.81, alpha: 1.0), // 코미디
                        UIColor(red: 0.83, green: 0.85, blue: 0.92, alpha: 1.0), // 애니메이션
                        UIColor(red: 0.98, green: 0.89, blue: 0.72, alpha: 1.0), // 스릴러
                        UIColor(red: 0.83, green: 0.85, blue: 0.92, alpha: 1.0), // 액션
                        UIColor(red: 0.75, green: 0.89, blue: 0.83, alpha: 1.0)] // 에로
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // Set up stack view
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
        
        // Set width of stack view to match width of header
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: widthAnchor)
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

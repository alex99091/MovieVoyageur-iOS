//
//  SearchHeaderView.swift
//  MovieVoyageur-iOS
//
//  Created by BOONGKI KWAK on 2023/03/07.
//

import UIKit

class SearchHeaderView: UICollectionReusableView, ReuseIdentifiable {
    
    weak var parentViewController: SearchViewController?
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
        label.textColor = .black
        label.text = "최근 검색어"
        label.font = UIFont(name: "Sunflower-Medium", size: 18.0)
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        button.backgroundColor = .red
        button.setTitle("전체 삭제", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Sunflower-Medium", size: 18.0)
        button.layer.cornerRadius = 5
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(clearSearchTerms), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(button.frame.width + 20)),
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    @objc private func clearSearchTerms() {
        parentViewController?.searchTermList = []
        parentViewController?.searchCollectionView.reloadData()
    }
}

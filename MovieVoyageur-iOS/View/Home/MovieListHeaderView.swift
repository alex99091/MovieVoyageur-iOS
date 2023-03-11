//
//  MovieListHeaderView.swift
//  MovieMatch-iOS
//
//  Created by BOONGKI KWAK on 2023/03/06.
//

import UIKit

class MovieListHeaderView: UICollectionReusableView, ReuseIdentifiable {
    
    let label = UILabel()
    weak var parentViewController: MovieListViewController?
    
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
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(popController), for: .touchUpInside)
        
        addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            button.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 20),
            button.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    @objc private func popController() {
        self.parentViewController?.navigationController?.popViewController(animated: true)
    }
    
    func configureStyle(with text: String?){
        label.textColor = .black
        label.text = text
        label.font = UIFont(name: "Sunflower-Bold", size: 20.0)
    }
}

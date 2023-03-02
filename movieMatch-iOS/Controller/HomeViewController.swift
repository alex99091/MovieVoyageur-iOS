//
//  HomeViewController.swift
//  movieMatch-iOS
//
//  Created by BOONGKI KWAK on 2023/03/02.
//

import UIKit

class HomeViewController: UIViewController {
    
    // IB Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    // Property
    
    // Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //movieCollectionView.dataSource = self
        //movieCollectionView.delegate = self
    }
    
    // Method
}

//extension HomeViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
//
//
//}

extension HomeViewController: UICollectionViewDelegate {
    
}


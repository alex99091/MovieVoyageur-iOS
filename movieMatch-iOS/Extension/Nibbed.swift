//
//  Nibbed.swift
//  movieMatch-iOS
//
//  Created by BOONGKI KWAK on 2023/03/03.
//

import UIKit

extension UICollectionViewCell : Nibbed { }

protocol Nibbed {
    static var uinib: UINib { get }
}

extension Nibbed {
    static var uinib: UINib {
        return UINib(nibName: String(describing: Self.self), bundle: nil)
    }
}

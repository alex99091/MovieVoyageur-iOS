//
//  ReuseIdentifiable.swift
//  movieMatch-iOS
//
//  Created by BOONGKI KWAK on 2023/03/03.
//

import UIKit

protocol ReuseIdentifiable {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}


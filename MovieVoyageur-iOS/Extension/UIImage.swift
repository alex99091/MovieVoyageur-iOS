//
//  UIImage.swift
//  MovieVoyageur-iOS
//
//  Created by BOONGKI KWAK on 2023/03/06.
//

import UIKit

extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

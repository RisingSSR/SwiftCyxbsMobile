//
//  UIView+Cyxbs.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/7.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

extension UIResponder {
    
    var latestViewController: UIViewController? {
        (next as? UIViewController) ?? next?.latestViewController
    }
    
    var latestNavigationController: UINavigationController? {
        let latestViewController = latestViewController
        return latestViewController?.navigationController ?? latestViewController?.latestNavigationController
    }
}

extension UIView {
    
    static var identifier: String { "CyxbsMobile2019_iOS.\(self)" }
    
    var copyByKeyedArchiver: UIView? {
        let archiver = NSKeyedArchiver(requiringSecureCoding: false)
        archiver.encode(self, forKey: "view")
        let data = archiver.encodedData
        let unArchiver = try? NSKeyedUnarchiver(forReadingFrom: data)
        unArchiver?.requiresSecureCoding = false
        return unArchiver?.decodeObject(forKey: "view") as? UIView
    }
    
    var gradientLayer: CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = bounds
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 1)
        layer.colors = [
            UIColor.hex("#4841E2").cgColor,
            UIColor.hex("#5D5DF7").cgColor
        ]
        return layer
    }
}

extension UIScrollView {
    
    var collectionView: UICollectionView {
        self as! UICollectionView
    }
}

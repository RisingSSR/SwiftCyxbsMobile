//
//  UIView+Cyxbs.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/7.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

extension NSCoding {
    
    var copyByKeyedArchiver: Self? {
        let archiver = NSKeyedArchiver(requiringSecureCoding: false)
        archiver.encode(self, forKey: "ry_copyed")
        let data = archiver.encodedData
        let unArchiver = try? NSKeyedUnarchiver(forReadingFrom: data)
        unArchiver?.requiresSecureCoding = false
        return unArchiver?.decodeObject(forKey: "ry_copyed") as? Self
    }
}

private weak var ssr_currentFirstResponder: AnyObject?

extension UIResponder {
    
    var latestViewController: UIViewController? {
        (next as? UIViewController) ?? next?.latestViewController
    }
    
    var latestNavigationController: UINavigationController? {
        let latestViewController = latestViewController
        if let nav = latestViewController?.navigationController {
            return nav
        }
        if let subs = (latestViewController as? UITabBarController)?.viewControllers {
            for sub in subs {
                return sub.latestNavigationController
            }
        }
        if let subs = (latestViewController as? UISplitViewController)?.viewControllers {
            for sub in subs {
                return sub.latestNavigationController
            }
        }
        return nil
    }
        
    static var firstResponder: AnyObject? {
        ssr_currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(ssr_findFirstResponder(_:)), to: nil, from: nil, for: nil)
        return ssr_currentFirstResponder
    }
    
    @objc func ssr_findFirstResponder(_ sender: AnyObject) {
        ssr_currentFirstResponder = self
    }
}

extension UIView {
    
    static var identifier: String { "CyxbsMobile2019_iOS.\(self)" }
    
    @discardableResult
    func mix(fillColor: UIColor? = nil, path: UIBezierPath, shadowColor: UIColor, shadowOpacity: CGFloat = 1, shadowOffset: CGSize = CGSize(width: 0, height: -3)) -> CAShapeLayer {
        let fillColor = fillColor ?? backgroundColor ?? .clear
        backgroundColor = nil
        
        layer.shadowPath = path.cgPath
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = Float(shadowOpacity)
        layer.shadowOffset = shadowOffset
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = bounds
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = fillColor.cgColor
        
        layer.addSublayer(shapeLayer)
        
        return shapeLayer
    }
}

extension UIScrollView {
    
    var as_collectionView: UICollectionView? {
        self as? UICollectionView
    }
    
    var as_tableView: UITableView? {
        self as? UITableView
    }
}

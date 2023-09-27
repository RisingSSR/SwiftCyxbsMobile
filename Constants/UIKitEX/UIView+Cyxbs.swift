//
//  UIView+Cyxbs.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/7.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

private weak var ssr_currentFirstResponder: AnyObject?

extension UIResponder {
    
    var latestViewController: UIViewController? {
        (next as? UIViewController) ?? next?.latestViewController
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
    
    var copyByKeyedArchiver: UIView? {
        let archiver = NSKeyedArchiver(requiringSecureCoding: false)
        archiver.encode(self, forKey: "view")
        let data = archiver.encodedData
        let unArchiver = try? NSKeyedUnarchiver(forReadingFrom: data)
        unArchiver?.requiresSecureCoding = false
        return unArchiver?.decodeObject(forKey: "view") as? UIView
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

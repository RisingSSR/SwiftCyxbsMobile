//
//  ThemeProtocol.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/4.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation

import UIKit

protocol ThemeProtocol {
    
    // tabbar
    
    var titleColorForTabBarUnselect: UIColor { get }
    
    var titleColorForTabBarSelect: UIColor { get }
    
    // similar to the system color

    var backgroundColorForPlace_main: UIColor { get }
    
    var backgroundColorForPlace_tabBar: UIColor { get }
    
    var backgroundColorForPlace_p0: UIColor { get }
    
    var backgroundColorForPlace_p1: UIColor { get }
    
    var backgroundColorForPlace_p2: UIColor { get }
    
    // opposite to system color
    
    var titleColorForPlace_main: UIColor { get }
    
    var titleColorForPlace_p0: UIColor { get }
    
    var titleColorForPlace_p1: UIColor { get }
    
    var titleColorForPlace_p2: UIColor { get }
    
    var titleColorForPlaceholder: UIColor { get }
    
    // similar to the system color
    
    var titleColorInSimilarForPlace_main: UIColor { get }
    
    var titleColorInSimilarForPlace_p0: UIColor { get }
    
    var titleColorInSimilarForPlace_p1: UIColor { get }
    
    var titleColorInSimilarForPlace_p2: UIColor { get }

    var titleColorInSimilarForPlaceholder: UIColor { get }
}

extension ThemeProtocol {
    func color<T: UIColor>(_ property: KeyPath<ThemeProtocol, T>) -> T {
        self[keyPath: property]
    }
}

//
//  UITabBarItem+TabBar.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/5.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit
import ObjectiveC

extension UITabBarItem {
    
    struct Constants {
        static var ry_needMoreSpaceToShow = "CyxbsMobile2019_iOS.UITabBarItem.ry_needMoreSpaceToShow"
    }
    
    var needMoreSpaceToShow: Bool {
        get {
            withUnsafePointer(to: &Constants.ry_needMoreSpaceToShow) {
                objc_getAssociatedObject(self, $0)
            } as? Bool ?? true
        }
        set {
            withUnsafePointer(to: &Constants.ry_needMoreSpaceToShow) {
                objc_setAssociatedObject(self, $0, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
        }
    }
}

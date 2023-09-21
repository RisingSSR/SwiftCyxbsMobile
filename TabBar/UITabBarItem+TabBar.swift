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
    
    static var ry_needMoreSpaceToShow = "CyxbsMobile2019_iOS.UITabBarItem.ry_needMoreSpaceToShow"
    var needMoreSpaceToShow: Bool {
        get { objc_getAssociatedObject(self, &UITabBarItem.ry_needMoreSpaceToShow) as? Bool ?? true }
        set { objc_setAssociatedObject(self, &UITabBarItem.ry_needMoreSpaceToShow, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }
}

//
//  DarkTheme.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/4.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

struct DarkTheme: ThemeProtocol {
    
    // tabbar
    
    /// "发现" 未选中
    var titleColorForTabBarUnselect: UIColor        { .hex("#5A5A5A") }
    
    /// "发现" 选中
    var titleColorForTabBarSelect: UIColor          { .hex("#465FFF") }
    
    // similar to the system color
    
    /// 全黑色
    var backgroundColorForPlace_main: UIColor       { .hex("#000000") }
    
    /// 底部导航栏黑
    var backgroundColorForPlace_tabBar: UIColor     { .hex("#2D2D2D") }
    
    /// "电费查询" "志愿服务"白
    var backgroundColorForPlace_p0: UIColor         { .hex("#1D1D1D") }
    
    /// 首页最底层白
    var backgroundColorForPlace_p1: UIColor         { .hex("#241F35") }
    
    /// tableView底白
    var backgroundColorForPlace_p2: UIColor         { .hex("#2C2C2C") }
    
    // opposite to system color
    
    /// 大字白
    var titleColorForPlace_main: UIColor            { .hex("#FFFFFF") }
    
    /// 大数值蓝
    var titleColorForPlace_p0: UIColor              { .hex("#FFFFFF") }
    
    /// 描述灰
    var titleColorForPlace_p1: UIColor              { .hex("#F0F0F2") }
    
    /// [T]15315B
    var titleColorForPlace_p2: UIColor              { .hex("#15315B") }
    
    /// [T]94A6C4
    var titleColorForPlaceholder: UIColor           { .hex("#94A6C4") }
    
    // similar to the system color
    
    /// 纯黑字
    var titleColorInSimilarForPlace_main: UIColor   { .hex("#000000") }
    
    /// [T]C3D4EE
    var titleColorInSimilarForPlace_p0: UIColor     { .hex("#C3D4EE") }
    
    /// [T]15315B
    var titleColorInSimilarForPlace_p1: UIColor     { .hex("#15315B") }
    
    /// [T]15315B
    var titleColorInSimilarForPlace_p2: UIColor     { .hex("#15315B") }
    
    /// [T]15315B
    var titleColorInSimilarForPlaceholder: UIColor  { .hex("#15315B") }
}

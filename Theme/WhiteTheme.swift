//
//  WhiteTheme.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/4.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

struct WhiteTheme: ThemeProtocol {
    
    // tabbar
    
    /// "发现" 未选中
    var titleColorForTabBarUnselect: UIColor        { .hex("#5A5A5A") }
    
    /// "发现" 选中
    var titleColorForTabBarSelect: UIColor          { .hex("#465FFF") }
    
    // similar to the system color
    
    /// 全白色
    var backgroundColorForPlace_main: UIColor       { .hex("#FFFFFF") }
    
    /// 底部导航栏白
    var backgroundColorForPlace_tabBar: UIColor     { .hex("#FFFFFF") }
    
    /// "电费查询" "志愿服务"白
    var backgroundColorForPlace_p0: UIColor         { .hex("#AEB6D3") }
    
    /// 首页最底层白
    var backgroundColorForPlace_p1: UIColor         { .hex("#F2F3F8") }
    
    /// tableView底白
    var backgroundColorForPlace_p2: UIColor         { .hex("#F8F9FC") }
    
    // opposite to system color
    
    /// 大字蓝
    var titleColorForPlace_main: UIColor            { .hex("#15315B") }
    
    /// 大数值蓝
    var titleColorForPlace_p0: UIColor              { .hex("#2A4E84") }
    
    /// 描述灰
    var titleColorForPlace_p1: UIColor              { .hex("#F0F0F2") }
    
    /// [T]7B8899
    var titleColorForPlace_p2: UIColor              { .hex("#7B8899") }
    
    /// [T]94A6C4
    var titleColorForPlaceholder: UIColor           { .hex("#94A6C4") }
    
    // similar to the system color
    
    /// 纯白字
    var titleColorInSimilarForPlace_main: UIColor   { .hex("#FFFFFF") }
    
    /// [T]C3D4EE
    var titleColorInSimilarForPlace_p0: UIColor     { .hex("#C3D4EE") }
    
    /// [T]15315B
    var titleColorInSimilarForPlace_p1: UIColor     { .hex("#15315B") }
    
    /// [T]15315B
    var titleColorInSimilarForPlace_p2: UIColor     { .hex("#15315B") }
    
    /// [T]15315B
    var titleColorInSimilarForPlaceholder: UIColor  { .hex("#15315B") }
}

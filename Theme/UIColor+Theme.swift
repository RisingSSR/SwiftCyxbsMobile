//
//  UIColor+Theme.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/4.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation
import FluentDarkModeKit

extension UIColor {
    
    class func hex(_ hexString: String, alpha: CGFloat = 1) -> UIColor {
        var hString = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hString.count < 6 {
            return UIColor.clear
        }
        if hString.hasPrefix("#") {
            hString = hString.components(separatedBy: "#").last ?? ""
        } else if hString.hasPrefix("0X") {
            hString = hString.components(separatedBy: "0X").last ?? ""
        }
        if hString.count != 6 {
            return UIColor.clear
        }
        let rString = String(hString.prefix(2))
        let gString = String(hString.dropFirst(2).prefix(2))
        let bString = String(hString.suffix(2))
        var r: UInt64 = 0, g: UInt64 = 0, b: UInt64 = 0
        Scanner(string: rString).scanHexInt64(&r)
        Scanner(string: gString).scanHexInt64(&g)
        Scanner(string: bString).scanHexInt64(&b)
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
    
    static let ry = _ry()
    
    struct _ry: ThemeProtocol {
        
        let whiteTheme = WhiteTheme()
        let darkTheme = DarkTheme()
        
        func color(light: UIColor, dark: UIColor) -> UIColor {
            .init(.dm, light: light, dark: dark)
        }
        
        func make<T: UIColor>(_ property: KeyPath<ThemeProtocol, T>) -> UIColor {
            color(light: whiteTheme.color(property), dark: darkTheme.color(property))
        }
        
        func make<T: UIColor, U: UIColor>(_ tProperty: KeyPath<ThemeProtocol, T>, _ uProperty: KeyPath<ThemeProtocol, U>) -> UIColor {
            color(light: whiteTheme.color(tProperty), dark: darkTheme.color(uProperty))
        }
        
        // ThemeProtocol
        
        var titleColorForTabBarUnselect: UIColor {
            make(\.titleColorForTabBarUnselect)
        }
        
        var titleColorForTabBarSelect: UIColor {
            make(\.titleColorForTabBarSelect)
        }
        
        var backgroundColorForPlace_main: UIColor {
            make(\.backgroundColorForPlace_main)
        }
        
        var backgroundColorForPlace_tabBar: UIColor {
            make(\.backgroundColorForPlace_tabBar)
        }
        
        var backgroundColorForPlace_p0: UIColor {
            make(\.backgroundColorForPlace_p0)
        }
        
        var backgroundColorForPlace_p1: UIColor {
            make(\.backgroundColorForPlace_p1)
        }
        
        var backgroundColorForPlace_p2: UIColor {
            make(\.backgroundColorForPlace_p2)
        }
        
        var titleColorForPlace_main: UIColor {
            make(\.titleColorForPlace_main)
        }
        
        var titleColorForPlace_p0: UIColor {
            make(\.titleColorForPlace_p0)
        }
        
        var titleColorForPlace_p1: UIColor {
            make(\.titleColorForPlace_p1)
        }
        
        var titleColorForPlace_p2: UIColor {
            make(\.titleColorForPlace_p2)
        }
        
        var titleColorForPlaceholder: UIColor {
            make(\.titleColorForPlaceholder)
        }
        
        var titleColorInSimilarForPlace_main: UIColor {
            make(\.titleColorInSimilarForPlace_main)
        }
        
        var titleColorInSimilarForPlace_p0: UIColor {
            make(\.titleColorInSimilarForPlace_p0)
        }
        
        var titleColorInSimilarForPlace_p1: UIColor {
            make(\.titleColorInSimilarForPlace_p1)
        }
        
        var titleColorInSimilarForPlace_p2: UIColor {
            make(\.titleColorInSimilarForPlace_p2)
        }
        
        var titleColorInSimilarForPlaceholder: UIColor {
            make(\.titleColorInSimilarForPlaceholder)
        }
    }
}

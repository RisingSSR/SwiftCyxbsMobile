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
    
    convenience init?(hexString: String) {
        var str = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if str.hasPrefix("#") {
            str = String(str.dropFirst())
        } else if str.hasPrefix("0X") {
            str = String(str.dropFirst(2))
        }

        let length = str.count
        guard length == 3 || length == 4 || length == 6 || length == 8 else {
            return nil
        }

        var rgba: (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 1)

        if length < 5 {
            rgba.0 = hexStrToInt(String(str.prefix(1))) / 255.0
            rgba.1 = hexStrToInt(String(String(str.prefix(2)).suffix(1))) / 255.0
            rgba.2 = hexStrToInt(String(str.suffix(1))) / 255.0
            if length == 4 {
                rgba.3 = hexStrToInt(String(str.suffix(1))) / 255.0
            }
        } else {
            rgba.0 = hexStrToInt(String(str.prefix(2))) / 255.0
            rgba.1 = hexStrToInt(String(String(str.prefix(4)).suffix(2))) / 255.0
            rgba.2 = hexStrToInt(String(String(str.prefix(6)).suffix(2))) / 255.0
            if length == 8 {
                rgba.3 = hexStrToInt(String(str.suffix(2))) / 255.0
            }
        }

        self.init(red: rgba.0, green: rgba.1, blue: rgba.2, alpha: rgba.3)
        
        func hexStrToInt(_ str: String) -> CGFloat {
            var result: UInt32 = 0
            let scanner = Scanner(string: str)
            scanner.scanHexInt32(&result)
            return CGFloat(result)
        }
    }
    
    class func hex(_ hexString: String) -> UIColor {
        UIColor(hexString: hexString) ?? .clear
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

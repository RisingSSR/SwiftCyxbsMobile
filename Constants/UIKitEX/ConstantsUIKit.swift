//
//  ConstantsUIKit.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/26.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

extension Constants {
    
    static let keyWindow: UIWindow? = {
        if #available(iOS 13, *) {
            return UIApplication.shared.connectedScenes.compactMap { scene in
                guard let scene = (scene as? UIWindowScene), scene.activationState == .foregroundActive else { return nil }
                return scene.windows.first { $0.isKeyWindow }
            }.first
        } else {
            return UIApplication.shared.keyWindow
        }
    }()
    
    static var safeDistanceTop: CGFloat {
        keyWindow?.safeAreaInsets.top ?? 0
    }
    
    static var safeDistanceBottom: CGFloat {
        keyWindow?.safeAreaInsets.bottom ?? 0
    }
    
    static var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return 0 }
            guard let statusBarManager = windowScene.statusBarManager else { return 0 }
            return statusBarManager.statusBarFrame.height
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
    
    static var isLandscape: Bool {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows
                .first?
                .windowScene?
                .interfaceOrientation
                .isLandscape ?? false
        } else {
            return UIApplication.shared.statusBarOrientation.isLandscape
        }
    }
}

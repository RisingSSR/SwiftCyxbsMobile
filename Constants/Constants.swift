//
//  Constants.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/5.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

struct Constants {
    
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
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return 0 }
            guard let window = windowScene.windows.first else { return 0 }
            return window.safeAreaInsets.top
        } else if #available(iOS 11.0, *) {
            guard let window = UIApplication.shared.windows.first else { return 0 }
            return window.safeAreaInsets.top
        }
        return 0
    }
    
    static var safeDistanceBottom: CGFloat {
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return 0 }
            guard let window = windowScene.windows.first else { return 0 }
            return window.safeAreaInsets.bottom
        } else if #available(iOS 11.0, *) {
            guard let window = UIApplication.shared.windows.first else { return 0 }
            return window.safeAreaInsets.bottom
        }
        return 0
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
    
    static var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    static var deviceUUID: String {
        UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
    
    static var systemName: String {
        UIDevice.current.systemName
    }
    
    static var systemVersion: String {
        UIDevice.current.systemVersion
    }
}

//
//  UIButton+Cyxbs.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/5.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit
import ObjectiveC

extension UIButton {
    
    enum ImagePosition {
        
        case top        // image 上，label 下
        
        case left       // image 左，label 右
        
        case bottom     // image 下，label 上
        
        case right      // image 右，label 左
    }
    
    // Method
    
    func set(imageViewSize: CGSize, imagePostion: ImagePosition?, spaceForMiddle: CGFloat) {
        self.imageViewSize = imageViewSize
        self.imagePostion = imagePostion
        self.spaceForMiddle = spaceForMiddle
        UIButton.swizzleLayoutSubviews
    }
    
    // Associate
    
    private enum Constants {
        static var ry_imagePosition = "UIButton.ry_imagePosition"
        static var ry_spaceForMiddle = "UIButton.ry_spaceForMiddle"
        static var ry_imageViewSize = "UIButton.ry_imageViewSize"
    }
    
    var imagePostion: ImagePosition? {
        set { objc_setAssociatedObject(self, &Constants.ry_imagePosition, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
        get { objc_getAssociatedObject(self, &Constants.ry_imagePosition) as? UIButton.ImagePosition }
    }
    
    var spaceForMiddle: CGFloat {
        set { objc_setAssociatedObject(self, &Constants.ry_spaceForMiddle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
        get { objc_getAssociatedObject(self, &Constants.ry_spaceForMiddle) as? CGFloat ?? 0 }
    }
    
    
    var imageViewSize: CGSize {
        set { objc_setAssociatedObject(self, &Constants.ry_imageViewSize, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
        get { objc_getAssociatedObject(self, &Constants.ry_imageViewSize) as? CGSize ?? imageView?.frame.size ?? .zero }
    }
    
    // swizzle
    
    private static let swizzleLayoutSubviews: Void = {
        let method1 = class_getMethodImplementation(UIButton.self, #selector(layoutSubviews))
        let method2 = class_getMethodImplementation(UIButton.self, #selector(ry_layoutSubviews))
        if let method1, let method2 {
            method_exchangeImplementations(method1, method2)
        }
    }()
    
    @objc func ry_layoutSubviews() {
        ry_layoutSubviews()
        
        if let imagePostion {
            imageView?.frame.size = imageViewSize
            guard let imgFrame = imageView?.frame, let titleFrame = titleLabel?.frame else { return }
            
            switch imagePostion {
            case .top:
                let spaceForY = (bounds.height - imgFrame.height - titleFrame.height - spaceForMiddle) / 2
                let spaceForImgX = (bounds.width - imgFrame.width) / 2
                let spaceForTilX = (bounds.width - titleFrame.width) / 2
                imageView?.frame.origin = CGPoint(x: spaceForImgX, y: spaceForY)
                titleLabel?.frame.origin = CGPoint(x: spaceForTilX, y: spaceForY + imgFrame.height + spaceForMiddle)
                
            case .left:
                let spaceForX = (bounds.width - imgFrame.width - titleFrame.width - spaceForMiddle) / 2
                let spaceForImgY = (bounds.height - imgFrame.height) / 2
                let spaceForTilY = (bounds.height - titleFrame.height) / 2
                imageView?.frame.origin = CGPoint(x: spaceForX, y: spaceForImgY)
                titleLabel?.frame.origin = CGPoint(x: spaceForX + imgFrame.width + spaceForMiddle, y: spaceForTilY)
                
            case .bottom:
                let spaceForY = (bounds.height - imgFrame.height - titleFrame.height - spaceForMiddle) / 2
                let spaceForTilX = (bounds.width - titleFrame.width) / 2
                let spaceForImgX = (bounds.width - imgFrame.width) / 2
                titleLabel?.frame.origin = CGPoint(x: spaceForTilX, y: spaceForY)
                imageView?.frame.origin = CGPoint(x: spaceForImgX, y: spaceForY + titleFrame.height + spaceForMiddle)
                
            case .right:
                let spaceForX = (bounds.width - imgFrame.width - titleFrame.width - spaceForMiddle) / 2
                let spaceForTilY = (bounds.height - titleFrame.height) / 2
                let spaceForImgY = (bounds.height - imgFrame.height) / 2
                titleLabel?.frame.origin = CGPoint(x: spaceForX, y: spaceForTilY)
                imageView?.frame.origin = CGPoint(x: spaceForX + titleFrame.width + spaceForMiddle, y: spaceForImgY)
            }
        }
    }
}

extension UIButton {
    
    var gradientLayer: CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = bounds
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.colors = [
            UIColor.hex("#4841E2").cgColor,
            UIColor.hex("#5D5DF7").cgColor
        ]
        layer.locations = [0, 1]
        return layer
    }
    
    convenience init(gradientLayerSize size: CGSize, title: String?) {
        self.init(frame: CGRect(origin: .zero, size: size))
        layer.addSublayer(gradientLayer)
        layer.cornerRadius = size.height / 2
        clipsToBounds = true
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
    }
}

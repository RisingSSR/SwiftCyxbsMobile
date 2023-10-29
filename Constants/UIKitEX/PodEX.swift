//
//  PodEX.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/15.
//  Copyright © 2023 Redrock. All rights reserved.
//

import MJRefresh

// MARK: MJRefreshGifHeader

/*
 
 let header = MJRefreshGifHeader {
     <#self.cleanAndReload()#>
 }
 .autoChangeTransparency(true)
 .set_refresh_sports()
 .link(to: <#collectionView#>)
 
 */

extension MJRefreshHeader {
    
    @discardableResult
    func ignoredScrollView(contentInsetTop: CGFloat) -> Self {
        ignoredScrollViewContentInsetTop = contentInsetTop
        return self
    }
    
    @discardableResult
    func isCollectionViewAnimationBug(open: Bool) -> Self {
        isCollectionViewAnimationBug = open
        return self
    }
}

extension MJRefreshGifHeader {
    
    @discardableResult
    func set_refresh_sports() -> Self {
        let iamgeCount = 12
        var images = [UIImage]()
        let image_0 = UIImage(named: "refresh_sport_0")!
        for i in 0 ..< iamgeCount {
            if let image = UIImage(named: String(format: "refresh_sport_%d", i)) {
                images.append(image)
            }
        }
        let idleImages = [image_0, image_0] + images + [image_0, image_0]
        setImages(idleImages, for: .idle)
        setImages(images, for: .refreshing)
        lastUpdatedTimeLabel?.isHidden = true
        stateLabel?.isHidden = true
        return self
    }
}

// MARK: CyxbsSegmentedIndicatorView

import JXSegmentedView

open class CyxbsSegmentedIndicatorView: JXSegmentedIndicatorBaseView {

    open override func commonInit() {
        super.commonInit()

        indicatorWidth = 66
        indicatorHeight = 3
    }
    
    lazy var leftDownView: UIView =  {
        let left = UIView()
        left.backgroundColor = .hex("#81E2F5")
        left.layer.masksToBounds = true
        return left
    }()
    
    lazy var leftUpView: UIView = {
        let left = UIView()
        left.backgroundColor = .hex("#19D0F2")
        left.layer.masksToBounds = true
        return left
    }()
    
    lazy var rightUpView: UIView = {
        let right = UIView()
        right.backgroundColor = .hex("#19D0F2")
        right.layer.masksToBounds = true
        return right
    }()

    open override func refreshIndicatorState(model: JXSegmentedIndicatorSelectedParams) {
        super.refreshIndicatorState(model: model)

        backgroundColor = nil

        let width = getIndicatorWidth(itemFrame: model.currentSelectedItemFrame, itemContentWidth: model.currentItemContentWidth)
        let height = getIndicatorHeight(itemFrame: model.currentSelectedItemFrame)
        let x = model.currentSelectedItemFrame.origin.x + (model.currentSelectedItemFrame.size.width - width)/2
        var y: CGFloat = 0
        switch indicatorPosition {
        case .top:
            y = verticalOffset
        case .bottom:
            y = model.currentSelectedItemFrame.size.height - height - verticalOffset
        case .center:
            y = (model.currentSelectedItemFrame.size.height - height)/2 + verticalOffset
        }
        frame = CGRect(x: x, y: y, width: width, height: height)
        
        leftUpView.frame.size = CGSize(width: 0.6 * width, height: height)
        leftUpView.layer.cornerRadius = height / 2
        
        rightUpView.frame.size = CGSize(width: height, height: height)
        rightUpView.frame.origin.x = width - height
        rightUpView.layer.cornerRadius = height / 2
        
        leftDownView.frame.size = CGSize(width: rightUpView.frame.minX - 1, height: height)
        leftDownView.layer.cornerRadius = height / 2
    }

    open override func contentScrollViewDidScroll(model: JXSegmentedIndicatorTransitionParams) {
        super.contentScrollViewDidScroll(model: model)

        guard canHandleTransition(model: model) else {
            return
        }

        let rightItemFrame = model.rightItemFrame
        let leftItemFrame = model.leftItemFrame
        let percent = model.percent
        let targetWidth = getIndicatorWidth(itemFrame: model.leftItemFrame, itemContentWidth: model.leftItemContentWidth)

        let leftX = leftItemFrame.origin.x + (leftItemFrame.size.width - targetWidth)/2
        let rightX = rightItemFrame.origin.x + (rightItemFrame.size.width - targetWidth)/2
        let targetX = JXSegmentedViewTool.interpolate(from: leftX, to: rightX, percent: CGFloat(percent))
        
        self.frame.origin.x = targetX
    }

    open override func selectItem(model: JXSegmentedIndicatorSelectedParams) {
        super.selectItem(model: model)

        let targetWidth = getIndicatorWidth(itemFrame: model.currentSelectedItemFrame, itemContentWidth: model.currentItemContentWidth)
        var toFrame = self.frame
        toFrame.origin.x = model.currentSelectedItemFrame.origin.x + (model.currentSelectedItemFrame.size.width - targetWidth)/2
        if canSelectedWithAnimation(model: model) {
            UIView.animate(withDuration: scrollAnimationDuration, delay: 0, options: .curveEaseOut) {
                self.frame = toFrame
            }
        }else {
            frame = toFrame
        }
    }
}


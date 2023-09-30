//
//  FinderViewController.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/5.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

class FinderViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ry(light: "#F2F3F8", dark: "#000000")
        
        view.addSubview(contentScrollView)
        setupUI()
    }
    
    lazy var contentScrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.backgroundColor = .clear
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    lazy var headerView: FinderHeaderView = {
        let headerView = FinderHeaderView(frame: CGRect(x: marginSpaceForHorizontal, y: Constants.statusBarHeight, width: view.bounds.width - 2 * marginSpaceForHorizontal, height: 55))
        return headerView
    }()
    
    lazy var bannerView: FinderBannerView = {
        let aspectRatio: CGFloat = 343.0 / 134.0
        let width = view.bounds.width - 2 * marginSpaceForHorizontal
        let bannerView = FinderBannerView(frame: CGRect(x: marginSpaceForHorizontal, y: headerView.frame.maxY + 6, width: width, height: width / aspectRatio))
        return bannerView
    }()
}

extension FinderViewController {
    
    var marginSpaceForHorizontal: CGFloat { 16 }
    
    func setupUI() {
        contentScrollView.addSubview(headerView)
        contentScrollView.addSubview(bannerView)
    }
    
    func reloadData() {
        headerView.reloadData()
        bannerView.request()
    }
}

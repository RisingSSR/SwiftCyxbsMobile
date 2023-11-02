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
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
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
    
    lazy var newsView: FinderNewsView = {
        let width = view.bounds.width - 2 * marginSpaceForHorizontal
        let newsView = FinderNewsView(frame: CGRect(x: marginSpaceForHorizontal, y: bannerView.frame.maxY + 15, width: width, height: 22))
        return newsView
    }()
    
    lazy var toolsView: FinderToolsView = {
        let width = view.bounds.width - 2 * marginSpaceForHorizontal
        let toolsView = FinderToolsView(frame: CGRect(x: marginSpaceForHorizontal, y: newsView.frame.maxY + 20, width: width, height: 70))
        return toolsView
    }()
    
    lazy var electricView: FinderElectricChargeView = {
        let width = view.bounds.width - 2 * marginSpaceForHorizontal
        let electricView = FinderElectricChargeView(frame: CGRect(x: marginSpaceForHorizontal, y: toolsView.frame.maxY + 20, width: width, height: 70))
        return electricView
    }()
}

extension FinderViewController {
    
    var marginSpaceForHorizontal: CGFloat { 16 }
    
    func setupUI() {
        contentScrollView.addSubview(headerView)
        contentScrollView.addSubview(bannerView)
        contentScrollView.addSubview(newsView)
        contentScrollView.addSubview(toolsView)
        contentScrollView.addSubview(electricView)
    }
    
    func reloadData() {
        headerView.reloadData()
        bannerView.request()
        electricView.viewModel.fetchData(buildingID: "32", room: "317")
    }
}

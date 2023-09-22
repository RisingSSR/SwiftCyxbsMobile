//
//  ScheduleViewController.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/9.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController {
    
    let fact = ScheduleInteractionFact()
    
    let heightForHeaderView: CGFloat = 64

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ry(light: "#FFFFFF", dark: "#1D1D1D")
        
        view.addSubview(headerView)
        view.addSubview(collectionView)
        
        fact.viewController = self
        fact.handle(headerView: headerView)
        fact.request(sno: "2021215154")
    }
    
    lazy var headerView: ScheduleHeaderView = {
        let headerView = ScheduleHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: heightForHeaderView))
        return headerView
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = fact.createCollectionView()
        collectionView.frame = CGRect(x: 0, y: heightForHeaderView, width: view.bounds.width, height: view.bounds.height - heightForHeaderView)
        collectionView.contentInset.bottom = tabBarController?.tabBar.bounds.height ?? 0
        collectionView.backgroundColor = view.backgroundColor
        return collectionView
    }()
}

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
    
    override func loadView() {
        super.loadView()
        view.frame.size.height -= Constants.statusBarHeight
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ry.backgroundColorForPlace_main
        view.addSubview(collectionView)
        
        fact.request(sno: "2021215154")
    }
    
    lazy var collectionView: UICollectionView = {
        let collectionView = fact.createCollectionView()
        let y: CGFloat = 64
        collectionView.frame = CGRect(x: 0, y: y, width: view.bounds.width, height: view.bounds.height - y)
        collectionView.contentInset.bottom = tabBarController?.tabBar.bounds.height ?? 0
        collectionView.backgroundColor = view.backgroundColor
        return collectionView
    }()
}

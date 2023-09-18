//
//  TabBarPresentationViewController.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/18.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

class TabBarPresentationViewController: UIViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        addChild(scheduleVC)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.cornerRadius = 16
        view.layer.shadowRadius = view.cornerRadius
        view.layer.shadowColor = UIColor.ry.color(light: .lightGray, dark: .darkGray).cgColor
        view.layer.shadowOpacity = 0.7
        view.layer.shadowOffset = CGSize(width: 0, height: -2)
        view.clipsToBounds = true
        
        view.addSubview(scheduleVC.view)
    }
    
    lazy var scheduleVC = ScheduleViewController()
}

extension TabBarPresentationViewController {
    
}

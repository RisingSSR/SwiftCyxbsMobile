//
//  TabBarPresentationViewController.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/18.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit
import RYTransitioningDelegateSwift

class TabBarPresentationViewController: UIViewController {
    
    var tabBarFrame: CGRect = .zero
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        addChild(scheduleVC)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
        scheduleVC.collectionView.frame.size.height -= Constants.statusBarHeight
        let pan = UIPanGestureRecognizer(target: self, action: #selector(response(pan:)))
        scheduleVC.headerView.addGestureRecognizer(pan)
    }
    
    lazy var scheduleVC = ScheduleViewController()
}

extension TabBarPresentationViewController {
    
    @objc
    func response(pan: UIPanGestureRecognizer) {
        dismissSchedule(pan: pan)
    }
    
    func dismissSchedule(pan: UIPanGestureRecognizer) {
        let transitionDelegate = RYTransitioningDelegate()
        transitionDelegate.panInsetsIfNeeded = UIEdgeInsets(top: Constants.statusBarHeight, left: 0, bottom: tabBarFrame.height, right: 0)
        transitionDelegate.panGestureIfNeeded = pan
        transitionDelegate.dismiss = { transition in
            transition.finishAnimationAction = { context in
                guard let from = context.viewController(forKey: .from) else { return }
                guard let headerView = from.view.subviews.last else { return }
                from.view.frame.origin.y = self.tabBarFrame.minY
                from.view.frame.size.height = headerView.bounds.height
                headerView.alpha = 1
                if let presentationVC = from as? TabBarPresentationViewController {
                    presentationVC.scheduleVC.headerView.alpha = 0
                }
            }
        }
        modalPresentationStyle = .custom
        self.transitioningDelegate = transitionDelegate
        dismiss(animated: true)
    }
}

//
//  TabBarController.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/1.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit
import SwifterSwift
import RYTransitioningDelegateSwift

open class TabBarController: UITabBarController {

    open override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
        setupViewControllers()
        
        Constants.mainSno = "2021215154"
        reloadData()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBar.ryTabBar?.headerView.handle_viewWillAppear()
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        reloadData()
    }
}

// MARK: data

extension TabBarController {
    
    func reloadData() {
        if let sno = Constants.mainSno,
           var scheduleModel = ScheduleModel.getFromCache(sno: sno) {

            let date = UserDefaultsManager.shared.latestRequest(sno: sno) ?? Date()
            let days = Calendar.current.dateComponents([.day], from: Date(), to: date).day ?? 0
            scheduleModel.nowWeek += days

            reloadWith(scheduleModel: scheduleModel)
        } else {
            request()
        }
    }
    
    func request() {
        if let sno = Constants.mainSno {
            ScheduleModel.request(sno: sno) { response in
                switch response {
                case .success(let model):
                    UserDefaultsManager.shared.cache(latestRequest: Date(), sno: sno)
                    model.toCache()
                    self.reloadWith(scheduleModel: model)
                case .failure(_):
                    self.reloadTabBarData(title: "网络连接失败", time: "请连接网络", place: "或开启流量")
                }
            }
        }
    }
    
    func reloadWith(scheduleModel: ScheduleModel) {
        let calModels = scheduleModel.calModels
        if let cur = ScheduleModel.calCourseWillBeTaking(with: calModels) {
            reloadTabBarData(title: cur.curriculum.course, time: cur.time, place: cur.curriculum.classRoom)
        } else {
            reloadTabBarData(title: "今天已经没课了", time: "好好休息吧", place: "明天新一天")
        }
    }
    
    func reloadTabBarData(title: String?, time: String?, place: String?) {
        tabBar.ryTabBar?.headerView.updateData(title: title, time: time, place: place)
    }
}

// MARK: setup

extension TabBarController {
    
    func setupTabBar() {
        let tabBar = TabBar()
        let pan = UIPanGestureRecognizer(target: self, action: #selector(response(pan:)))
        tabBar.headerView.addGestureRecognizer(pan)
        let tap = UITapGestureRecognizer(target: self, action: #selector(response(tap:)))
        tabBar.headerView.addGestureRecognizer(tap)
        setValue(tabBar, forKey: "tabBar")
    }
    
    func setupViewControllers() {
        let vcs = viewControllersForTabBar
        if vcs.count == 0 { return }
        let tabBarItems = tabBarItemsForTabBar
        for index in 0..<vcs.count {
            vcs[index].tabBarItem = tabBarItems[min(index, tabBarItems.count - 1)]
        }
        viewControllers = vcs
    }
}

// MARK: creater

extension TabBarController {
    
    var viewControllersForTabBar: [UIViewController] {
        [
            finderViewController,
            UIViewController(),
            UIViewController()
        ]
    }
    
    var tabBarItemsForTabBar: [UITabBarItem] {
        [
            createTabBar(title: "发现",
                         imageName: "TabBar_find_defualt",
                         selectedImageName: "TabBar_find_select"),
            
            createTabBar(title: "邮乐场",
                         imageName: "TabBar_carnie_defualt",
                         selectedImageName: "TabBar_carnie_select",
                         needMoreSpaceToShow: false),
            
            createTabBar(title: "我的",
                         imageName: "TabBar_mine_defualt",
                         selectedImageName: "TabBar_mine_select")
        ]
    }
    
    
    
    var finderViewController: UIViewController {
        let vc = FinderViewController()
        let nav = UINavigationController(rootViewController: vc)
        return nav
    }
    
    var carnieViewController: UIViewController {
        let vc = CarnieViewController()
        let nav = UINavigationController(rootViewController: vc)
        return nav
    }
    
    func createTabBar(title: String?, imageName: String, selectedImageName: String, needMoreSpaceToShow: Bool = true) -> UITabBarItem {
        let image = UIImage(named: imageName)?.scaled(toHeight: 25)?.withRenderingMode(.alwaysOriginal)
        let selectedImage = UIImage(named: selectedImageName)?.scaled(toHeight: 25)?.withRenderingMode(.alwaysOriginal)
        let tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.ry.titleColorForTabBarUnselect], for: .normal)
        tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.ry.titleColorForTabBarSelect], for: .selected)
        tabBarItem.needMoreSpaceToShow = needMoreSpaceToShow
        return tabBarItem
    }
}

// MARK: interaction

extension TabBarController {
    
    @objc
    func response(tap: UITapGestureRecognizer) {
        presentSchedule()
    }
    
    @objc
    func response(pan: UIPanGestureRecognizer) {
        if pan.state == .began {
            presentSchedule(pan: pan)
        }
    }
    
    func presentSchedule(pan: UIPanGestureRecognizer? = nil, completion: ((UIViewController) -> Void)? = nil) {
        if let presentedViewController {
            completion?(presentedViewController)
            return
        }
        
        let transitionDelegate = RYTransitioningDelegate()
        transitionDelegate.panInsetsIfNeeded = UIEdgeInsets(top: Constants.statusBarHeight, left: 0, bottom: tabBar.bounds.height, right: 0)
        transitionDelegate.supportedTapOutsideBackWhenPresent = false
        transitionDelegate.panGestureIfNeeded = pan
        
        let vc = ScheduleViewController()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = transitionDelegate
        present(vc, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 30)) {
                completion?(vc)
            }
        }
    }
}

// MARK: UITabBarDelegate

extension TabBarController {
    
    open override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let tabBar = tabBar as? TabBar {
            tabBar.isHeaderViewHidden = !item.needMoreSpaceToShow
            tabBar.reloadInputViews()
            tabBar.sizeToFit()
        }
    }
}

// MARK: RYTransitioningAnimationDelegate

extension TabBarController: RYTransitioningAnimationDelegate {
    
    public func prepare(_ transitioningDelegate: RYTransitioningDelegate, withAnimatedTransitioning animatedTransitioning: RYAnimatedTransitioning, forPresented context: UIViewControllerContextTransitioning) {
        
        guard let from = context.viewController(forKey: .from) as? UITabBarController else {
            animatedTransitioning.prepare(context: context)
            return
        }
        
        let tabBarCopy = from.tabBar.copyByKeyedArchiver
        
        
    }
}

// MARK: extension

extension UIViewController {
    var ryTabBarController: TabBarController {
        tabBarController as! TabBarController
    }
}

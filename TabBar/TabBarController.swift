//
//  TabBarController.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/1.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit
import SwifterSwift

open class TabBarController: UITabBarController {

    open override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
        setupViewControllers()
        
        ScheduleModel.request(sno: "2021215154") { response in
            switch response {
            case .success(let model):
                break
            case .failure(let netError):
                break
            }
        }
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        (tabBar as? TabBar)?.headerView.handle_viewWillAppear()
    }
}

extension TabBarController {
    
    func setupTabBar() {
        let tabBar = TabBar()
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
            
            createTabBar(title: "邮问",
                         imageName: "TabBar_ask_defualt",
                         selectedImageName: "TabBar_ask_select", needMoreSpaceToShow: false),
            
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

extension TabBarController {
    
    open override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let tabBar = tabBar as? TabBar {
            tabBar.isHeaderViewHidden = !item.needMoreSpaceToShow
            tabBar.reloadInputViews()
            tabBar.sizeToFit()
        }
    }
}

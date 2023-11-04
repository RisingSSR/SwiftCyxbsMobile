//
//  GiveMeJSViewController.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/10/31.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

class GiveMeJSViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .ry(light: "#FFFFFF", dark: "#1D1D1D")
        
        view.addSubview(headerView)
        view.addSubview(contentView)
    }
    
    lazy var headerView: GiveMeJSHeaderView = {
        let headerView = GiveMeJSHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: Constants.statusBarHeight + 43))
        return headerView
    }()
    
    lazy var contentView: GiveMeJSView = {
        let contentView = GiveMeJSView(frame: CGRect(x: 0, y: headerView.frame.maxY, width: view.bounds.width, height: view.bounds.height - headerView.frame.maxY))
        return contentView
    }()
}

extension GiveMeJSViewController {
    
}

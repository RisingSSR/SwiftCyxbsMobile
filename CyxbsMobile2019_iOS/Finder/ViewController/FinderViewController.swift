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
    }
    
    lazy var contentScrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.backgroundColor = .clear
        return scrollView
    }()
}

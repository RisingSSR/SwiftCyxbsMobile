//
//  CarnieViewController.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/15.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

class CarnieViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ry(light: "#F2F3F8", dark: "#000000")
        
        view.addSubview(contentScrollView)
        
        setupUI()
        request()
    }
    
    lazy var contentScrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.backgroundColor = .clear
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    lazy var headerView: CarnieHeaderView = {
        let space: CGFloat = 16
        let headerView = CarnieHeaderView(frame: CGRect(x: space, y: Constants.statusBarHeight + 28, width: view.bounds.width - 2 * space, height: 77))
        return headerView
    }()
    
    lazy var foodEntryView: CarnieEntryView = {
        let width = 168.0 / 375.0 * view.bounds.width
        let height = 220.0 / 168.0 * width
        let entryView = CarnieEntryView(frame: CGRect(x: 17, y: headerView.frame.maxY + 17, width: width, height: height))
        entryView.setupData(imgName: "carnie_food", title: "美食资讯处")
        entryView.imgView.frame.size = CGSize(width: entryView.bounds.width, height: 210)
        entryView.titleLab.frame.origin = CGPoint(x: 4, y: entryView.bounds.height - entryView.titleLab.bounds.height - 8)
        return entryView
    }()
}

extension CarnieViewController {
    
    func setupUI() {
        contentScrollView.addSubview(headerView)
        contentScrollView.addSubview(foodEntryView)
    }
    
    func request() {
        
        HttpManager.shared.magipoke_playground_center_days().ry_JSON { response in
            if case .success(let model) = response, model["status"].intValue == 10000 {
                UserDefaultsManager.shared.daysOfEntryCarnie = model["data"]["days"].intValue
            } else {
                if Calendar.current.isDateInToday(UserDefaultsManager.shared.latestRequestDate ?? Date()) {
                    UserDefaultsManager.shared.daysOfEntryCarnie += 1
                }
            }
            
            if let person = UserModel.defualt.person {
                self.setupData(person: person)
            } else {
                HttpManager.shared.magipoke_Person_Search().ry_JSON { response in
                    if case .success(let model) = response, model["status"].stringValue == "10000" {
                        let person = PersonModel(json: model["data"])
                        UserModel.defualt.person = person
                        self.setupData(person: person)
                    }
                }
            }
        }
    }
    
    func setupData(person: PersonModel) {
        headerView.update(imgURL: person.photo_src, title: "Hi~，\(person.nickname)（\(person.username)）", days: UserDefaultsManager.shared.daysOfEntryCarnie)
    }
}

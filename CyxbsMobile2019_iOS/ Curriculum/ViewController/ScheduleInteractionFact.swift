//
//  ScheduleInteractionFact.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/14.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit
import MJRefresh

class ScheduleInteractionFact: ScheduleFact {
    
    private(set) var collectionView: UICollectionView!
    
    weak var headerView: ScheduleHeaderView?
    
    override func createCollectionView() -> UICollectionView {
        let collectionView = super.createCollectionView()
        
        let header = MJRefreshGifHeader {
            self.mappy.clean()
            self.request(sno: "2021215154")
        }
        .autoChangeTransparency(true)
        .set_refresh_sports()
        .ignoredScrollView(contentInsetTop: -58)
        .link(to: collectionView)
        
        header.isCollectionViewAnimationBug = true
        header.endRefreshingAnimationBeginAction = {
            collectionView.collectionViewLayout.finalizeLayoutTransition()
        }
        
        self.collectionView = collectionView
        return collectionView
    }
    
    func handle(headerView: ScheduleHeaderView) {
        self.headerView = headerView
        self.headerView?.updateData(section: 0, isNowSection: false)
    }
}

extension ScheduleInteractionFact {
    
    func request(sno: String) {
        ScheduleModel.request(sno: sno) { response in
            switch response {
            case .success(let model):
                self.mappy.maping(model)
                self.collectionView.reloadData()
            case .failure(let error):
                print("error \(error)")
            }
            self.collectionView.mj_header?.endRefreshing()
        }
    }
}

// MARK: UIScrollViewDelegate

extension ScheduleInteractionFact {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        scrollView.mj_header?.frame.origin.x = scrollView.contentOffset.x
        
    }
}

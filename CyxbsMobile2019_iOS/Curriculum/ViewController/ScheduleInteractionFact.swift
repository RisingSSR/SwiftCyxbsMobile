//
//  ScheduleInteractionFact.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/14.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit
import MJRefresh
import JXSegmentedView
import RYTransitioningDelegateSwift

class ScheduleInteractionFact: ScheduleFact {
    
    weak var viewController: UIViewController?
    
    private(set) var collectionView: UICollectionView!
    
    weak var headerView: ScheduleHeaderView?
    
    var isCustomEditEnable: Bool = false
    
    var snoToPriority: [String: ScheduleMaping.Priority] = [:]
    
    override func createCollectionView() -> UICollectionView {
        let collectionView = super.createCollectionView()
        
        let header = MJRefreshGifHeader {
            let priorities = self.mappy.scheduleModelMap.map { $0.value }
            self.mappy.clean()
            self.request(priorities: Set(priorities))
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
}

extension ScheduleInteractionFact {
    
    var currentPage: Int {
        Int(collectionView.contentOffset.x / collectionView.bounds.width / CGFloat(collectionView.ry_layout?.pageShows ?? 1) + 0.5)
    }
    
    func scroll(to section: Int, animated: Bool = true) {
        let visibleSection = min(max(0, section), 23)
        let pageWidth = collectionView.bounds.width / CGFloat(collectionView.ry_layout?.pageShows ?? 1) * CGFloat(visibleSection)
        collectionView.setContentOffset(CGPoint(x: pageWidth, y: collectionView.contentOffset.y), animated: true)
    }
    
    func scrollToNowWeek() {
        self.scroll(to: self.mappy.nowWeek)
    }
}

// MARK: request

extension ScheduleInteractionFact {
    
    func request(priorities: Set<ScheduleMaping.Priority>, complition: ((ScheduleInteractionFact) -> ())? = nil) {
        
        let requestSnos = Set(snoToPriority.compactMap {
            ($0.value != .custom && priorities.contains($0.value)) ?
            $0.key : nil
        })
        
        ScheduleModel.request(snos: requestSnos) { response in
            switch response {
            case .success(let models):
                for model in models {
                    let priority = self.snoToPriority[model.sno] ?? .mainly
                    self.mappy.maping(model, priority: priority)
                }
                self.collectionView.reloadData()
                complition?(self)
            case .failure(let netError):
                print("error \(netError)")
            }
        }
    }
    
    func request(sno: String, property: ScheduleMaping.Priority) {
        ScheduleModel.request(sno: sno) { response in
            switch response {
            case .success(let model):
                self.mappy.maping(model, priority: property)
                self.collectionView.reloadData()
            case .failure(let error):
                print("error \(error)")
            }
            self.collectionView.mj_header?.endRefreshing()
        }
    }
}

// MARK: handle headerView

extension ScheduleInteractionFact {
    
    func handle(headerView: ScheduleHeaderView) {
        headerView.titleTapAction = { _ in
            
            guard let headerView = self.headerView else { return }
            let selectView = ScheduleSelectSectionHeaderView(frame: headerView.frame)
            selectView.segmentView.defaultSelectedIndex = self.currentPage
            selectView.segmentView.listContainer = self
            selectView.backTapAction = { view in
                UIView.transition(from: view, to: headerView, duration: 0.3, options: .transitionCrossDissolve)
            }
            UIView.transition(from: headerView, to: selectView, duration: 0.3, options: .transitionCrossDissolve)
        }
        headerView.backBtnAction = { _ in
            self.scrollToNowWeek()
        }
        self.headerView = headerView
        self.headerView?.updateData(section: 0, isNowSection: false)
    }
    
    func reloadHeaderView() {
        let page = currentPage
        headerView?.updateData(section: page, isNowSection: (mappy.nowWeek == page))
    }
}

// MARK: UICollectionViewDelegate

extension ScheduleInteractionFact {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = data(of: indexPath)
        let cals = mappy.findCals(from: data)
        
        let transisionDelegate = RYTransitioningDelegate()
        transisionDelegate.present = { transition in
            transition.heightForPresented = 260
        }
        
        let vc = ScheduleDetailsViewController(cals: cals)
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = transisionDelegate
        
        viewController?.present(vc, animated: true)
    }
}

// MARK: UIScrollViewDelegate

extension ScheduleInteractionFact {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        scrollView.mj_header?.frame.origin.x = scrollView.contentOffset.x
        reloadHeaderView()
    }
}

// MARK: JXSegmentedViewListContainer

extension ScheduleInteractionFact: JXSegmentedViewListContainer {
    
    var defaultSelectedIndex: Int {
        get { currentPage }
        set(newValue) {
            scroll(to: newValue, animated: false)
        }
    }
    
    func contentScrollView() -> UIScrollView {
        collectionView
    }
    
    func reloadData() { }
    
    func didClickSelectedItem(at index: Int) {
        scroll(to: index)
    }
}

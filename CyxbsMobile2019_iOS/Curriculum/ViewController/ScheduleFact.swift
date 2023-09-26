//
//  ScheduleFact.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/11.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

class ScheduleFact: NSObject {
    
    let mappy = ScheduleMaping()
    
    private var scrollViewStartPosPoint: CGPoint = .zero
    
    private var scrollDirection: Int = 0
}

extension ScheduleFact {
    
    @objc
    func createCollectionView() -> UICollectionView {
        let layout = ScheduleCollectionViewLayout()
        layout.lineSpacing = 2
        layout.columnSpacing = 2
        layout.widthForLeadingSupplementaryView = 30
        layout.dataSource = self
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false 
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.isDirectionalLockEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.decelerationRate = .fast
        /* cell */
        collectionView.register(ScheduleCollectionViewCell.self, forCellWithReuseIdentifier: ScheduleCollectionViewCell.curriculumReuseIdentifier)
        /* header */
        collectionView.register(ScheduleCollectionViewCell.self, forElementKindSection: .header, withReuseIdentifier: ScheduleCollectionViewCell.supplementaryReuseIdentifier)
        /* leading */
        collectionView.register(ScheduleCollectionViewCell.self, forElementKindSection: .leading, withReuseIdentifier: ScheduleCollectionViewCell.supplementaryReuseIdentifier)
        /* placeholder */
        collectionView.register(PlaceholderCollectionViewCell.self, forElementKindSection: .placeHolder, withReuseIdentifier: PlaceholderCollectionViewCell.identifier)
        
        return collectionView
    }
    
    func data(of indexPath: IndexPath) -> ScheduleMaping.Collection {
        mappy.datas[indexPath.section][indexPath.item]
    }
}

// MARK: UICollectionViewDataSource

extension ScheduleFact: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        max(mappy.datas.count, 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section >= mappy.datas.count { return 0 }
        return mappy.datas[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = data(of: indexPath)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScheduleCollectionViewCell.curriculumReuseIdentifier, for: indexPath) as! ScheduleCollectionViewCell
        
        var drawType: ScheduleCollectionViewCell.DrawType.CurriculumType = .morning
        
        if data.location <= 4 {
            drawType = .morning
        } else if data.location <= 8 {
            drawType = .afternoon
        } else {
            drawType = .night
        }
        cell.set(curriculumType: drawType, title: data.cal.curriculum.course, content: data.cal.curriculum.classRoom, isMultiple: data.count > 1)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let elementKind = UICollectionView.ElementKindSection(rawValue: kind) ?? .header
        
        switch elementKind {
            
        case .header:
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ScheduleCollectionViewCell.supplementaryReuseIdentifier, for: indexPath) as! ScheduleCollectionViewCell
            
            let startModay = mappy.start ?? Calendar.current.date(bySetting: .weekday, value: 2, of: Date()) ?? Date()
            
            let isTitleOnly = (indexPath.section == 0 || indexPath.item == 0 || mappy.start == nil)
            let currenDay = Calendar.current.date(byAdding: .day, value: (indexPath.section - 1) * 7 + indexPath.item - 1, to: startModay) ?? Date()
            let isToday = Calendar.current.isDateInToday(currenDay)
            
            var title: String? = nil
            if indexPath.item == 0 {
                if indexPath.section == 0 {
                    title = "学期"
                } else {
                    title = currenDay.string(locale: .cn, format: "M月")
                }
            } else {
                title = currenDay.string(locale: .cn, format: "EEE")
            }
            
            let content = currenDay.string(locale: .cn, format: "d日")
            
            cell.set(supplementaryType: isToday ? .select : .normal, title: title, content: content, isTitleOnly: isTitleOnly)
            cell.backgroundColor = collectionView.backgroundColor
            
            return cell
            
        case .leading:
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ScheduleCollectionViewCell.supplementaryReuseIdentifier, for: indexPath) as! ScheduleCollectionViewCell
            
            let title = "\(indexPath.item + 1)"
            
            cell.set(supplementaryType: .normal, title: title, content: nil, isTitleOnly: true)
            
            return cell
            
        case .placeHolder:
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PlaceholderCollectionViewCell.identifier, for: indexPath) as! PlaceholderCollectionViewCell
            
            if mappy.datas.count <= 1 {
                cell.placeholder(.boy_404, content: "暂时失联啦~")
            } else {
                cell.placeholder(.girl_door, content: "一片寂静")
            }
            
            return cell
            
        case .pointHolder:
            break
        }
        
        return UICollectionViewCell()
    }
}

// MARK: ScheduleCollectionViewLayoutDataSource

extension ScheduleFact: ScheduleCollectionViewLayoutDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout: ScheduleCollectionViewLayout, columnOfItemAtIndexPath indexPath: IndexPath) -> Int {
        data(of: indexPath).cal.curriculum.inWeek
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: ScheduleCollectionViewLayout, lineOfItemAtIndexPath indexPath: IndexPath) -> Int {
        data(of: indexPath).location
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: ScheduleCollectionViewLayout, lenthOfItemAtIndexPath indexPath: IndexPath) -> Int {
        data(of: indexPath).lenth
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: ScheduleCollectionViewLayout, numberOfSupplementaryOfKind kind: String, inSection section: Int) -> Int {
        guard let kind = UICollectionView.ElementKindSection(rawValue: kind) else { return 0 }
        switch kind {
        case .header:
            return 8
        case .leading:
            return 12
        case .placeHolder:
            if section >= mappy.datas.count { return 1 }
            return (mappy.datas[section].count > 0) ? 0 : 1
        case .pointHolder:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: ScheduleCollectionViewLayout, persentOfPointAtIndexPath indexPath: IndexPath) -> CGFloat {
        1
    }
}

// MARK: UICollectionViewDelegate
 
extension ScheduleFact: UICollectionViewDelegate { }

// MARK: UIScrollViewDelegate

extension ScheduleFact: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard let layout = scrollView.as_collectionView?.ry_layout else { return }
        layout.pageCalculation = Int(scrollView.contentOffset.x / scrollView.bounds.size.width) * layout.pageShows
        scrollViewStartPosPoint = scrollView.contentOffset
        scrollDirection = 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollDirection == 0 {
            if abs(scrollViewStartPosPoint.x - scrollView.contentOffset.x) <
                abs(scrollViewStartPosPoint.y - scrollView.contentOffset.y) {
                
                scrollDirection = 1     // Vertical Scrolling
            } else {
                scrollDirection = 2     // Horitonzal Scrolling
            }
        }
        // Update scroll position of the scrollview according to detected direction.
        if scrollDirection == 1 {
            scrollView.contentOffset = CGPoint(x: scrollViewStartPosPoint.x, y: scrollView.contentOffset.y)
        } else {
            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: scrollViewStartPosPoint.y)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate { scrollDirection = 0 }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollDirection = 0
    }
}

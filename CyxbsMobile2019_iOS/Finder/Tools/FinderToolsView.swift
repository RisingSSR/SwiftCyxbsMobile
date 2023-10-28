//
//  FinderToolsView.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/10/2.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

class FinderToolsView: UIView {

    private(set) lazy var models: [FinderToolsModel] = getFinderTools
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var collectionView: UICollectionView = {
        let frame = bounds
        let itemWidth: CGFloat = 75
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing =
            (frame.width - CGFloat(models.count) * itemWidth) / CGFloat(models.count - 1)
        layout.itemSize = CGSize(width: itemWidth, height: frame.height)
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(FinderToolsCollectionViewCell.self, forCellWithReuseIdentifier: FinderToolsCollectionViewCell.identifier)
        return collectionView
    }()
}

// MARK: data

extension FinderToolsView {
    
    var getFinderTools: [FinderToolsModel] {
        let model = FinderToolsModel(name: "更多功能", icon: "finder_tool_more", describe: "更多功能敬请期待", api_available: false, web_available: false)
        if let threeTools = CacheManager.shared.getCodable([FinderToolsModel].self, in: .threeTools) {
            return threeTools + [model]
        } else {
            if let allTools = CacheManager.shared.getCodable([FinderToolsModel].self, in: .toolsFromBundle) {
                let threeTools = Array(allTools[0 ..< 3])
                CacheManager.shared.cache(codable: threeTools, in: .threeTools)
                return threeTools + [model]
            } else {
                return []
            }
        }
    }
}

// MARK: UICollectionViewDataSource

extension FinderToolsView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let data = models[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FinderToolsCollectionViewCell.identifier, for: indexPath) as! FinderToolsCollectionViewCell
        
        cell.imageSize = CGSize(width: 40, height: 35)
        cell.spaceForMiddle = 7
        cell.setupData(title: data.name, imgName: data.icon)
        
        return cell
    }
}

// MARK: UICollectionViewDelegate

extension FinderToolsView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension FinderToolsView: UICollectionViewDelegateFlowLayout {
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return
//    }
    
}

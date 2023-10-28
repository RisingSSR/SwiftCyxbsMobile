//
//  QuickFeaturesView.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/10/21.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

class QuickFeaturesView: UIView {
    
    lazy var datas: [QuickFeaturesModel] = {
        if let cache = CacheManager.shared.getCodable([QuickFeaturesModel].self, in: .features) {
            return cache
        }
        if let fromBundle = CacheManager.shared.getCodable([QuickFeaturesModel].self, in: .toolsFromBundle) {
            CacheManager.shared.cache(codable: fromBundle, in: .features)
            return fromBundle
        }
        return []
    }() {
        didSet {
            CacheManager.shared.cache(codable: datas, in: .features)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var tableView: UITableView = {
        let tableview = UITableView(frame: bounds, style: .plain)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.dragInteractionEnabled = true
        tableview.dragDelegate = self
        tableview.dropDelegate = self
        return tableView
    }()
}

// MARK: UITableViewDataSource

extension QuickFeaturesView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}

// MARK: UITableViewDelegate

extension QuickFeaturesView: UITableViewDelegate {
    
}

// MARK: UITableViewDragDelegate

extension QuickFeaturesView: UITableViewDragDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
//        dragItem.localObject = datas[indexPath.row]
        return [dragItem]
    }
}

extension QuickFeaturesView: UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let mover = datas.remove(at: sourceIndexPath.row)
        datas.insert(mover, at: destinationIndexPath.row)
    }
}

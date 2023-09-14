//
//  ScheduleInteractionFact.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/14.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

class ScheduleInteractionFact: ScheduleFact {
    
    private(set) var collectionView: UICollectionView!
    
    override func createCollectionView() -> UICollectionView {
        let collectionView = super.createCollectionView()
        self.collectionView = collectionView
        return collectionView
    }
    
    func request(sno: String) {
        ScheduleModel.request(sno: sno) { response in
            switch response {
            case .success(let model):
                self.mappy.maping(model)
                self.collectionView.reloadData()
            case .failure(let error):
                print("error \(error)")
            }
        }
    }
}

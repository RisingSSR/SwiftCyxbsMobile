//
//  FinderBannerView.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/30.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit
import JXBanner

class FinderBannerView: UIView {
    
    var models: [FinderBannerModel] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .hex("#3852DA")
        layer.cornerRadius = 8
        clipsToBounds = true
        addSubview(banner)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var banner: JXBanner = {
        let banner = JXBanner(frame: bounds)
        banner.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        banner.dataSource = self
        banner.delegate = self
        return banner
    }()
}

// MARK: request

extension FinderBannerView {
    
    func request() {
        HttpManager.shared.magipoke_text_banner_get().ry_JSON { response in
            if case .success(let model) = response, model["status"].int == 10000 {
                if let models = model["data"].array?.map(FinderBannerModel.init(json:)) {
                    self.models = models
                    self.banner.reloadView()
                }
            }
        }
    }
}

// MARK: JXBannerDataSource

extension FinderBannerView: JXBannerDataSource {
    
    func jxBanner(numberOfItems banner: JXBannerType) -> Int {
        max(1, models.count)
    }
    
    func jxBanner(_ banner: JXBannerType) -> (JXBannerCellRegister) {
        JXBannerCellRegister(type: FinderBannerCollectionViewCell.self, reuseIdentifier: FinderBannerCollectionViewCell.identifier)
    }
    
    func jxBanner(_ banner: JXBannerType, cellForItemAt index: Int, cell: UICollectionViewCell) -> UICollectionViewCell {
        
        guard let cell = cell as? FinderBannerCollectionViewCell else { return cell }
        
        let placeholder = UIImage(named: "finder_banner_placeholder")
        
        if index >= models.count {
            cell.setImage(with: "", placeholder: placeholder)
        } else {
            let item = models[index]
            cell.setImage(with: item.picture_url, placeholder: placeholder)
        }
        
        return cell
    }
    
    func jxBanner(_ banner: JXBannerType, params: JXBannerParams) -> JXBannerParams {
        params.isAutoPlay = true
        params.timeInterval = 3
        params.cycleWay = .forward
        return params
    }
    
    func jxBanner(_ banner: JXBannerType, layoutParams: JXBannerLayoutParams) -> JXBannerLayoutParams {
        layoutParams
            .minimumScale(0)
            .maximumAngle(0)
            .itemSpacing(0)
    }
    
    func jxBanner(pageControl banner: JXBannerType, numberOfPages: Int, coverView: UIView, builder: JXBannerPageControlBuilder) -> JXBannerPageControlBuilder {
        builder
    }
}

// MARK: JXBannerDelegate

extension FinderBannerView: JXBannerDelegate {
    
    func jxBanner(_ banner: JXBannerType, didSelectItemAt index: Int) {
        
    }
}

//
//  BaseToast.swift
//  CyxbsMobile2019_iOS
//
//  Created by whitiy on 2023/11/6.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation
import UIKit

class BaseToast {
    static func showToast(message: String, viewController: UIViewController) {
        let toastLabel = UILabel()
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 12)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        toastLabel.sizeToFit()
        toastLabel.frame = CGRect(x: viewController.view.frame.size.width/2 - toastLabel.frame.size.width/2, y: viewController.view.frame.size.height-100, width: toastLabel.frame.size.width + 20, height: toastLabel.frame.size.height + 10)
        viewController.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

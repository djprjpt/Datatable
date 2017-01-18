//
//  Extensions.swift
//  Datatable
//
//  Created by Dhaval Prajapati on 10/01/17.
//  Copyright © 2017 KC. All rights reserved.
//

import UIKit

extension UIScrollView {
    func scrollToTop() {
        let desiredOffset = CGPoint(x: -contentInset.left, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
    }
}

extension CALayer {
    func singleBorder(color: UIColor, frame: CGRect) {
        let b = CALayer()
        b.frame = frame
        b.backgroundColor = color.cgColor
        self.addSublayer(b)
    }
}

extension UIView {
    func getCurrentViewController() -> UIViewController? {
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            var currentController: UIViewController! = rootController
            while( currentController.presentedViewController != nil ) {
                currentController = currentController.presentedViewController
            }
            return currentController
        }
        return nil
    }
}

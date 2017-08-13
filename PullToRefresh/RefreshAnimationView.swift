//
//  RefreshAnimationView.swift
//  PullToRefresh
//
//  Created by CP3 on 2017/8/13.
//  Copyright © 2017年 CP3. All rights reserved.
//

import Foundation
import UIKit

public protocol RefreshAnimatable {
    func startAnimating()
    func stopAnimating()
    func pullProgress(_ progress: CGFloat)
}

open class RefreshAnimationView: UIView, RefreshAnimatable {
    open func startAnimating() {
        //Do nothing
    }
    
    open func stopAnimating() {
        //Do nothing
    }
    
    open func pullProgress(_ progress: CGFloat) {
        //Do nothing
    }
}

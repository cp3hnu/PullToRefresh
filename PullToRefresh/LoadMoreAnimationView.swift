//
//  LoadMoreAnimationView.swift
//  PullToRefresh
//
//  Created by CP3 on 2017/8/13.
//  Copyright © 2017年 CP3. All rights reserved.
//

import Foundation
import UIKit

public protocol LoadMoreAnimatable {
    func startAnimating()
    func stopAnimating()
    func completeLoading(_ completion: Bool)
}

open class LoadMoreAnimationView: UIView, LoadMoreAnimatable {
    open func startAnimating() {
        //Do nothing
    }
    
    open func stopAnimating() {
        //Do nothing
    }
    
    open func completeLoading(_ completion: Bool) {
        //Do nothing
    }
}

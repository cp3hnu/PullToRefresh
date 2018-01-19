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

public protocol LoadMoreAnimatable {
    func startAnimating()
    func stopAnimating()
    func completeLoading(_ completion: Bool)
}

public typealias RefreshAnimatableView = UIView & RefreshAnimatable
public typealias LoadMoreAnimatableView = UIView & LoadMoreAnimatable

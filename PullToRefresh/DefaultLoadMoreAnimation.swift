//
//  DefaultLoadMoreAnimationView.swift
//  PullToRefresh
//
//  Created by CP3 on 16/6/18.
//  Copyright © 2016年 CP3. All rights reserved.
//

import UIKit

public class DefaultLoadMoreAnimationView: UIView {

    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    private let label = UILabel()
    private(set) var isAnimating = false
    
    public init() {
        super.init(frame: CGRect.zero)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        
        label.textColor = UIColor(red: 53/255.0, green: 53/255.0, blue: 53/255.0, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "加载更多"
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        self.addConstraint(NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "[activityIndicator]-10-[label]", options: NSLayoutFormatOptions.alignAllCenterY, metrics: nil, views: ["activityIndicator": activityIndicator, "label": label]))
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func didMoveToWindow() {
        if isAnimating {
            startAnimating()
        }
    }
}

extension DefaultLoadMoreAnimationView: LoadMoreAnimatable {
    public func startAnimating() {
        isAnimating = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        label.text = "努力加载中..."
    }
    
    public func stopAnimating() {
        isAnimating = false
        activityIndicator.stopAnimating()
        label.text = "加载更多"
    }
    
    public func completeLoading(_ completion: Bool) {
        isAnimating = false
        activityIndicator.stopAnimating()
        
        if completion {
            label.text = "已无更多数据"
        } else {
            label.text = "加载更多"
        }
    }
}

//
//  PullToRefreshView.swift
//  PullToRefresh
//
//  Created by CP3 on 16/6/18.
//  Copyright © 2016年 CP3. All rights reserved.
//

import UIKit

internal enum RefreshStatus: Int {
    case stopped
    case loading
    case pulling
}

public typealias RefreshAction = () -> Void

public class PullToRefreshView: UIView {

    static var pullHeight: CGFloat = 60
    static var loadingViewSize: CGFloat = 30
    
    var status: RefreshStatus = .stopped
    weak var scrollView: UIScrollView?
    var externalContentInset: UIEdgeInsets
    let actionHandler: RefreshAction
    let animationView: RefreshAnimatableView
    var updatingContentInset = false
    
    public init(scrollView: UIScrollView, animationView: RefreshAnimatableView, actionHandler: @escaping RefreshAction) {
        
        self.scrollView = scrollView
        self.animationView = animationView
        self.actionHandler = actionHandler
        externalContentInset = scrollView.contentInset
        
        super.init(frame: CGRect.zero)
        
        addSubview(self.animationView)
        clipsToBounds = true
        
        //backgroundColor = UIColor.greenColor()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        superview?.willMove(toSuperview: newSuperview)
        
        if let scrollView = superview as? UIScrollView {
            removeScrollViewObservers(scrollView)
        }
        
        if let scrollView = newSuperview as? UIScrollView {
            addScrollViewObservers(scrollView)
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let height = min(currentHeight(), PullToRefreshView.pullHeight)
        let minOriginY = (PullToRefreshView.pullHeight - PullToRefreshView.loadingViewSize) / 2.0
        let originY: CGFloat = max(min((height - PullToRefreshView.loadingViewSize) / 2.0, minOriginY), 0.0)
        
        animationView.frame = CGRect(x: 0, y:originY, width: bounds.width, height: 30)
    }
}

// MARK: - API
public extension PullToRefreshView {
    func beginRefresing() {
        startRefreshing()
    }
    
    func endRefresing() {
        stopRefreshing()
    }
}

// MARK: - Observer
extension PullToRefreshView {
    fileprivate func addScrollViewObservers(_ scrollView: UIScrollView) {
        scrollView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        scrollView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        scrollView.addObserver(self, forKeyPath: "frame", options: .new, context: nil)
        scrollView.addObserver(self, forKeyPath: "contentInset", options: .new, context: nil)
    }
    
    fileprivate func removeScrollViewObservers(_ scrollView: UIScrollView) {
        scrollView.removeObserver(self, forKeyPath: "contentOffset")
        scrollView.removeObserver(self, forKeyPath: "contentSize")
        scrollView.removeObserver(self, forKeyPath: "frame")
        scrollView.removeObserver(self, forKeyPath: "contentInset")
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "contentOffset" {
            if let offset = (change?[NSKeyValueChangeKey.newKey] as AnyObject).cgPointValue {
                scrollViewDidScroll(offset)
            }
            layoutSubviews()
            resetFrame()
            
        } else if keyPath == "contentSize" {
            layoutSubviews()
            resetFrame()
        } else if keyPath == "frame" {
            layoutSubviews()
            resetFrame()
        } else if keyPath == "contentInset" {
            guard let contentInset = (change?[NSKeyValueChangeKey.newKey] as AnyObject).uiEdgeInsetsValue, !updatingContentInset else { return }
            
            let loadMoreStatus = scrollView?.loadMoreStatus
            if loadMoreStatus == nil || loadMoreStatus == .stopped {
                externalContentInset = contentInset
                layoutSubviews()
                resetFrame()
            }
        }
    }
}

// MARK: - Help
private extension PullToRefreshView {
    func scrollViewDidScroll(_ contentOffset: CGPoint) {
        guard let scrollView = scrollView else { return }
        
        let actionOffset: CGFloat = -contentOffset.y - externalContentInset.top
        
        if status == .pulling && !scrollView.isDragging {
            if actionOffset >= PullToRefreshView.pullHeight {
                startRefreshing()
            } else {
                status = .stopped
            }
        } else if status == .stopped && scrollView.isDragging {
            if actionOffset > 0  {
                status = .pulling
            }
        }
        
        if status == .pulling || (status == .stopped && actionOffset > 0) {
            let progress = max(0, actionOffset/PullToRefreshView.pullHeight)
            animationView.pullProgress(progress)
        }
    }
    
    func startRefreshing() {
        var contentInset = externalContentInset
        contentInset.top += PullToRefreshView.pullHeight
        
        status = .loading
        animationView.startAnimating()
        
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.setScrollViewContentInset(contentInset)
            }, completion: { [weak self] _ in
                self?.actionHandler()
            }
        )
    }
    
    func stopRefreshing() {
        guard status != .stopped else { return }
        
        let contentInset = externalContentInset
         
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.setScrollViewContentInset(contentInset)
            }, completion: { [weak self] _ in
                self?.status = .stopped
                self?.animationView.stopAnimating()
            }
        )
    }
    
    func setScrollViewContentInset(_ contentInset: UIEdgeInsets) {
        guard let scrollView = scrollView else { return }
        
        let updating = updatingContentInset
        updatingContentInset = true
        scrollView.contentInset = contentInset
        updatingContentInset = updating
    }
    
    func currentHeight() -> CGFloat {
        guard let scrollView = scrollView else { return 0.0 }
        return max(-externalContentInset.top - scrollView.contentOffset.y, 0)
    }
    
    func resetFrame() {
        guard let scrollView = scrollView else { return }
        
        let height = min(currentHeight(), PullToRefreshView.pullHeight)
        frame = CGRect(x: 0.0, y: -height, width: scrollView.bounds.width, height: height)
    }
}

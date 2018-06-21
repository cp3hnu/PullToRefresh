//
//  LoadMoreView.swift
//  PullToRefresh
//
//  Created by CP3 on 16/6/18.
//  Copyright © 2016年 CP3. All rights reserved.
//

import UIKit

internal enum LoadMoreStatus: Int {
    case stopped
    case loading
    case completion
}

public typealias LoadMoreAction = () -> Void

public class LoadMoreView: UIView {

    static var pullHeight: CGFloat = 60

    var status: LoadMoreStatus = .stopped
    weak var scrollView: UIScrollView?
    var externalContentInset: UIEdgeInsets
    let actionHandler: LoadMoreAction
    let animationView: LoadMoreAnimatableView
    //内部更新contentInset
    var updatingContentInset = false
    //内部添加的contentInset.bottom
    var createdInsetBottom: CGFloat = 0
    
    public init(scrollView: UIScrollView, animationView: LoadMoreAnimatableView, actionHandler: @escaping LoadMoreAction) {
        self.scrollView = scrollView
        self.animationView = animationView
        self.actionHandler = actionHandler
        externalContentInset = scrollView.contentInset
        
        super.init(frame: CGRect.zero)
    
        addSubview(self.animationView)
        //backgroundColor = UIColor.redColor()
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
        
        animationView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: LoadMoreView.pullHeight)
    }
}

// MARK: - API
public extension LoadMoreView {
    func completeLoadingMore(_ noMoreData: Bool) {
        finishLoadingMore(noMoreData)
    }
}

// MARK: - Observer
extension LoadMoreView {
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
        } else if keyPath == "contentSize" {
            layoutSubviews()
            resetFrame()
        } else if keyPath == "frame" {
            layoutSubviews()
            resetFrame()
        } else if keyPath == "contentInset" {
            guard let scrollView = scrollView else { return }
            guard let contentInset = (change?[NSKeyValueChangeKey.newKey] as AnyObject).uiEdgeInsetsValue else { return }
            guard !updatingContentInset else { return }
            
            var updatedContentInset = contentInset
            updatedContentInset.bottom -= createdInsetBottom
    
            let refreshStatus = scrollView.refreshStatus
            if refreshStatus == nil || refreshStatus == .stopped {
                externalContentInset = updatedContentInset
                layoutSubviews()
                resetFrame()
            }
        }
    }
}

// MARK: - Help
private extension LoadMoreView {
    func contentHeight() -> CGFloat {
        guard let scrollView = scrollView else {
            return 0
        }
        
        let remainingHeight = scrollView.bounds.height - externalContentInset.top - externalContentInset.bottom
        return max(remainingHeight, scrollView.contentSize.height)
    }
    
    func scrollViewDidScroll(_ contentOffset: CGPoint) {
        guard let scrollView = scrollView else { return }
        
        let actionOffset = contentHeight() - scrollView.bounds.height + externalContentInset.bottom
        
        if scrollView.hasContent && contentOffset.y > actionOffset {
            startLoadingMore()
        }
    }
    
    func startLoadingMore() {
        guard status == .stopped else { return }

        status = .loading
        animationView.startAnimating()
        
        var contentInset = externalContentInset
        contentInset.bottom += bottomInset()
        
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.setScrollViewContentInset(contentInset)
            }, completion: { [weak self] finished in
                self?.actionHandler()
            }
        )
    }
    
    func stopLoadingMore() {
        guard status != .stopped else { return }
        
        animationView.stopAnimating()
        let contentInset = externalContentInset
        
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.setScrollViewContentInset(contentInset)
            }, completion: { [weak self] _ in
                self?.status = .stopped
            }
        )
    }
    
    func finishLoadingMore(_ noMoreData: Bool) {
        if noMoreData {
            status = .completion
            animationView.completeLoading(true)
            
            var contentInset = externalContentInset
            let isShowing = contentSizePassFrame()
            self.isHidden = !isShowing
            if isShowing {
                contentInset.bottom += LoadMoreView.pullHeight
            }
            setScrollViewContentInset(contentInset)
        } else {
            isHidden = false
            stopLoadingMore()
        }
    }
    
    func setScrollViewContentInset(_ contentInset: UIEdgeInsets) {
        guard let scrollView = scrollView else { return }
        
        let updating = updatingContentInset
        updatingContentInset = true
        scrollView.contentInset = contentInset
        createdInsetBottom = contentInset.bottom - externalContentInset.bottom
        updatingContentInset = updating
    }
    
    func resetFrame() {
        guard let scrollView = scrollView else { return }
        
        let height = UIScreen.main.bounds.height
        frame = CGRect(x: 0, y: contentHeight(), width: scrollView.bounds.width, height: height)
        
        // print("resetFrame", contentHeight(), externalContentInset.bottom, frame)

        // 完全没有数据或者没有更多的数据，且contentSize没有超过frame，隐藏load more
        if !scrollView.hasContent || status == .completion && !contentSizePassFrame() {
            isHidden = true
            setScrollViewContentInset(externalContentInset)
        } else {
            isHidden = false
            var contentInset = externalContentInset
            contentInset.bottom += LoadMoreView.pullHeight
            setScrollViewContentInset(contentInset)
        }
    }
    
    func bottomInset() -> CGFloat {
        guard let scrollView = scrollView else {
            return LoadMoreView.pullHeight
        }
        
        let remainingHeight = scrollView.bounds.height - externalContentInset.top - externalContentInset.bottom
        return max(0, remainingHeight - scrollView.contentSize.height) + LoadMoreView.pullHeight
    }
    
    func contentSizePassFrame() -> Bool {
        guard let scrollView = scrollView else {
            return false
        }
        
        let remainingHeight = scrollView.bounds.height - externalContentInset.top - externalContentInset.bottom
        return scrollView.contentSize.height > remainingHeight
    }
}

//
//  UIScrollView+YPPullToRefresh.swift
//  PullToRefresh
//
//  Created by CP3 on 16/6/18.
//  Copyright © 2016年 CP3. All rights reserved.
//

import UIKit

// MARK: - Vars
private extension UIScrollView {
    struct AssociatedKeys {
        static var pullToRefreshView = "pullToRefreshView"
        static var loadMoreView = "loadMoreView"
    }
    
    var pullToRefreshView: PullToRefreshView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.pullToRefreshView) as? PullToRefreshView
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.pullToRefreshView, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var loadMoreView: LoadMoreView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.loadMoreView) as? LoadMoreView
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.loadMoreView, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

// MARK: - Status
extension UIScrollView {
    var refreshStatus: RefreshStatus? {
        return pullToRefreshView?.status
    }
    
    var loadMoreStatus: LoadMoreStatus? {
        return loadMoreView?.status
    }
}

// MARK: - API
extension UIScrollView {
    
    // MARK: - PullToRefresh
    /**
     添加下拉刷新功能
     
     - parameter animationView: 动画视图
     - parameter actionHandler: 回调方法
     */
    public func addPullToRefresh(_ animationView: RefreshAnimationView = DefaultRefreshAnimationView(), actionHandler: @escaping RefreshAction) {
        pullToRefreshView = PullToRefreshView(scrollView: self, animationView: animationView, actionHandler: actionHandler)
        addSubview(pullToRefreshView!)
        sendSubview(toBack: pullToRefreshView!)
    }
    
    /**
     强制开始下拉刷新
     */
    public func beginRefreshing() {
        pullToRefreshView?.beginRefresing()
    }
    
    /**
     结束下拉刷新
     */
    public func endRefreshing() {
        pullToRefreshView?.endRefresing()
    }
    
    // MARK: - LoadMore
    /**
     添加上拉加载更多功能
     
     - parameter animationView: 动画视图
     - parameter actionHandler: 回调方法
     */
    public func addLoadMore(_ animationView: LoadMoreAnimationView = DefaultLoadMoreAnimationView(), actionHandler: @escaping LoadMoreAction) {
        loadMoreView = LoadMoreView(scrollView: self, animationView: animationView, actionHandler: actionHandler)
        addSubview(loadMoreView!)
    }
    
    /**
     完成加载更多，并设置是否还有更多的数据可供加载
     
     - parameter completion: true：已经没有更多的数据，false：还有更多的数据
     */
    public func completeLoadingMore(_ completion: Bool) {
        loadMoreView?.completeLoadingMore(completion)
    }
    
    /**
     只是完成单次的加载更多，优先调用*completeLoadingMore*
     */
    public func endLoadingMore() {
        loadMoreView?.endLoadingMore()
    }
}


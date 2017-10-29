//
//  UIScrollView+YPPullToRefresh.swift
//  PullToRefresh
//
//  Created by CP3 on 16/6/18.
//  Copyright © 2016年 CP3. All rights reserved.
//

import UIKit

// MARK: - Vars
extension UIScrollView {
    struct AssociatedKeys {
        static var pullToRefreshView = "pullToRefreshView"
        static var loadMoreView = "loadMoreView"
        static var hasContent = "hasContent"
    }
    
    fileprivate var pullToRefreshView: PullToRefreshView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.pullToRefreshView) as? PullToRefreshView
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.pullToRefreshView, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate var loadMoreView: LoadMoreView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.loadMoreView) as? LoadMoreView
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.loadMoreView, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // 是否允许显示加载更多功能(场景：没有数据时，上拉不显示加载更多，本来是判断ScrollView的contentHeight > 1，但是发现当有headerView的时候，这种判断不成立，需要手动设置一下）
    public var hasContent: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.hasContent) as? Bool ?? false
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.hasContent, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
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
     
     - parameter noMoreData: true：已经没有更多的数据，false：还有更多的数据
     */
    public func completeLoadingMore(_ noMoreData: Bool) {
        loadMoreView?.completeLoadingMore(noMoreData)
    }
    
    /**
     只是完成单次的加载更多，优先调用*completeLoadingMore*
     */
    func endLoadingMore() {
        loadMoreView?.endLoadingMore()
    }
}


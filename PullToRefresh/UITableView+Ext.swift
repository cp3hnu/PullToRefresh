//
//  UITableView+Ext.swift
//  PullToRefresh
//
//  Created by CP3 on 2017/8/13.
//  Copyright © 2017年 CP3. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    /**
     接口请求成功，在这里调用了reloadData()，controller里不需要再调用了reloadData()
     
     - parameter isFirstPage: 是否是第一页
     - parameter dataCount:   请求到数据的数量
     - parameter pageSize:    分页大小
     - parameter hasContent:  tableView有没有内容，没有内容禁止加载更多
     */
    public func requestSuccess(isFirstPage: Bool, dataCount: Int, pageSize: Int, hasContent: Bool) {
        reloadData()
        if isFirstPage {
            endRefreshing()
        }
        
        self.hasContent = hasContent
        completeLoadingMore(dataCount < pageSize)
    }
    
    /**
     接口请求失败
     
     - parameter isFirstPage: 是否是第一页
     - parameter hasContent:  tableView有没有内容，没有内容禁止加载更多
     */
    public func requestError(isFirstPage: Bool, hasContent: Bool) {
        if isFirstPage {
            endRefreshing()
        } else {
            completeLoadingMore(false)
        }
        
        self.hasContent = hasContent
    }
}

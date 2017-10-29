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
     
     - parameter pageNO:    分页
     - parameter dataCount: 请求到数据的数量
     - parameter pageSize:  分页大小
     - parameter hasContent:  tableView有没有内容，没有内容禁止加载更多
     */
    public func requestSuccess(pageNO: Int, dataCount: Int, pageSize: Int, hasContent: Bool) {
        reloadData()
        if pageNO == 1 {
            endRefreshing()
        }
        
        self.hasContent = hasContent
        completeLoadingMore(dataCount < pageSize)
    }
    
    /**
     接口请求失败
     
     - parameter pageNO: 分页
     - parameter hasContent:  tableView有没有内容，没有内容禁止加载更多
     */
    public func requestError(pageNO: Int, hasContent: Bool) {
        if pageNO == 1 {
            endRefreshing()
        } else {
            completeLoadingMore(false)
        }
        
        self.hasContent = hasContent
    }
}

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
     */
    public func requestSuccess(pageNO: Int?, dataCount: Int?, pageSize: Int) {
        reloadData()
        
        if pageNO == 1 {
            endRefreshing()
        }
        
        completeLoadingMore((dataCount ?? 0) < pageSize)
    }
    
    /**
     接口请求失败
     
     - parameter pageNO: 分页
     */
    public func requestError(pageNO: Int?) {
        if pageNO == 1 {
            endRefreshing()
        } else {
            completeLoadingMore(false)
        }
    }
}

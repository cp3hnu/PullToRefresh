//
//  ViewController.swift
//  Example
//
//  Created by CP3 on 2018/7/26.
//  Copyright © 2018年 CP3. All rights reserved.
//

import UIKit
import PullToRefresh

class ViewController: UIViewController {
    
    var count = 0
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Example"
        
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 44
        tableView.separatorStyle = .singleLine
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.hasContent = false
        
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        tableView.addPullToRefresh {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
                self.count = 10
                self.tableView.reloadData()
                self.tableView.requestSuccess(isFirstPage: true, dataCount: 10, pageSize: 10, hasContent: true)
            }
        }
        
        tableView.addLoadMore { [unowned self] in
           self.simulate()
        }
    }
    
    func simulate() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.count += 10
            self.tableView.reloadData()
            self.tableView.completeLoadingMore(self.count >= 40)
        }
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // print("offset = \(scrollView.contentOffset.y)")
    }
}

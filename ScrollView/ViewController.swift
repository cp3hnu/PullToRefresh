//
//  ViewController.swift
//  ScrollView
//
//  Created by CP3 on 2018/7/26.
//  Copyright © 2018年 CP3. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.blue
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        let redView = UIView()
        redView.backgroundColor = UIColor.red
        redView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(redView)
        
        redView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        redView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        redView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        redView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        redView.heightAnchor.constraint(equalToConstant: 1000).isActive = true
        redView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        //scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("offset = \(scrollView.contentOffset.y)")
    }
}







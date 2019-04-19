//
//  VisitorTableViewController.swift
//  HM微博
//
//  Created by hongmei on 2019/4/19.
//  Copyright © 2019年 itheima. All rights reserved.
//

import UIKit

class VisitorTableViewController: UITableViewController {
    
    //用户登录标记
    private var userLogon = false
    //访客视图
    var visitorView:VisitorView?
    override func loadView() {
        //根据用户登录情况，决定显示的根视图
        userLogon ? super.loadView() : setupVisitorView()
        
    }
    
    //设置访客视图
    private func setupVisitorView() {
        //替换根视图
        //view = VisitorView()
        //view.backgroundColor = UIColor.white
        visitorView = VisitorView()
        view = visitorView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

}

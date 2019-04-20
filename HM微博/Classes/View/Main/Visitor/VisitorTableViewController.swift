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
    var userLogon = UserAccountViewModel.sharedUserAccount.userLogon
    //访客视图
    var visitorView:VisitorView?
    override func loadView() {
        //根据用户登录情况，决定显示的根视图
        userLogon ? super.loadView() : setupVisitorView()
        
    }
    
    //设置访客视图
     func setupVisitorView() {
        //替换根视图
        //view = VisitorView()
        //view.backgroundColor = UIColor.white
        visitorView = VisitorView()
        view = visitorView
        
        //添加监听方法
        visitorView?.registerButton.addTarget(self, action:#selector(VisitorTableViewController.visitorViewDidRegister), for: UIControl.Event.touchUpInside)
        visitorView?.loginButton.addTarget(self, action: #selector(VisitorTableViewController.visitorViewDidLogin), for: UIControl.Event.touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
}

//访客视图监听方法
   extension VisitorTableViewController{
    
    @objc func visitorViewDidRegister() {
        print("注册")
    }
    @objc func visitorViewDidLogin() {
        let vc = OAuthViewController()
        let nav = UINavigationController(rootViewController: vc)
        present(nav,animated: true,completion: nil)
    }
    
    
}

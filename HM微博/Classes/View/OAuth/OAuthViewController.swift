//
//  OAuthViewController.swift
//  HM微博
//
//  Created by hongmei on 2019/4/20.
//  Copyright © 2019年 itheima. All rights reserved.
//

import UIKit

class OAuthViewController: UIViewController {
    private lazy var webView = UIWebView()
    //监听方法
    @objc private func close() {
        dismiss(animated: true, completion: nil)
        
    }
    override func loadView() {
        view = webView
        //设置导航栏
        title = "登录新浪微博"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(OAuthViewController.close))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //加载页面
        self.webView.loadRequest(NSURLRequest(url:NetworkTools.sharedTools.OAuthURL as URL) as URLRequest)

    }
    

   

}

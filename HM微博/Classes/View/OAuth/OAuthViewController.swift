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
        //设置代理
        webView.delegate = self
        //设置导航栏
        title = "登录新浪微博"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(OAuthViewController.close))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", style:.plain, target: self, action: #selector(OAuthViewController.autoFill))
    }
    
    //自动填充用户名和密码
    @objc private func autoFill() {
        let js = "document.getElementById('userId').value = '350666080@qq.com';" + "document.getElementById('passwd').value = '';"
        
        //让webView执行js
        webView.stringByEvaluatingJavaScript(from: js)
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //加载页面
        self.webView.loadRequest(NSURLRequest(url:NetworkTools.sharedTools.OAuthURL as URL) as URLRequest)

    }
}

//- UIWebViewDelegate
extension OAuthViewController: UIWebViewDelegate {
    // 将要加载请求的代理方法
    /// - parameter webView:        webView
    /// - parameter request:        将要加载的请求
    /// - parameter navigationType: 页面跳转的方式
    /// - returns: 返回 false 不加载，返回 true 继续加载
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool{
        //目标 如果是百度 就不加载请求
        guard let url = request.url,url.host == "www.baidu.com" else {
            return true
        }
        //从URL中提取code 是否存在
        guard let query = url.query, query.hasPrefix("code=") else {
            print("取消授权")
            return false
        }
        //从query字符串提取code 后面的授权码
        let code = query.substring(from: "code=".endIndex)
        //print("授权码是" + code)
        
        //加载 accessToke
        UserAccountViewModel.sharedUserAccount.loadAccessToken(code: code){ (isSuccessed) -> () in
            //finished的完整代码
            //如果失败，直接返回
            if !isSuccessed {
                return
            } else {
                print("成功了")
                //用户登录成功 则退出当前控制器，并发送根视图
                self.dismiss(animated: false, completion: {
                    NotificationCenter.default.post (name: NSNotification.Name(rawValue: WBSwitchRootViewControllerNotification), object: "welcome")
                    
                })
                
            }
           
    
            
        }
//        NetworkTools.sharedTools.loadAccessToken(code: code) {
//            (result,error) -> () in
//            //判断错误
//            if error != nil {
//                print("出错了")
//                return
//            }
//            //输出结果
//            //print(result)
//
//            let account = UserAccount(dict: result as! [String:AnyObject])
//            //print(account)
//
//            self.loadUserInfo(account: account)
//        }
        return false
    }
    
    private func loadUserInfo(account:UserAccount){
        NetworkTools.sharedTools.loadUserInfo(uid: account.uid!) { (result, error) in
            if error != nil {
                print("加载用户出错了")
                return
            }else{
                print("加载用户成功了了")
                guard let dict = result as? [String:AnyObject] else {
                    
                    print("格式错误")
                    
                    return
                }

                //将用户信息保存
                account.screen_name = dict["screen_name"] as? String
                account.avatar_large = dict["avatar_large"] as? String
                //print(account)
                
            }
        }
    }
    
    

}

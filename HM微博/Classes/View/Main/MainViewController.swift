//
//  MainViewController.swift
//  HM微博
//
//  Created by hongmei on 2019/4/18.
//  Copyright © 2019年 itheima. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    //蓝加载控件
    private lazy var composedButton: UIButton = UIButton(imageName: "tabbar_compose_icon_add", backImageName: "babbat_compose_button")

    override func viewDidLoad() {
        super.viewDidLoad()
        addChildViewControllers()
        setupComposedButton()
        
        NetworkTools.sharedTools.request(method: HMRequestMethod.POST, URLString: "http://httpbin.org/post", parameters: ["name" : "zhangsan" as AnyObject,"age" : 18 as AnyObject]){(result,error)->() in
           // print("\(result)")
            
        }
        
        //NetworkTools.sharedTools.request(URLString: "http://www.weather.com.cn/data/sk/101010100.html", parameters: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        //会创建 tabBar中所有控制器对应的按钮
        super.viewWillAppear(animated)
        //将撰写按钮移到最前面
        tabBar.bringSubviewToFront(composedButton)
    }
    

    

}
//设置界面
extension MainViewController{
    //添加所有控制器
    private func addChildViewControllers() {
        //设置tintColor-渲染颜色
        tabBar.tintColor = UIColor.orange
        addChildViewController(vc:HomeTableViewController(), title: "首页", imageName: "tabbar_home")
        addChildViewController(vc: MessageTableViewController(), title: "消息", imageName: "tabbar_message_center")
        //添加空视图控制器
        addChild(UIViewController())
        addChildViewController(vc: DiscoverTableViewController(), title: "发现", imageName: "tabbar_discover")
        addChildViewController(vc: ProfileTableViewController(), title: "我", imageName: "tabbar_profile")
        
        
    }
   //添加控制器
    private func addChildViewController(vc:UIViewController,title:String,imageName:String){
        //设置标题
        vc.title = title
        //设置图像
        vc.tabBarItem.image = UIImage(named: imageName)
        //设置导航器
        let nav = UINavigationController(rootViewController: vc)
        addChild(nav)
    }
    
    //设置撰写按钮
    private func setupComposedButton() {
        //添加按钮
        tabBar.addSubview(composedButton)
        //调整按钮
        let count = children.count
        //让按钮宽一点点，能够解决手指触摸的容差问题
        let w = tabBar.bounds.width / CGFloat(count) - 1
        composedButton.frame = CGRect(x: w*2, y: 0, width: w, height: tabBar.bounds.height)
        
        //添加监听方法
        composedButton.addTarget(self, action: #selector(MainViewController.clickComposedButton), for: .touchUpInside)
    }
    //点击撰写按钮
    @objc func clickComposedButton() {
        print("点我")
    }
    
    
    
    
}

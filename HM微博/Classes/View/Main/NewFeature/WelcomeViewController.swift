//
//  WelcomeViewController.swift
//  HM微博
//
//  Created by hongmei on 2019/4/21.
//  Copyright © 2019年 itheima. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {
    
    override func loadView() {
        //直接使用背景图像作为根视图，不用关心图像的缩放问题
        view = backImageView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //异步加载用户头像
         iconView.setImageWith(UserAccountViewModel.sharedUserAccount.avatarUrl as URL, placeholderImage: UIImage(named: "avatar_default_big"))
        setupUI()

    }
    
    //懒加载控件
    //背景图片
    private lazy var backImageView: UIImageView = UIImageView(imageName:"ad_background")
    //欢迎label
    private lazy var welcomeLabel: UILabel = UILabel(title: "欢迎归来", fontSize: 18)
    //头像
    private lazy var iconView:UIImageView = {
        let iv = UIImageView(imageName:"avatar_default_big")
        //设置圆角
        iv.layer.cornerRadius = 45
        iv.layer.masksToBounds = true
        return iv
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //更新约束，改变位置
        
        iconView.snp_updateConstraints { (make) ->Void in
            make.bottom.equalTo(view.snp_bottom).offset(-view.bounds.height + 200)
        }
        
        //动画
        //透明度
        welcomeLabel.alpha = 0
        UIView.animate(withDuration: 1.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: [], animations: {
            //自动布局动画
            self.view.layoutIfNeeded()
        }) { (_) in
            
            UIView.animate(withDuration: 0.8, animations: {
                self.welcomeLabel.alpha = 1
            }, completion: { (_) in
                //发送通知
                NotificationCenter.default.post (name: NSNotification.Name(rawValue: WBSwitchRootViewControllerNotification), object: nil)
                
            })
        }
    }
    
}

extension WelcomeViewController{
    private func setupUI(){
        //添加控件
        view.addSubview(iconView)
        view.addSubview(welcomeLabel)
        //自动布局
        iconView.snp_makeConstraints { (make) ->Void in
            make.centerX.equalTo(view.snp_centerX)
            make.bottom.equalTo(view.snp_bottom).offset(-200)
            make.width.equalTo(90)
            make.height.equalTo(90)
        }
        
        welcomeLabel.snp_makeConstraints { (make) ->Void in
            make.centerX.equalTo(iconView.snp_centerX)
            make.top.equalTo(iconView.snp_bottom).offset(16)
        }
        
        
    }
    
}

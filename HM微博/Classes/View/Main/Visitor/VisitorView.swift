//
//  VisitorView.swift
//  HM微博
//
//  Created by hongmei on 2019/4/19.
//  Copyright © 2019年 itheima. All rights reserved.
//

import UIKit
import SnapKit

class VisitorView: UIView {
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        setupUI()
    }
    
    //懒加载控件
    ////使用image：构造函数的imageView默认就是image的大小
    //图标
    private lazy var iconView:UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
    //房子
    private lazy var homeIconView:UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
    //遮罩图像
    private lazy var maskIconView:UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
    //消息文字
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "关注一些人，回这里看看有什么惊喜"
        //界面设置上，避免使用纯黑色
        //设置label文字颜色
        label.textColor = UIColor.darkGray
        //设置label字体大小
        label.font = UIFont.systemFont(ofSize: 14)
        //label文字不限制行数
        label.numberOfLines = 0
        //设置文字的对齐方式
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    //注册按钮
    public lazy var registerButton:UIButton = {
        let button = UIButton()
        //设置普通状态下按钮文字
        button.setTitle("注册", for: .normal)
        //设置普通状态下按钮文字颜色
        button.setTitleColor(UIColor.orange, for: .normal)
        //设置普通状态下按钮背景颜色
        button.setBackgroundImage(UIImage(named: "common_button_white_disable"), for:.normal )
        return button
    }()
    //登录按钮
    public lazy var loginButton:UIButton = {
        let button = UIButton()
        button.setTitle("登录", for: .normal)
        button.setTitleColor(UIColor.orange, for: .normal)
        button.setBackgroundImage(UIImage(named: "common_button_white_disable"), for: .normal)
        return button
    }()
    
    //开启首页转轮动画
    private func startAnim() {
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2 * M_PI
        //让它不停地旋转
        anim.repeatCount = MAXFLOAT
        //旋转一周的时长
        anim.duration = 20
        anim.isRemovedOnCompletion = false
        //添加到图层
        iconView.layer.add(anim,forKey: nil)
        
    }
    
    
    
    
   

}

extension VisitorView{
    //设置界面
    private func setupUI() {
        addSubview(iconView)
        addSubview(maskIconView)
        addSubview(homeIconView)
        addSubview(messageLabel)
        addSubview(registerButton)
        addSubview(loginButton)
        
        //设置自动布局
        //图标
        iconView.snp_makeConstraints { (make) ->Void in
            make.centerX.equalTo(self.snp_centerX)
            make.centerY.equalTo(self.snp_centerY).offset(-60)
        }
        //房子
        homeIconView.snp_remakeConstraints { (make) ->Void in
            make.center.equalTo(iconView.snp_center)
        }
        //消息文字
        messageLabel.snp_makeConstraints { (make) ->Void in
            make.centerX.equalTo(iconView.snp_centerX)
            make.top.equalTo(iconView.snp_bottom).offset(16)
            make.width.equalTo(224)
            make.height.equalTo(36)
        }
        //注册按钮
        registerButton.snp_makeConstraints { (make) ->Void in
            make.left.equalTo(messageLabel.snp_left)
            make.top.equalTo(messageLabel.snp_bottom).offset(16)
            make.width.equalTo(100)
            make.height.equalTo(36)
        }
        
        //登录按钮
        loginButton.snp_makeConstraints { (make) ->Void in
            make.right.equalTo(messageLabel.snp_right)
            make.top.equalTo(registerButton.snp_top)
            make.width.equalTo(registerButton.snp_width)
            make.height.equalTo(registerButton.snp_height)
        }
        //遮照图像
        maskIconView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.snp_top)
            make.left.equalTo(self.snp_left)
            make.right.equalTo(self.snp_right)
            make.bottom.equalTo(registerButton.snp_bottom)
        }
        
        //设置背景颜色
        backgroundColor = UIColor(white: 237.0/255.0, alpha: 1.0)
        
    }
    
    //设置视图信息的方法
    func setupInfo(imageName:String?,title:String) {
        //设置消息label的文字
        messageLabel.text = title
        //如果图片名称为nil,说明是首页，直接返回
        guard let imgName = imageName else {
            //播放动画
            startAnim()
            return
        }
        //隐藏小房子
        homeIconView.isHidden = true
        iconView.image = UIImage(named: imgName)
        //将遮罩图像移动到底层
        sendSubviewToBack(maskIconView)
        
    }
    
    
}

//
//  NewFeatureCell.swift
//  HM微博
//
//  Created by hongmei on 2019/4/21.
//  Copyright © 2019年 itheima. All rights reserved.
//

import UIKit

class NewFeatureCell: UICollectionViewCell {
    //frame的大小是layout.itemSize指定的
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        //添加控件
        addSubview(iconView)
        //指定位置
        iconView.frame = bounds
        addSubview(startButton)
        
        startButton.snp_makeConstraints { (make) ->Void in
            make.centerX.equalTo(self.snp_centerX)
            make.bottom.equalTo(self.snp_bottom).multipliedBy(0.7)
        }
        
        //监听方法
        startButton.addTarget(self, action: #selector(NewFeatureCell.clickStartButton), for: .touchUpInside)
        //将startButton设置为隐藏按钮
        startButton.isHidden = true
 
        
    }
    
    //单机开始体验按钮
    @objc private func clickStartButton() {
        NotificationCenter.default.post (name: NSNotification.Name(rawValue: WBSwitchRootViewControllerNotification), object: nil)
        
    }
    
    
    //懒加载控件
    //图像
    public lazy var iconView:UIImageView = UIImageView()
    //图像属性
    public var imageIndex:Int = 0 {
        
        
        didSet {
            //将startButton设置为隐藏状态
            startButton.isHidden = true
            iconView.image = UIImage(named: "new_feature_\(imageIndex + 1)")
        }
        
    }
    //开始体验按钮
    public lazy var startButton: UIButton = UIButton(title: "开始体验", color:UIColor.white, backImageName: "new_feature_finish_button")
    
    //显示按钮动画
    public func showButtonAnim() {
        
        //将startButton设置为显性按钮
        startButton.isHidden = false
        startButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        startButton.isUserInteractionEnabled = false
        UIView.animate(withDuration: 1.6,     // 动画时长
            delay: 0,                           // 延时时间
            usingSpringWithDamping: 0.6,    // 弹力系数，0~1，越小越弹
            initialSpringVelocity: 10,      // 初始速度，模拟重力加速度
            options: [],                       // 动画选项
            animations: { () -> Void in
                self.startButton.transform = CGAffineTransform.identity
        }) { (_) -> Void in
            self.startButton.isUserInteractionEnabled = true
        }
    }
    

    
    
    
}

//
//  UIButton+Extension.swift
//  HM微博
//
//  Created by hongmei on 2019/4/18.
//  Copyright © 2019年 itheima. All rights reserved.
//

import UIKit
extension UIButton {
    //便利构造函数
    convenience init(imageName:String,backImageName:String?) {
        
        self.init()
        //设置按钮图像
        setImage(UIImage(named: imageName), for: .normal)
        setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        //设置按钮背景图像
        if let backImageName = backImageName {
            setBackgroundImage(UIImage(named: backImageName), for: .normal)
            setBackgroundImage(UIImage(named: backImageName + "_highlighted"), for: .highlighted)
        }
        //会根据图片的大小调整尺寸
        sizeToFit()
    }
    
    convenience init(title:String,color:UIColor,backImageName:String)
    {
        self.init()
        setTitle(title, for: .normal)
        setTitleColor(color, for: .normal)
        setBackgroundImage(UIImage(named:backImageName), for: .normal)
        sizeToFit()
    }
    convenience init(title:String,fontSize:CGFloat,color:UIColor,imageName:String?,backColor: UIColor? = nil)
    {
        self.init()
        
        setTitle(title, for: .normal)
        setTitleColor(color, for: .normal)
        if let imageName = imageName {
            setImage(UIImage(named: imageName), for: .normal)
        }
        
        // 设置背景颜色
        backgroundColor = backColor
    
        titleLabel?.font=UIFont.systemFont(ofSize: fontSize)
        sizeToFit()
        
    }
    
    
    
}


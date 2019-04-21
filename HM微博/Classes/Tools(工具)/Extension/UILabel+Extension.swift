//
//  UILabel+Extension.swift
//  HM微博
//
//  Created by hongmei on 2019/4/21.
//  Copyright © 2019年 itheima. All rights reserved.
//

import UIKit
extension UILabel {
    //便利构造函数
    convenience init(title:String,fontSize: CGFloat = 14,color:UIColor = UIColor.darkGray){
        self.init()
        text = title
        textColor = color
        font = UIFont.systemFont(ofSize:fontSize)
        //换行
        numberOfLines = 0
        textAlignment = NSTextAlignment.center
        
    }
    
}

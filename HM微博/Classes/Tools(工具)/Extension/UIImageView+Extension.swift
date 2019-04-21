//
//  UIImageView+Extension.swift
//  HM微博
//
//  Created by hongmei on 2019/4/21.
//  Copyright © 2019年 itheima. All rights reserved.
//

import UIKit
extension UIImageView {
    //便利构造函数
    convenience init(imageName:String) {
        self.init(image:UIImage(named: imageName))
    }
    
}

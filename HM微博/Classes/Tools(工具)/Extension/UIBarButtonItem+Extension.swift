//
//  UIBarButtonItem+Extension.swift
//  HM微博
//
//  Created by hongmei on 2019/4/29.
//  Copyright © 2019年 itheima. All rights reserved.
//

import Foundation
import UIKit
extension UIBarButtonItem {
    /// 便利构造函数
    ///
    /// - parameter imageName:  图像名
    /// - parameter target:     监听对象
    /// - parameter actionName: 监听图像名
    ///
    /// - returns: UIBarButtonItem
    convenience init(imageName:String,target:AnyObject?,actionName:String?) {
        let button = UIButton(imageName: imageName, backImageName: nil)
        
        // 判断 actionName
        // 判断 actionName
        if let actionName = actionName {
            button.addTarget(target, action: Selector(actionName), for: .touchUpInside)
        }
        
        self.init(customView: button)        
    }
}

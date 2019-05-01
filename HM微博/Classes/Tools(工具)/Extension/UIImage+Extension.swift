//
//  UIImage+Extension.swift
//  SelectPhotos
//
//  Created by hongmei on 2019/5/1.
//  Copyright © 2019年 itheima. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    /// 将图像缩放到指定`宽度`
    ///
    /// - parameter width: 目标宽度
    ///
    /// - returns: 如果给定的图片宽度小于指定宽度，直接返回
    func scaleToWith(width:CGFloat) -> UIImage {
        //判断宽度
        if width > size.width {
            return self
        }
        
        //计算比例
        let height = size.height * width / size.width
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        //使用核心绘图绘制新的图像
        //开启上下文
        UIGraphicsBeginImageContext(rect.size)
        //绘图 在指定区域拉伸绘制
        self.draw(in: rect)
        //取结果
        let result = UIGraphicsGetImageFromCurrentImageContext()
        //关闭上下文
        UIGraphicsEndImageContext()
        //返回结果
        return result!
        
    }
    
}

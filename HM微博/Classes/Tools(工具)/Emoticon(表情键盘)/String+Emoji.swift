//
//  String+Emoji.swift
//  表情键盘01
//
//  Created by yangyingwei on 2019/4/14.
//  Copyright © 2019 yangyingwei. All rights reserved.
//
import UIKit
extension String {
    
    //返回当前字符串中 16 进制对应 的 emoji 字符串
    var emoji: String {
       
        // 文本扫描器－扫描指定格式的字符串
        let scanner = Scanner(string: (self))
        // unicode 的值
        var value: UInt32 = 0
        Scanner(string: self).scanHexInt32(&value)
        
        // 转换 unicode `字符`
        let chr = Character(UnicodeScalar(value)!)
        
        // 转换成字符串
        return "\(chr)"
    }
    
}

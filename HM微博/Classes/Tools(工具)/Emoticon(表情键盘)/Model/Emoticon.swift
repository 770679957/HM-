//
//  Emoticon.swift
//  表情键盘01
//
//  Created by yangyingwei on 2019/4/14.
//  Copyright © 2019 yangyingwei. All rights reserved.
//

import UIKit

class Emoticon: NSObject {
    
    // 表情文字
    @objc var chs:String?
    
    //表情图片名
    @objc var png:String?
    
    // emoji 的字符串
    @objc var emoji: String?
    
    //emoji 编码
    @objc var code:String?{
        didSet {
            emoji = code?.emoji
        }
    }
    
    // 是否删除按钮标记
    @objc var isRemoved = false
    init(isRemoved: Bool) {
        self.isRemoved = isRemoved
        super.init()
    }

    // 是否空白按钮标记
    @objc var isEmpty = false
    // MARK: - 构造函数
    init(isEmpty: Bool) {
        self.isEmpty = isEmpty
        super.init()
    }
    
 
    // 完整的路径
    @objc var imagePath: String {
        
        // 判断是否有图片
        if png == nil {
            //print("Emoticon_png 为空")
            return ""
        }else{
            //print("Bundle.main.bundlePath + /Emoticons.bundle/:"+Bundle.main.bundlePath + "/Emoticons.bundle/")
        }
        
        // 拼接完整路径
        return Bundle.main.bundlePath + "/Emoticons.bundle/" + png!
    }
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    override var description: String {
        let keys = ["chs", "png", "code", "isRemoved"]
        
        return dictionaryWithValues(forKeys: keys).description
    }

}

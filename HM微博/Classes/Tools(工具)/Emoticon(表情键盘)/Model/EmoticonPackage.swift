//
//  EmoticonPackage.swift
//  01-表情键盘
//
//  Created by male on 15/10/23.
//  Copyright © 2015年 itheima. All rights reserved.
//

import UIKit

// MARK: - 表情包模型
class EmoticonPackage: NSObject {

    /// 表情包所在路径
    @objc var id: String?
    /// 表情包的名称，显示在 toolbar 中
    @objc var group_name_cn: String?
    /// 表情数组 - 能够保证，在使用的时候，数组已经存在，可以直接追加数据
    @objc lazy var emoticons = [Emoticon]()
    
    init(dict: [String: AnyObject]) {
        super.init()
        
        // 不会按照顺序调用字典中的 key，不能保证生成 emoticons 数组的时候 id 已经被设置
        // setValuesForKeysWithDictionary(dict)
        
        id = dict["id"] as? String
        //print("yyw001_EmoticonPackage_id:"+id!)
        group_name_cn = dict["group_name_cn"] as? String

        
        if let array = dict["emoticons"] as? [[String:AnyObject]]{
            //遍历数组
            var index = 0
            for var d in array{
                if let png = d["png"] as? String , let dir = id{
                    d["png"] = dir + "/" + png as AnyObject
                }
 
                let emoticon = Emoticon(dict:d)
                //print("emoticon.png:"+emoticon.png!)
                emoticons.append(emoticon)
               // print("111emoticons.count:"+String(emoticons.count))
                
                //每隔20次循环添加一个“删除”按钮
                index += 1
                if index == 20 {
                    emoticons.append(Emoticon(isRemoved: true))
                    index = 0
                }
                
                //print("333emoticons.count:"+String(emoticons.count))
                
            }
        }
        
        //print("emoticons.count:"+String(emoticons.count))
        
        // 2. 添加空白按钮
        appendEmptyEmoticon()
 
    }
    
    // 在表情数组末尾，添加空白表情
    private func appendEmptyEmoticon() {
        
       // print("444emoticons.count:"+String(self.emoticons.count))
        
        // 取表情的余数
        let count = emoticons.count % 21
        
        // 只有最近和默认需要添加空白表情
        if emoticons.count > 0 && count == 0 {
            return
        }
        
        //print("\(group_name_cn) 剩余表情数量 \(count)")
        // 添加空白表情
        for _ in count..<20 {
            emoticons.append(Emoticon(isEmpty: true))
        }
        
        // 最末尾添加一个删除按钮
        emoticons.append(Emoticon(isRemoved: true))
        
    }
 
    override var description: String {
        let keys = ["id", "group_name_cn", "emoticons"]
        return dictionaryWithValues(forKeys: keys).description
    }
}

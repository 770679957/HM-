//
//  Status.swift
//  HM微博
//
//  Created by hongmei on 2019/4/24.
//  Copyright © 2019年 itheima. All rights reserved.
//

import UIKit

//微博数据模型
class Status: NSObject{
    
    @objc var id:Int = 0
    //创建内容
    @objc var text:String?
    //时间
    @objc var created_at:String?
    //来源
    @objc var source:String?
    
    // 用户模型
    @objc  var user:User?
    @objc var pic_urls:[[String:String]]?
    
    /// 被转发的原微博信息字段
    @objc var retweeted_status:Status?
    
    
    init(dict: [String:AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        //判断key 是否是user
        if key == "user" {

            if let dict = value as? [String:AnyObject] {
                //print(dict)
                user = User(dict: dict)
                //print(user?.screen_name)
            }
            return
        }

//        // 判断 key 是否等于 retweeted_status
//        if key == "retweeted_status" {
//            if let dict = value as? [String:AnyObject] {
//
//                retweeted_status = Status(dict: dict)
//            }
//            return
//        }
        
        
        super.setValue(value, forKey: key)
        
    }
    
    override var description: String {
        
        let keys = ["id", "text", "created_at", "source", "user", "pic_urls","retweeted_status"]
        return dictionaryWithValues(forKeys: keys).description
    }
    
    
}


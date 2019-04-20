//
//  UserAccount.swift
//  HM微博
//
//  Created by hongmei on 2019/4/20.
//  Copyright © 2019年 itheima. All rights reserved.
//

import UIKit

class UserAccount: NSObject {
    /// 用于调用access_token，接口获取授权后的access token
    @objc var access_token:String?
    //当前授权用户的UID
    @objc var uid:String?
    //access_token的生命周期，单位是秒数
    @objc var expires_in:TimeInterval = 0 {
        didSet {
          //计算过期日期
            expiresDate = NSDate(timeIntervalSinceNow: expires_in)
        }
    }
    //过期日期
    @objc var expiresDate:NSDate?
    
    init(dict:[String:AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    override var description: String {
        let keys = ["access_token","expires_in","expiresDate","uid"]
        return dictionaryWithValues(forKeys: keys).description
    }

}

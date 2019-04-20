//
//  UserAccount.swift
//  HM微博
//
//  Created by hongmei on 2019/4/20.
//  Copyright © 2019年 itheima. All rights reserved.
//

import UIKit

class UserAccount: NSObject, NSCoding {
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
    //用户名称
    @objc var screen_name:String?
    //用户头像地址
    @objc var avatar_large:String?
    
    @objc init(dict:[String:AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    override var description: String {
        let keys = ["access_token","expires_in","expiresDate","uid","screen_name", "avatar_large"]
        return dictionaryWithValues(forKeys: keys).description
    }
    
    // MARK: - `键值`归档和解档
    /// 归档 - 在把当前对象保存到磁盘前，将对象编码成二进制数据
    ///
    /// - parameter aCoder: 编码器
    func encode(with aCoder: NSCoder) {
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(expiresDate, forKey: "expiresDate")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(screen_name, forKey: "screen_name")
        aCoder.encode(avatar_large, forKey: "avatar_large")
    }
    
    ///解档 - 从磁盘加载二进制文件，转换成对象时调用
    /// - parameter aDecoder: 解码器
    ///
    /// - returns: 当前对象
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObject(forKey: "access_token") as?String
        expiresDate = aDecoder.decodeObject(forKey: "expiresDate") as? NSDate
        uid = aDecoder.decodeObject(forKey: "uid") as? String
        screen_name = aDecoder.decodeObject(forKey: "screen_name") as? String
        avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as? String
    }
    
    func saveUserAccount() {
        //保存路径
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        path = (path as NSString).appendingPathComponent("account.plist")
        //print(path)
        NSKeyedArchiver.archiveRootObject(self, toFile: path)
    }
    

}

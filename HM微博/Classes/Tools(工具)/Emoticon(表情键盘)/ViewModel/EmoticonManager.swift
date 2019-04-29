//
//  EmoticonViewModel.swift
//  01-表情键盘
//
//  Created by male on 15/10/23.
//  Copyright © 2015年 itheima. All rights reserved.
//

import Foundation

// MARK: - 表情包管理器 - emoticon.plist
/**
    1. emoticons.plist 定义表情包数组
        packages 字典数组中，每一个 id 对应不同表情包的目录
    2. 从 每一个表情包目录中，加载 info.plist 可以获得不同的表情内容
    id	目录名
    group_name_cn	表情分组名称- 显示在 toolbar 上
    emoticons	 数组
    字典
    chs		发送给服务器的字符串
    png		在本地显示的图片名称
    code	emoji 的字符串编码

*/
class EmoticonManager {
    
    /// 单例
    static let sharedManager = EmoticonManager()
 
    /// 表情包模型
    lazy var packages = [EmoticonPackage]()
    
    // MARK: - 构造函数
    private init() {
        
//        // 0. 添加最近的分组
//        packages.append(EmoticonPackage(dict: ["group_name_cn": "最近" as AnyObject]))
//
//        // 1. 加载 emoticon.plist － 如果文件不存在，path == nil
//        let path = Bundle.main.path(forResource: "emoticons", ofType: "plist", inDirectory: "Emoticons.bundle")
//
//        if path == nil {
//            print("emoticons 文件不存在")
//        }
//
//        // 2. 加载`字典`
//        let dict = NSDictionary(contentsOfFile: path!) as! [String: AnyObject]
//
//        // 3. 从字典中获得 id 的数组 - valueForKey 直接获取字典数组中的 key 对应的数组
//        let array = (dict["packages"] as! NSArray).value(forKey: "id")
//
//        // 4. 遍历 id 数组，准备加载 info.plist
//        for id in array as! [String] {
//            loadInfoPlist(id: id)
//        }
        
        //print(packages)
        loadPlist()
    }
    
    /// 从 emoticons.plist 加载表情包数据
    private func loadPlist() {
        // 0. 添加最近的分组
        packages.append(EmoticonPackage(dict: ["group_name_cn": "最近" as AnyObject]))

        // 1. 加载 emoticon.plist － 如果文件不存在，path == nil
        let path = Bundle.main.path(forResource: "emoticons", ofType: "plist", inDirectory: "Emoticons.bundle")

        if path == nil {
            print("emoticons 文件不存在")
        }

        // 2. 加载`字典`
        let dict = NSDictionary(contentsOfFile: path!) as! [String: AnyObject]

        // 3. 从字典中获得 id 的数组 - valueForKey 直接获取字典数组中的 key 对应的数组
        let array = (dict["packages"] as! NSArray).value(forKey: "id")

        // 4. 遍历 id 数组，准备加载 info.plist
        for id in array as! [String] {
            loadInfoPlist(id: id)
        }
        
       // print(packages)
        
    }
    
    /// 加载每一个 id 目录下的 info.plist
    private func loadInfoPlist(id: String) {
        // 1. 建立路径
        let path = Bundle.main.path(forResource: "info.plist", ofType: nil, inDirectory: "Emoticons.bundle/\(id)")!
        
        // 2. 加载字典 - 一个独立的表情包
        let dict = NSDictionary(contentsOfFile: path) as! [String: AnyObject]
        
        // 3. 字典转模型追加到 packages 数组
        packages.append(EmoticonPackage(dict: dict))
    }
}

//
//  StatusViewModel.swift
//  HM微博
//
//  Created by hongmei on 2019/4/25.
//  Copyright © 2019年 itheima. All rights reserved.
//

import Foundation
import UIKit
//微博视图模型
class StatusViewModel {
    //微博的模型
    var status:Status
    
    /// 用户头像 URL
    var userProfileUrl: NSURL {
        return NSURL(string: status.user?.profile_image_url ?? "")!
    }
    
    /// 用户默认头像
    var userDefaultIconView: UIImage {
        return UIImage(named: "avatar_default_big")!
    }
    
    /// 用户会员图标
    var userMemberImage: UIImage? {
        // 根据 mbrank 来生成图像
        
        if (status.user?.mbrank)! > 0 && (status.user?.mbrank)! < 7
        {
            return UIImage(named: "common_icon_membership_level\(status.user!.mbrank)")
        }
        return nil
    }
    //缩略图Url数组
    var thumbnailUrls: [NSURL]?
    
    
    /// 用户认证图标
    /// 认证类型，-1：没有认证，0，认证用户，2,3,5: 企业认证，220: 达人
    var userVipImage: UIImage? {
        switch(status.user?.verified_type ?? -1) {
        case 0: return UIImage(named: "avatar_vip")
        case 2, 3, 5: return UIImage(named: "avatar_enterprise_vip")
        case 220: return UIImage(named: "avatar_grassroot")
        default: return nil
        }
    }
    /// 行高
    lazy var rowHeight:CGFloat = {
        // print("计算缓存行高\(self.status.text)")
        //let cell = StatusRetweetedCell(style:.default,reuseIdentifier:StatusCellRetweetedId)
        var cell:StatusCell
        //实例化cell
        if self.status.retweeted_status != nil{
            cell = StatusRetweetedCell(style:.default,reuseIdentifier:StatusCellRetweetedId)
        }else{
            cell = StatusNormalCell(style:.default,reuseIdentifier:StatusCellNormalId)
        }
        //返回行高
        return cell.rowHeight(vm: self)
    }()
    var retweetedText: String? {
        guard let s = status.retweeted_status else {
            return nil
        }
        return "@" + (s.user?.screen_name ?? "") + ":" + (s.text ?? "")!
    }
    
    /// 可重用标识符
    var cellId: String {
        return status.retweeted_status != nil ? StatusCellRetweetedId: StatusCellNormalId
    }
    
    //构造a函数
    init(status:Status) {
        self.status = status
        //根据模型，来生成缩略图的数组
        if let urls = status.retweeted_status?.pic_urls ?? status.pic_urls  {
            // 创建缩略图数组
            thumbnailUrls = [NSURL]()
            
            // 遍历字典数组 - 数组如果是可选的，不允许遍历，原因：数组是通过下标来检索数据
            for dict in status.pic_urls! {
                let url = NSURL(string:dict["thumbnail_pic"]!)
                thumbnailUrls?.append(url!)
            }
        }
    }
    
    //描述信息
    var description:String {
        
        return status.description + "配图数组 \(thumbnailUrls)"
    }
}

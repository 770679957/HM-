//
//  StatusListViewModel.swift
//  HM微博
//
//  Created by hongmei on 2019/4/24.
//  Copyright © 2019年 itheima. All rights reserved.
//

import Foundation
//微博数据列表模型
class StatusListViewModel {
    //微博数据组
    //刷新
    lazy var statusList = [StatusViewModel]()
    //加载网络数据
    func loadStatus(finished:@escaping (_ isSuccessed:Bool) ->()){
        NetworkTools.sharedTools.loadStatus{ (result,error) -> () in
            if error != nil {
                print("出错了")
                finished(false)
                return
                
            }
            //print(result)
            //判断result的数据结构是否正确
            let result1 = result as? [String:AnyObject]
            guard let array = result1?["statuses"] as? [[String:AnyObject]]
                else {
                    print("数据格式错误")
                    finished(false)
                    return
            }
            // print(array)
            //遍历数组
            var dataList = [StatusViewModel]()
            
            for dict in array {
                dataList.append(StatusViewModel(status: Status(dict: dict)))
            }
            //拼接数据
            self.statusList = dataList + self.statusList
            //完成回调
            finished(true)
            
            
        }
    }
}

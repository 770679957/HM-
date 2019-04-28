//
//  StatusListViewModel.swift
//  HM微博
//
//  Created by hongmei on 2019/4/24.
//  Copyright © 2019年 itheima. All rights reserved.
//

import Foundation
import SDWebImage
//微博数据列表模型
class StatusListViewModel {
    //微博数据组
    //刷新
    lazy var statusList = [StatusViewModel]()
    
    //下拉刷新数据
    var pulldownCount: Int?
    //加载网络数据
    func loadStatus(isPulled:Bool,finished:@escaping (_ isSuccessed:Bool) ->()){
        //下拉刷新 —— 数组中第一条微博的id
        let since_id = isPulled ? 0 : (statusList.first?.status.id ?? 0)
        
        let max_id = isPulled ? (statusList.last?.status.id ?? 0) : 0
        
        NetworkTools.sharedTools.loadStatus(since_id: since_id, max_id: max_id) { (result, error) -> () in
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
//            /// 记录下拉刷新的数据
           self.pulldownCount = (since_id > 0) ? dataList.count : nil
            //拼接数据 判断是否是上拉刷新
            if max_id > 0 {
                self.statusList += dataList
            }else {
                self.statusList = dataList + self.statusList
            }
            
            //缓存图片
            self.cacheSingleImage(dataList: dataList, finished: finished)
            
            //缓存单张照片
            finished(true)
      
        }
    }
    
    /// 缓存单张图片
    private func cacheSingleImage(dataList:[StatusViewModel],finished:@escaping (_ isSuccessed:Bool)->()) {
        //  创建调度组
        let group = DispatchGroup()
        // 缓存数据长度
        var dataLength = 0
        
        //  遍历视图模型数组
        for vm in dataList{
            // 判断图片数量是否是单张图片
            if vm.thumbnailUrls?.count != 1{
                continue
            }
            // 获取 url
            let url = vm.thumbnailUrls![0]
            print("要缓存的\(url)")
            group.enter()
            SDWebImageManager.shared().loadImage(with: url as URL, options: [SDWebImageOptions.retryFailed,SDWebImageOptions.refreshCached], progress: nil, completed: {
                (image,data1,error,_,_,_) in
                if let img = image ,
                    let data = img.pngData(){
                    dataLength+=data.count
                    print(data.count)
                }
            })
            //出组
            group.leave()
        }
        
        //缓存图片
        group.notify(queue: DispatchQueue.main){
            finished(true)
        }
//        // 监听调度组完成
//        dispatch_group_notify(group, dispatch_get_main_queue()) {
//            // print("缓存完成 \(dataLength / 1024) K")
//            finished(isSuccessed: true)
//        }
        
 
        //下面的不警告
        DispatchQueue.global().async {
            // code
            DispatchQueue.main.sync {
                // 主线程中
                print("缓存完成 \(dataLength / 1024) K")
                finished(true)
            }
        }
        
        
    }
}

//
//  HomeTableViewController.swift
//  HM微博
//
//  Created by hongmei on 2019/4/18.
//  Copyright © 2019年 itheima. All rights reserved.
//

import UIKit

class HomeTableViewController: VisitorTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //判断用户是否登录
        if !UserAccountViewModel.sharedUserAccount.userLogon {
            visitorView?.setupInfo(imageName: nil, title: "关注一些人，回这里看看有什么惊喜")
            return
        }
        loadData()
        
    }

    

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    
    //加载数据
    private func loadData() {
        NetworkTools.sharedTools.loadStatus { (result,error) -> () in
            if error != nil {
                print("出错了")
                return
                
            }
            print(result)
            //判断result的数据结构是否正确
            let result1 = result as? [String:AnyObject]
            guard let array = result1?["statuses"] as? [[String:AnyObject]]
                else {
                    print("数据格式错误")
                    return
            }
           // print(array)
            //遍历数组
            var dataList = [Status]()
            
            for dict in array {
                dataList.append(Status(dict: dict))
            }
            //测试
            print(dataList)
            //刷新数据
            self.tableView.reloadData()
        }
        
    }

    

}

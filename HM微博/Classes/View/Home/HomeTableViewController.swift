//
//  HomeTableViewController.swift
//  HM微博
//
//  Created by hongmei on 2019/4/18.
//  Copyright © 2019年 itheima. All rights reserved.
//

import UIKit
import SVProgressHUD


/// 原创微博 Cell 的可重用表示符号
 private let StatusCellNormalId = "StatusCellNormalId"
/// 转发微博 Cell 的可重用标识符号
 private let StatusCellRetweetedId = "StatusCellRetweetedId"

class HomeTableViewController: VisitorTableViewController {
    //微博数据数组
    private lazy var listViewModel = StatusListViewModel()

    //微博数据数组
    var dataList = [Status]()

    override func viewDidLoad() {
        super.viewDidLoad()
        //判断用户是否登录
        if !UserAccountViewModel.sharedUserAccount.userLogon {
            visitorView?.setupInfo(imageName: nil, title: "关注一些人，回这里看看有什么惊喜")
            return
        }
        loadData()
        prepareTableView()
        
    }
    //准备表格
    private func prepareTableView() {
        //注册可重用cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: StatusCellNormalId)
        
    }
    
    //加载数据
    private func loadData() {
//        NetworkTools.sharedTools.loadStatus { (result,error) -> () in
//            if error != nil {
//                print("出错了")
//                return
//
//            }
//            //print(result)
//            //判断result的数据结构是否正确
//            let result1 = result as? [String:AnyObject]
//            guard let array = result1?["statuses"] as? [[String:AnyObject]]
//                else {
//                    print("数据格式错误")
//                    return
//            }
//           // print(array)
//            //遍历数组
//            var dataList = [Status]()
//
//            for dict in array {
//                dataList.append(Status(dict: dict))
//            }
//            //测试
//            print(dataList)
//            self.dataList = dataList
//            //刷新数据
//            self.tableView.reloadData()
//        }
        
        listViewModel.loadStatus{ (isSuccessed) -> () in
            if !isSuccessed {
                
                SVProgressHUD.showInfo(withStatus: "加载数据错误，请稍后再试")
                return
            }
            print(self.listViewModel.statusList)
            //刷新数据
            self.tableView.reloadData()
        }
        
    }
}

//数据源方法
extension HomeTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StatusCellNormalId, for: indexPath)
        //测试微博信息内容
        cell.textLabel?.text = listViewModel.statusList[indexPath.row].text
        return cell
    }
    
}

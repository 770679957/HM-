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
 let StatusCellNormalId = "StatusCellNormalId"
/// 转发微博 Cell 的可重用标识符号
 let StatusCellRetweetedId = "StatusCellRetweetedId"

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
        // 注册可重用 cell
        tableView.register(StatusRetweetedCell.self,forCellReuseIdentifier:StatusCellRetweetedId)
        // 注册可重用 cell
        tableView.register(StatusNormalCell.self, forCellReuseIdentifier:StatusCellNormalId)

        //测试行高
        tableView.rowHeight = 400
        //自动计算行高
        tableView.estimatedRowHeight = 400
        tableView.rowHeight = UITableView.automaticDimension
        //取消分割线
        tableView.separatorStyle = .none
        //下拉刷新控件默认没有
        refreshControl = WBRefreshControl()
        //添加监听方法
        // 添加监听方法
        refreshControl?.addTarget(self, action: #selector(HomeTableViewController.loadData), for: UIControl.Event.valueChanged)
        
        //上拉刷新视图
        tableView.tableFooterView = pullupView
    }
    
    // MARK: - 懒加载控件
    /// 上拉刷新提示视图
    private lazy var pullupView:UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        indicator.color = UIColor.lightGray
        return indicator
    }()
    
    /// 下拉刷新提示标签
    private lazy var pulldownTipLabel: UILabel = {
        
        let label = UILabel(title: "", fontSize: 18, color: UIColor.white)
        label.backgroundColor = UIColor.orange
        
        // 添加到 navigationBar
        self.navigationController?.navigationBar.insertSubview(label, at: 0)
        
        return label
    }()
    public func showPulldownTip(){
        guard let count = listViewModel.pulldownCount else{
            return
        }
       pulldownTipLabel.text = (count == 0) ? "没有新微博" : "刷新到\(count)条微博"
        let height:CGFloat = 44
        let rect = CGRect(x:0,y:0,width:view.bounds.width,height:height)
        pulldownTipLabel.frame = rect.offsetBy(dx: 0, dy: -2 * height)
        
       UIView.animate(withDuration: 1.0, animations: { () -> Void in
            self.pulldownTipLabel.frame = rect.offsetBy(dx: 0, dy: height)
        }) { (_) -> Void in
            UIView.animate(withDuration:1.0){
               self.pulldownTipLabel.frame = rect.offsetBy(dx: 0, dy: -2 * height)
           }
       }
    }
    
    //加载数据
    @objc private func loadData() {
        // 开始刷新
        refreshControl?.beginRefreshing()
        
        listViewModel.loadStatus(isPulled: pullupView.isAnimating) {(isSuccessed) -> () in
            
            // 关闭刷新控件
            self.refreshControl?.endRefreshing()
            //关闭上拉刷新
            self.pullupView.stopAnimating()
            
            if !isSuccessed {
                SVProgressHUD.showInfo(withStatus: "加载数据错误，请稍后再试")
                return
            }
            //显示下拉刷新提示
            self.showPulldownTip()
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
        //let cell = tableView.dequeueReusableCell(withIdentifier: StatusCellRetweetedId, for: indexPath) as! StatusCell
        //获取视图模型
        let vm = listViewModel.statusList[indexPath.row]
        //获取可重用cell会调用行高方法
        let cell = tableView.dequeueReusableCell(withIdentifier: vm.cellId, for: indexPath) as! StatusCell
        //设置视图模型
        cell.viewModel = vm
        
        // 判断是否是最后一条微博
        if indexPath.row == listViewModel.statusList.count - 1
            && !pullupView.isAnimating {
            
            //开始动画
            pullupView.startAnimating()
            //上拉刷新数据
            loadData()
        }
        
        return cell
    }
    
    override func tableView(_ tableView:UITableView,heightForRowAt indexPath:IndexPath)->CGFloat {
       
        return listViewModel.statusList[indexPath.row].rowHeight
    }
    
}

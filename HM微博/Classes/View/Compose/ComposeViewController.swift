//
//  ComposeViewController.swift
//  HM微博
//
//  Created by hongmei on 2019/4/29.
//  Copyright © 2019年 itheima. All rights reserved.
//

import UIKit
import SVProgressHUD
import SnapKit

class ComposeViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    //视图生命周期
    override func loadView() {
        view = UIView()
        setupUI()
    }
    //关闭
    @objc private func close() {
        
        dismiss(animated: true, completion: nil)
    }
    @objc private func sendStatus() {
        print("发布微博")
    }
    
    

}

//设置界面
private extension ComposeViewController {
    func setupUI() {
        //设置背景颜色
        view.backgroundColor = UIColor.white
        //设置控件
        prepareNavigationBar()
    }
    //设置导航栏
    private func prepareNavigationBar() {
        //左右按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(ComposeViewController.close))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发布", style: .plain, target: self, action: #selector(ComposeViewController.sendStatus))
        
        // 2. 标题视图
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 36))
        navigationItem.titleView = titleView
        
        //标题视图
        // 3. 添加子控件
        let titleLabel = UILabel(title: "发微博", fontSize: 15)
        let nameLabel = UILabel(title: UserAccountViewModel.sharedUserAccount.account?.screen_name ?? "",
                                fontSize: 13,
                                color: UIColor.lightGray)

        titleView.addSubview(titleLabel)
        titleView.addSubview(nameLabel)

        titleLabel.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(titleView.snp_centerX)
            make.top.equalTo(titleView.snp_top)
        }
        nameLabel.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(titleView.snp_centerX)
            make.bottom.equalTo(titleView.snp_bottom)
        }
        
    }
}

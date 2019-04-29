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
    // MARK: - 懒加载控件
    /// 工具条
    private lazy var toolbar = UIToolbar()
    //文本视图
    private lazy var textView:UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 18)
        tv.textColor = UIColor.darkGray
        return tv
    }()
    //占位标签
    private lazy var placeHolderLabel: UILabel = UILabel(title: "",fontSize:18,color:UIColor.lightGray)
   

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
    
    /// 选择表情
    @objc private func selectEmoticon() {
        
        print("选择表情")
    }
    
    

}

//设置界面
private extension ComposeViewController {
    
    
    func setupUI() {
        //设置背景颜色
        view.backgroundColor = UIColor.white
        //设置控件
        prepareNavigationBar()
        prepareToolbar()
        prepareTextView()
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
    //准备工具条
    private func prepareToolbar() {
        //添加控件
        view.addSubview(toolbar)
        //设置背景颜色
        toolbar.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        //自动布局
        toolbar.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(view.snp_bottom)
            make.left.equalTo(view.snp_left)
            make.right.equalTo(view.snp_right)
            make.height.equalTo(44)
        }
        
        //添加控件
        //定义数组itemSettings,用于表示要添加的子控件的信息
        let itemSettings = [["imageName": "compose_toolbar_picture", "actionName": "selectPicture"],
                            ["imageName": "compose_mentionbutton_background"],
                            ["imageName": "compose_trendbutton_background"],
                            ["imageName": "compose_emoticonbutton_background", "actionName": "selectEmoticon"],
                            ["imageName": "compose_addbutton_background"]]
        
        
        //定义数组items，用于表示所有的子控件
        var items = [UIBarButtonItem]()
        //遍历itemSettings 数组
        for dict in itemSettings {
//            //根据子控件的信息创建UIButton对象
//            let button = UIButton(imageName: dict["imageName"]!, backImageName: nil)
//            //判断actionName是否存在，如果存在，则为子控件添加事件处理方法
//               if let actionName = dict["actionName"] {
//                button.addTarget(self, action: Selector(actionName), for: .touchUpInside)
//            }
//            
//            //将使用UIbutton创建UIBarButtonItem
//            let item = UIBarButtonItem(customView: button)
//            //添加子控件
//            items.append(item)
            items.append(UIBarButtonItem(imageName: dict["imageName"]!, target: self, actionName: dict["actionName"]))
            //添加可变长度控件，用于填充子控件之间的空隙
            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        //去掉最后一个多余的可变长度控件
        items.removeLast()
        //将数组items赋值给工具条的子控件集合
        toolbar.items = items
        
        
    }
    
    //准备文本视图
    private func prepareTextView() {
        
        view.addSubview(textView)
        // 添加占位标签
        textView.addSubview(placeHolderLabel)
        
        textView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(view.snp_left)
            make.right.equalTo(view.snp_right)
            make.bottom.equalTo(toolbar.snp_top)
        }
        
        placeHolderLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(textView.snp_top).offset(8)
            make.left.equalTo(textView.snp_left).offset(5)
        }
        textView.text = "分享新鲜事..."
    }
    
}

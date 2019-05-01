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
    //照片选择控制器
    private lazy var picturePickerController = PicturePickerController()
    
    //表情键盘视图
    private lazy var emotionView:EmoticonView = EmoticonView { [weak self] (Emoticon) ->() in
        self?.textView.insertEmoticon(em: Emoticon)
    }
    // MARK: - 懒加载控件
    /// 工具条
    private lazy var toolbar = UIToolbar()
    //文本视图
    private lazy var textView:UITextView = {
        
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 18)
        tv.textColor = UIColor.darkGray
        //始终允许垂直滚动
        tv.alwaysBounceVertical = true
        //拖拽关闭键盘
        tv.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        //设置文本视图的代理
        tv.delegate = self
        
        return tv
    }()
    //占位标签
    private lazy var placeHolderLabel: UILabel = UILabel(title: "",fontSize:18,color:UIColor.lightGray)
   

    override func viewDidLoad() {
        super.viewDidLoad()
        //添加键盘通知
        NotificationCenter.default.addObserver(self, selector: #selector(ComposeViewController.keyboardChanged), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    deinit {
        // 注销通知
        NotificationCenter.default.removeObserver(self)
    }
    //视图生命周期
    override func loadView() {
        view = UIView()
        setupUI()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //激活键盘
        if picturePickerController.view.frame.height == 0 {
            textView.becomeFirstResponder()
            
        }
    }
    //关闭
    @objc private func close() {
        //关闭键盘
        textView.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    @objc private func sendStatus() {
        //获取文本内容
        //参照： https://www.jianshu.com/p/d97d5ddcf7b5
        let text = textView.emoticonText + "http://www.mob.com/downloads/"
        //发布微博
        let image = picturePickerController.pictures.last
        NetworkTools.sharedTools.sendStatus(status: text, image: image) { (result,error) -> () in
            if error != nil {
                print("出错了")
                SVProgressHUD.showInfo(withStatus: "您的网络不给力")
                return
            }
            
            //关闭控制器
            self.close()
            
        }
        
    }
    
    /// 选择照片
    @objc private func selectPicture() {
        //推掉键盘
        textView.resignFirstResponder()
        //// 0. 判断如果已经更新了约束，不再执行后续代码
        if picturePickerController.view.frame.height > 0 {
            return
        }
        // // 1. 修改照片选择控制器视图的约束
        picturePickerController.view.snp_updateConstraints { (make) -> Void in
            make.height.equalTo(view.bounds.height * 0.6)
        }
        // 2. 修改文本视图的约束 - 重建约束，会将之前`textView`的所有的约束删除
        textView.snp_remakeConstraints { (make) -> Void in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
           // make.top.equalTo(self.snp_topLayoutGuideBottom)
            make.left.equalTo(view.snp_left)
            make.right.equalTo(view.snp_right)
            make.bottom.equalTo(picturePickerController.view.snp_top)
        }
        
    }
    
    /// 选择表情
    @objc private func selectEmoticon() {
        //如果使用的是系统键盘，则为nil
        print("选择表情 \(textView.inputView)")
        //推掉键盘
        textView.resignFirstResponder()
        //设置键盘
        textView.inputView = textView.inputView == nil ? emotionView :nil
        //重新激活键盘
        textView.becomeFirstResponder()
        
        
        
    }
    //键盘变化处理
    @objc private func keyboardChanged(n:NSNotification) {
        // 1. 获取目标的rect - 字典中的`结构体`是 NSValue
        let rect = (n.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        // 获取目标的动画时长 - 字典中的数值是 NSNumber
        let duretion = (n.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let offset = -UIScreen.main.bounds.height + rect.origin.y
        //2.更新约束
        toolbar.snp_updateConstraints { (make) -> Void in
            make.bottom.equalTo(view.snp_bottom).offset(offset)
        }
        
        
        //动画曲线数值
        let curve = (n.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).intValue
        UIView.animate(withDuration: duretion) { () -> Void in
            // 设置动画曲线
            /**
             曲线值 = 7
             － 如果之前的动画没有完成，又启动了其他的动画，让动画的图层直接运动到后续动画的目标位置
             － 一旦设置了 `7`，动画时长无效，动画时长统一变成 0.5s
             */
            
            UIView.setAnimationCurve(UIView.AnimationCurve(rawValue: curve)!)
            self.view.layoutIfNeeded()
        }
    }

}

//// MARK: - UITextViewDelegate
extension ComposeViewController:UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
        placeHolderLabel.isHidden = textView.hasText
    }
    
}

//设置界面
private extension ComposeViewController {
    func setupUI() {
        
        // 0. 取消自动调整滚动视图间距
        automaticallyAdjustsScrollViewInsets = false
        //设置背景颜色
        view.backgroundColor = UIColor.white
        //设置控件
        prepareNavigationBar()
        prepareToolbar()
        prepareTextView()
        preparePicturePicker()
    }
    
    //准备照片选择控制器
    private func preparePicturePicker() {
        // 0. 添加子控制器
        //addChild(picturePickerController)
        addChild(picturePickerController)
        
        //添加视图
        //view.addSubview(picturePickerController.view)
        
        // 1. 添加视图
        view.insertSubview(picturePickerController.view, belowSubview: toolbar)

        
        // 2. 自动布局
        picturePickerController.view.snp_makeConstraints { (make) -> Void in
//            make.bottom.equalTo(view.snp_bottom)
//            make.left.equalTo(view.snp_left)
//            make.right.equalTo(view.snp_right)
//            make.height.equalTo(view.snp_height).multipliedBy(0.6)
            make.bottom.equalTo(view.snp_bottom)
            make.left.equalTo(view.snp_left)
            make.right.equalTo(view.snp_right)
            make.height.equalTo(0)
        }
        
        //动画更新约束
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
        
        
    }
    
    //设置导航栏
    private func prepareNavigationBar() {
        //左右按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(ComposeViewController.close))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发布", style: .plain, target: self, action: #selector(ComposeViewController.sendStatus))
        //禁用发布微博按钮
        navigationItem.rightBarButtonItem?.isEnabled = false
        
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
    
    /// 准备文本视图
    private func prepareTextView() {
        view.addSubview(textView)
        
        textView.snp_makeConstraints { (make) -> Void in
            //make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(view.snp_left)
            make.right.equalTo(view.snp_right)
            make.bottom.equalTo(toolbar.snp_top)
        }
        
        // 添加占位标签
        textView.addSubview(placeHolderLabel)
        
        placeHolderLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(textView.snp_top).offset(8)
            make.left.equalTo(textView.snp_left).offset(5)
        }
    }

}

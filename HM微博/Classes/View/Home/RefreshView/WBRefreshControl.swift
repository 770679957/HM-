//
//  WBRefreshControl.swift
//  HM微博
//
//  Created by hongmei on 2019/4/27.
//  Copyright © 2019年 itheima. All rights reserved.
//

import UIKit
//刷新视图
class WBRefreshControl: UIRefreshControl {
    //懒加载控件
    private lazy var refreshView = WBRefreshView.refreshView()
    
    /// 下拉刷新控件偏移量
    private let WBRefreshControlOffset: CGFloat = -60
  
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if frame.origin.y > 0 {
            return
        }
        
        //判断是否正在刷新
        if isRefreshing{
            refreshView.startAnimation()
            return
        }
        
        if frame.origin.y < WBRefreshControlOffset && !refreshView.rotateFlag {
            // print("反过来")
            refreshView.rotateFlag = true
        }
        else if frame.origin.y >= WBRefreshControlOffset && refreshView.rotateFlag {
            // print("转过去")
            refreshView.rotateFlag = false
        }
    }
    
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func setupUI() {
        //隐藏转轮
        tintColor = UIColor.clear
        //添加控件
        addSubview(refreshView)
        //自动布局
        // 自动布局 - 从 `XIB 加载的控件`需要指定大小约束
        refreshView.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(self.snp_center)
            make.size.equalTo(refreshView.bounds.size)
        }
        
        // 使用 KVO 监听位置变化 - 主队列，当主线程有任务，就不调度队列中的任务执行
        // 让当前运行循环中所有代码执行完毕后，运行循环结束前，开始监听
        // 方法触发会在下一次运行循环开始！
        DispatchQueue.main.async() {() ->Void in
            self.addObserver(self, forKeyPath: "frame", options: [], context: nil)
        }
    }
    
    deinit {
        //删除KVO 监听方法
        self.removeObserver(self, forKeyPath: "frame")
    }
}
/// 刷新视图 - 负责处理`动画显示`
class WBRefreshView: UIView {
    //等待按钮
    @IBOutlet weak var loadingIconView: UIImageView!
    //下拉按钮
    @IBOutlet weak var tipIconView: UIImageView!
    
    @IBOutlet weak var TipView: UIView!
    
    //箭头旋转标记
    public var rotateFlag = false{
        
        didSet {
            
            rotateTipIcon()
        }
    }
    //旋转图标动画
    private func rotateTipIcon() {
        var angle = CGFloat(M_PI)
        angle += rotateFlag ? -0.0000001 : 0.0000001
        // 旋转动画，特点：顺时针优先 + `就近原则`
        UIView.animate(withDuration:0.5){ () -> Void in
            
            self.tipIconView.transform = self.tipIconView.transform.rotated(by: CGFloat(angle))
        }
        
    }
    //从XIB 加载视图
    class func refreshView() -> WBRefreshView {
        //推荐使用UINIb的方法加载XIB
        let nib = UINib(nibName: "WBRefreshView", bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil) [0] as! WBRefreshView
        
    }
    
    //播放加载动画
    public func startAnimation() {
        
        //tipView.isHidden = true
        //判断动画是否已经添加
        let key = "transform.rotation"
        if loadingIconView.layer.animation(forKey: key) != nil {
            
            return
        }
        let anim = CABasicAnimation(keyPath: key)
        anim.toValue = 2 * M_PI
        anim.repeatCount = MAXFLOAT
        anim.duration = 0.5
        anim.isRemovedOnCompletion = false
        loadingIconView.layer.add(anim, forKey: key)
    }
    
    //停止加载动画
    public func stopAnimation() {
        
       // tipView.isHidden = false
        loadingIconView.layer.removeAllAnimations()
        
    }
    
}

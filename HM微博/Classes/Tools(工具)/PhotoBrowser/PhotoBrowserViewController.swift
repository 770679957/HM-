//
//  PhotoBrowserViewController.swift
//  HM微博
//
//  Created by hongmei on 2019/5/2.
//  Copyright © 2019年 itheima. All rights reserved.
//

import UIKit
/// 照片浏览器
class PhotoBrowserViewController: UIViewController {
    /// 照片 URL 数组
    private var urls: [NSURL]
    /// 当前选中的照片索引
    private var currentIndexPath: NSIndexPath
    //构造函数，属性都可以是必选，不用后续考虑解包的问题
    init(urls:[NSURL],indexPath:NSIndexPath) {
        self.urls = urls
        self.currentIndexPath = indexPath
        //调用父类方法
        super.init(nibName:nil,bundle:nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    


}

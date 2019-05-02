//
//  PhotoBrowserViewController.swift
//  HM微博
//
//  Created by hongmei on 2019/5/2.
//  Copyright © 2019年 itheima. All rights reserved.
//

import UIKit

/// 可重用 Cell 标识符号
private let PhotoBrowserViewCellId = "PhotoBrowserViewCellId"

/// 照片浏览器
class PhotoBrowserViewController: UIViewController {
    
    //监听方法
    @objc private func close() {
        dismiss(animated: true, completion: nil)
        
    }
    //保存图片
    @objc private func save() {
        print("保存图片")
        
    }
    
    //懒加载控件
    private lazy var collectionView:UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: PhotoBrowserViewLayout())
    //关闭按钮
    private lazy var closeButton:UIButton = UIButton(title: "关闭", fontSize: 14, color: UIColor.white, imageName: nil, backColor: UIColor.darkGray)
    //保存按钮
    private lazy var saveButton:UIButton = UIButton(title: "保存", fontSize: 14, color: UIColor.white, imageName: nil, backColor: UIColor.darkGray)
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
    override func loadView() {
        //设置跟视图
        view = UIView(frame: UIScreen.main.bounds)
        //设置界面
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    // MARK: - 自定义流水布局
    private class PhotoBrowserViewLayout: UICollectionViewFlowLayout {
        
         override func prepare() {
            super.prepare()
            
            itemSize = collectionView!.bounds.size
            minimumInteritemSpacing = 0
            minimumLineSpacing = 0
            scrollDirection = .horizontal
            
            collectionView?.isPagingEnabled = true
            collectionView?.bounces = false
            collectionView?.showsHorizontalScrollIndicator = false
        }
    }
    


}

// MARK: - 设置界面
private extension PhotoBrowserViewController {
    private func setupUI() {
        //添加控件
        view.addSubview(collectionView)
        view.addSubview(closeButton)
        view.addSubview(saveButton)
        
        //设置布局
        collectionView.frame = view.bounds
        
        closeButton.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(view.snp_bottom).offset(-8)
            make.left.equalTo(view.snp_left).offset(8)
            make.size.equalTo(CGSize(width: 100, height: 36))
        }
        saveButton.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(view.snp_bottom).offset(-8)
            make.right.equalTo(view.snp_right).offset(-28)
            make.size.equalTo(CGSize(width: 100, height: 36))
        }
        //监听方法
        closeButton.addTarget(self, action: #selector(PhotoBrowserViewController.close), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(PhotoBrowserViewController.save), for: .touchUpInside)
        
        //准备控件
        prepareCollectionView()
    }
    
    /// 准备 collectionView
    private func prepareCollectionView(){
        //注册可重用cell
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: PhotoBrowserViewCellId)
        //设置数据源
        collectionView.dataSource = self
        
    }
   
}

// MARK: - UICollectionViewDataSource
extension PhotoBrowserViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoBrowserViewCellId, for: indexPath)
        cell.backgroundColor = UIColor.black
        return cell
    }
    
    
    
}

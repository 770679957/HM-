//
//  PhotoBrowserViewController.swift
//  HM微博
//
//  Created by hongmei on 2019/5/2.
//  Copyright © 2019年 itheima. All rights reserved.
//

import UIKit
import SVProgressHUD

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
       // print("保存图片")
        //拿到图片
       // let cell = collectionView.visibleCells()[0] as! PhotoBrowserCell
        let cell = collectionView.visibleCells[0] as! PhotoBrowserCell
        //imageView中很可能会因为网络问题没有图片 -> 下载需要提示
        guard let image = cell.imageView.image else {
            return
        }
        //保存图片
        // 2. 保存图片
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(PhotoBrowserViewController.image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject?) {
        
        let message = (error == nil) ? "保存成功" : "保存失败"
        SVProgressHUD.showInfo(withStatus: message)
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
        var rect = UIScreen.main.bounds
        rect.size.width += 20
        view = UIView(frame: rect)
        //设置界面
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 让 collectionView 滚动到指定位置
        collectionView.scrollToItem(at: currentIndexPath as IndexPath, at: .centeredHorizontally, animated: false)

        
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
        collectionView.register(PhotoBrowserCell.self, forCellWithReuseIdentifier: PhotoBrowserViewCellId)
        //设置数据源
        collectionView.dataSource = self
        
    }
   
}

// MARK: - UICollectionViewDataSource
extension PhotoBrowserViewController: UICollectionViewDataSource {
    
    //获取分区数
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
    
    //获取每个分区里单元格数量
    func collectionView(_ collectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    
    //返回每个单元格视图
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //获取重用的单元格
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoBrowserViewCellId, for: indexPath) as! PhotoBrowserCell
 
        cell.imageURL = urls[(indexPath as NSIndexPath).item] as URL
        
        //cell.backgroundColor = UIColor.black
        return cell
    }
 
}

// MARK: - PhotoBrowserCellDelegate
extension PhotoBrowserViewController: PhotoBrowserCellDelegate {
    
    func photoBrowserCellDidZoom(scale: CGFloat) {
    }
    
    func photoBrowserCellShouldDismiss() {
        imageViewForDismiss()
        close()
    }
    
}

extension PhotoBrowserViewController:PhotoBrowserDismissDelegate {
    func imageViewForDismiss() -> UIImageView {
        let iv = UIImageView()
        //设置填充模式
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        //设置图像
        let cell = collectionView.visibleCells[0] as! PhotoBrowserCell
        iv.image = cell.imageView.image
        //设置位置
        iv.frame = cell.scrollView.convert(cell.imageView.frame, to: UIApplication.shared.keyWindow)
        //测试代码
        UIApplication.shared.keyWindow?.addSubview(iv)
        return iv
        
    }
    
    func indexPathForDismiss() -> NSIndexPath {
        return collectionView.indexPathsForVisibleItems[0] as NSIndexPath
    }
    
    
    
    
}

//
//  StatusPictureView.swift
//  HM微博
//
//  Created by hongmei on 2019/4/26.
//  Copyright © 2019年 itheima. All rights reserved.
//

import UIKit
import SDWebImage
//配图视图
class StatusPictureView: UICollectionView {
    //微博视图模型
    var viewModel:StatusViewModel? {
        didSet {
            sizeToFit()
            reloadData()
            
        }
        
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        //return CGSize(width: 150, height: 120)
        return calcViewSize()
    }
    
    
    //照片之间的间距
    /// 照片之间的间距
    private let StatusPictureViewItemMargin: CGFloat = 8
    //可重用表示符号
    private let StatusPictureCellId = "StatusPictureCellId"
    
    
    init() {
        let layout=UICollectionViewFlowLayout()
        super.init(frame:CGRect.zero,collectionViewLayout:layout)
        backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        //设置间距
        layout.minimumInteritemSpacing=StatusPictureViewItemMargin
        layout.minimumLineSpacing=StatusPictureViewItemMargin
        
        // 设置数据源 - 自己当自己的数据源
        // 应用场景：自定义视图的小框架
        dataSource = self
        
        //注册可重用的cell
        register(StatusPictureViewCell.self, forCellWithReuseIdentifier: StatusPictureCellId)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//计算视图大小
extension StatusPictureView {
    //计算视图大小
    public func calcViewSize()->CGSize {
        //准备
        //每行的照片数量
        let rowCount:CGFloat = 3
        //最大宽度
        let maxWidth = UIScreen.main.bounds.width - 2 * StatusCellMargin
        let itemWidth = (maxWidth - 2 * StatusPictureViewItemMargin) / rowCount
        
        // 2. 设置 layout 的 itemSize
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        // 3. 获取图片数量
        let count=viewModel?.thumbnailUrls?.count ?? 0
        
        // 计算开始
        // 1> 没有图片
        if count==0{
            return CGSize.zero
        }
        
        //一张图片
        // 2> 一张图片
        if count == 1 {
            // 临时设置单图大小
            var size = CGSize(width: 150, height: 120)
            
            // 提取单图
            if let key = viewModel?.thumbnailUrls?.first?.absoluteString {
                
                if let image = SDWebImageManager.shared().imageCache!.imageFromDiskCache(forKey: key) {
                    size = image.size
                }
            }
            
            // 图像过窄处理
            size.width = size.width < 40 ? 40 : size.width
            
            // 图像过宽处理，等比例缩放
            if size.width > 300 {
                let w: CGFloat = 300
                let h = size.height * w / size.width
                size = CGSize(width: w, height: h)
            }
            
            // 内部图片的大小
            layout.itemSize = size
            
            // 配图视图的大小
            return size
        }
        //四张照片
        if count == 4 {
            let w = 2 * itemWidth + StatusPictureViewItemMargin
            return CGSize(width: w, height: w)
        }
        //其他图片按照九宫格来显示
        //计算出行数
        let row = CGFloat((count - 1) / Int(rowCount) + 1)
        let h = row * itemWidth + (row - 1) * StatusPictureViewItemMargin + 1
        let w = rowCount * itemWidth + (rowCount - 1) * StatusPictureViewItemMargin  + 1
       // print("row h w")
//        print(row)
//        print(h)
//        print(w)
        return CGSize(width: w, height: 300)
        
        
        
    }
    
}
// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension StatusPictureView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    //返回thumbnailUrls个数，就是图片的个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.thumbnailUrls?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatusPictureCellId, for: indexPath) as! StatusPictureViewCell
          cell.imageURL = viewModel!.thumbnailUrls![indexPath.item]
          cell.backgroundColor = UIColor.red
          return cell
    }
    
}

    
    // MARK: - 配图 cell  p216
    private class StatusPictureViewCell: UICollectionViewCell {
        var imageURL: NSURL? {
            didSet {
                iconView.sd_setImage(with:imageURL as URL?, placeholderImage: nil, options: [SDWebImageOptions.retryFailed,SDWebImageOptions.refreshCached])//重试，刷新缓存
                
                let ext = ((imageURL?.absoluteString ?? "") as NSString).pathExtension.lowercased()
                gifIconView.isHidden = (ext != "gif")
            }
        }
        
        // MARK: - 构造函数
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupUI()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // MARK: - 设置界面
        private func setupUI() {
            // 1. 添加控件
            contentView.addSubview(iconView)
            //iconView.addSubview(gifIconView)
            
            // 2. 设置布局 - 提示因为 cell 会变化，另外，不同的 cell 大小可能不一样
            iconView.snp_makeConstraints { (make) -> Void in
                make.edges.equalTo(contentView.snp_edges)
            }
//            gifIconView.snp_makeConstraints { (make) -> Void in
//                make.right.equalTo(iconView.snp_right)
//                make.bottom.equalTo(iconView.snp_bottom)
//            }
        }
        
        // MARK: - 懒加载控件
        // MARK: - 懒加载控件
        private lazy var iconView: UIImageView = {
            let iv = UIImageView()
            
            // 设置填充模式
            //iv.contentMode = .scaleAspectFill
            
            iv.contentMode = .scaleToFill
            
            
            // 需要裁切图片
            iv.clipsToBounds = true
            
            return iv
        }()
        
        /// GIF 提示图片
        private lazy var gifIconView: UIImageView = UIImageView(imageName: "timeline_image_gif")
        
        
  }


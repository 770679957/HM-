//
//  StatusPictureView.swift
//  HM微博
//
//  Created by hongmei on 2019/4/26.
//  Copyright © 2019年 itheima. All rights reserved.
//

import UIKit
//配图视图
class StatusPictureView: UICollectionView {
    //微博视图模型
    var viewModel:StatusViewModel? {
        didSet {
           sizeToFit()
            
        }
        
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        //return CGSize(width: 150, height: 120)
        return calcViewSize()
    }
    
    
    //照片之间的间距
    /// 照片之间的间距
    private let StatusPictureViewItemMargin: CGFloat = 8
    
    
    init() {
        let layout=UICollectionViewFlowLayout()
        super.init(frame:CGRect.zero,collectionViewLayout:layout)
        backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        //设置间距
        layout.minimumInteritemSpacing=StatusPictureViewItemMargin
        layout.minimumLineSpacing=StatusPictureViewItemMargin
        
        
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
        if count == 1 {
            //临时指定大小
            let size = CGSize(width: 150, height: 120)
            //内部图片的大小
            layout.itemSize = size
            //配图视图的大小
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
        print("row h w")
        print(row)
        print(h)
        print(w)
        return CGSize(width: w, height: h)
        
        
        
    }
    
}

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
    init() {
        let layout=UICollectionViewFlowLayout()
        super.init(frame:CGRect.zero,collectionViewLayout:layout)
        backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

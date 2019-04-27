//
//  StatusRetweetedCell.swift
//  HM微博
//
//  Created by hongmei on 2019/4/27.
//  Copyright © 2019年 itheima. All rights reserved.
//

import UIKit
//转发微博
class StatusRetweetedCell: StatusCell {
    //懒加载控件
    //背景图片
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        return button
    }()
    //转发微博标签
     lazy var retweetedLabel: UILabel = UILabel (title: "转发微博", fontSize: 14, color: UIColor.darkGray, screenInset: StatusCellMargin)
    
    override func setupUI() {
        super.setupUI()
        contentView.insertSubview(backButton,belowSubview:pictureView)
        contentView.insertSubview(retweetedLabel, aboveSubview: backButton)
        
        backButton.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(contentLabel.snp.bottom).offset(StatusCellMargin)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.bottom.equalTo(bottomView.snp.top)
        }
        retweetedLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(backButton.snp.top).offset(StatusCellMargin)
            make.left.equalTo(backButton.snp.left).offset(StatusCellMargin)
        }
        //配图视图
        pictureView.snp.makeConstraints{ (make)->Void in
            make.top.equalTo(retweetedLabel.snp.bottom).offset(StatusCellMargin)
            make.left.equalTo(retweetedLabel.snp.left)
            make.width.equalTo(300)
            make.height.equalTo(90)
            
        }
    }

 
}

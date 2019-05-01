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
    
    /// 微博视图模型
    override var viewModel: StatusViewModel? {
        didSet {
            // 转发微博的文字
            //            let text = viewModel?.retweetedText ?? ""
            //            retweetedLabel.attributedText = EmoticonManager.sharedManager.emoticonText(text, font: retweetedLabel.font)
            retweetedLabel.text = viewModel?.retweetedText
            
            pictureView.snp_updateConstraints { (make) -> Void in
                
                // 根据配图数量，决定配图视图的顶部间距
                let offset = viewModel?.thumbnailUrls?.count == 0 ? 0 : StatusCellMargin
                make.top.equalTo(retweetedLabel.snp_bottom).offset(offset)
            }
        }
    }
    
    /**
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
  **/
    
}

// MARK: - 设置界面
extension StatusRetweetedCell {
    
    /// 设置界面
    override func setupUI() {
        // 调用父类的 setupUI，设置父类控件位置
        super.setupUI()
        
        // 1. 添加控件
        contentView.insertSubview(backButton, belowSubview: pictureView)
        contentView.insertSubview(retweetedLabel, aboveSubview: backButton)
        
        //2. 自动布局
        backButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(contentLabel.snp_bottom).offset(StatusCellMargin)
            make.left.equalTo(contentView.snp_left)
            make.right.equalTo(contentView.snp_right)
            make.bottom.equalTo(bottomView.snp_top)
        }
        
        retweetedLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(backButton.snp_top).offset(StatusCellMargin)
            make.left.equalTo(backButton.snp_left).offset(StatusCellMargin)
        }
        
        // 配图视图
        pictureView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(retweetedLabel.snp_bottom).offset(StatusCellMargin)
            make.left.equalTo(retweetedLabel.snp_left)
            make.width.equalTo(300)
            make.height.equalTo(90)
        }
    }
    
}

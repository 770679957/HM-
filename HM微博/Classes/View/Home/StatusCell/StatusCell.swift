//
//  StatusCell.swift
//  HM微博
//
//  Created by hongmei on 2019/4/25.
//  Copyright © 2019年 itheima. All rights reserved.
//

import UIKit


// 微博 Cell 中控件的间距数值
let StatusCellMargin: CGFloat = 12
/// 微博头像的宽度
let StatusCellIconWidth: CGFloat = 35

class StatusCell: UITableViewCell {
    //懒加载控件
    //顶部视图
    private lazy var topView:StatusCellTopView = StatusCellTopView()
    
    //微博正文标签
    private  lazy var contentLabel:UILabel = UILabel(title: "", fontSize: 15, color: UIColor.darkGray,screenInset:StatusCellMargin)
    // 配图视图
   // lazy var pictureView: StatusPictureView = StatusPictureView()
    //底部视图
    private lazy var bottomView:StatusCellBottomView = StatusCellBottomView()
    
    //微博视图模型
    var viewModel:StatusViewModel? {
        didSet {
            
            topView.viewModel = viewModel
            contentLabel.text = viewModel?.status.text
        }
    }
    
    // MARK: - 构造函数
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}

//设置界面
extension StatusCell {
    @objc func setupUI() {
        //添加控件
        contentView.addSubview(topView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(bottomView)
        //顶部视图
        topView.snp.makeConstraints{ (make)->Void in
            make.top.equalTo(contentView.snp.top)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.height.equalTo(2 * StatusCellMargin + StatusCellIconWidth)
        }
        
        //内容标签
        contentLabel.snp.makeConstraints{ (make)->Void in
            make.top.equalTo(topView.snp.bottom).offset(StatusCellMargin)
            make.left.equalTo(contentView.snp.left).offset(StatusCellMargin)
            
        }
        
        //底部试图
        bottomView.snp.makeConstraints{ (make)->Void in
            make.top.equalTo(contentLabel.snp.bottom).offset(StatusCellMargin)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.height.equalTo(44)
            
        //指定像下的约束
            make.bottom.equalTo(contentView.snp_bottom)
        }
        
    }
}

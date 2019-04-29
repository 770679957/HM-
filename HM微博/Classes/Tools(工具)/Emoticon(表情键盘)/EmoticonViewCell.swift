//
//  EmoticonViewCell.swift
//  表情键盘01
//
//  Created by yangyingwei on 2019/4/14.
//  Copyright © 2019 yangyingwei. All rights reserved.
//

import UIKit


class EmoticonViewCell: UICollectionViewCell {
    //表情按钮
    var emoticonButton:UIButton = UIButton()
    
    
    var emoticon:Emoticon? {
        didSet{
            emoticonButton.setImage(UIImage(named:(emoticon!.imagePath)), for: .normal)
            emoticonButton.setTitle(emoticon?.emoji, for: UIControl.State.normal)
            
            // 设置删除按钮
            if emoticon!.isRemoved {
                emoticonButton.setImage(UIImage(named: "compose_emotion_delete"), for: UIControl.State.normal)
            }
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        contentView.addSubview(emoticonButton)
        emoticonButton.backgroundColor = UIColor.white
        emoticonButton.setTitleColor(UIColor.black, for: .normal)
        
        
        //emoticonButton.frame = CGRect.insetBy(self.bounds,4,4)
        emoticonButton.frame = self.bounds.insetBy(dx: 4,dy: 4)
        
        // 字体的大小和高度相近
        emoticonButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        
        emoticonButton.isUserInteractionEnabled = false
        
 
    }
 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
}

//
//  UITextView+Emoticon.swift
//  01-表情键盘
//
//  Created by male on 15/10/24.
//  Copyright © 2015年 itheima. All rights reserved.
//

import UIKit

/**
    代码复核 － 对重构完成的代码进行检查

    1. 修改注释
    2. 确认是否需要进一步重构
    3. 再一次检查返回值和参数
*/
extension UITextView {
    
    /// 图片表情完整字符串内容
    var emoticonText: String {
        
        var strM = String()
        
        let attrText = attributedText
        
        // 遍历属性文本
        attrText?.enumerateAttributes(in: NSRange(location: 0, length: (attrText?.length)!),
            options: []) { (dict, range, _) -> Void in
                
                // - 如果字典中包含 NSAttachment 说明是图片
                // - 否则是字符串，可以通过 range 获得
                print("yyw============================")
                //if let attachment = dict["NSAttachment"] as? EmoticonAttachment {
                if let attachment = dict[NSAttributedString.Key.attachment] as? EmoticonAttachment{
                    strM += attachment.emoticon.chs ?? ""
                } else {
                    let str = (attrText!.string as NSString).substring(with: range)

                    strM += str
                }
        }
        
        return strM
    }
    
    /// 插入表情符号
    ///
    /// - parameter em: 表情模型
    func insertEmoticon(em: Emoticon) {
        
        // 1. 空白表情
        if em.isEmpty {
            return
        }
        
        // 2. 删除按钮
        if em.isRemoved {
            deleteBackward()
            return
        }
        
        // 3. emoji
        if let emoji = em.emoji {
            replace(selectedTextRange!, withText: emoji)
            
            return
        }
        
        // 4. 图片表情
        insertImageEmoticon(em: em)
        //表示代理如果没有实现方法，就什么都不做，更安全
        delegate?.textViewDidChange!(self)
    }
    
    /// 插入图片表情
    private func insertImageEmoticon(em: Emoticon) {
        
        // 1. 图片的属性文本
        let imageText = EmoticonAttachment(emoticon: em).imageText(font: font!)
        
        // 2. 记录 textView attributeString －> 转换成可变文本
        let strM = NSMutableAttributedString(attributedString: attributedText)
        
        // 3. 插入图片文本
        strM.replaceCharacters(in: selectedRange, with: imageText)
        
        // 4. 替换属性文本
        // 1) 记录住`光标`位置
        let range = selectedRange
        // 2) 替换文本
        attributedText = strM
        // 3) 恢复光标
        selectedRange = NSRange(location: range.location + 1, length: 0)
    }
}

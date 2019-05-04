//
//  PhotoBrowserAnimator.swift
//  HM微博
//
//  Created by hongmei on 2019/5/4.
//  Copyright © 2019年 itheima. All rights reserved.
//

import UIKit
// MARK: - 提供动画转场的`代理`
class PhotoBrowserAnimator: NSObject,UIViewControllerTransitioningDelegate {
    // 返回提供 modal 展现的`动画的对象`
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        //isPresented = true
        return self as! UIViewControllerAnimatedTransitioning
    }
}

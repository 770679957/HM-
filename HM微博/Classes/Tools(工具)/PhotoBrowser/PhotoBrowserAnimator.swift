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
    
    /// 是否有 modal 展现的标记
    private var isPresented = false
    
    // 返回提供 modal 展现的`动画的对象`
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresented = true
        return self as! UIViewControllerAnimatedTransitioning
    }
    
    // 返回提供 dismiss 的`动画对象`
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
         isPresented = false
         return self
    }
    
}


// 实现具体的动画方法
extension PhotoBrowserAnimator: UIViewControllerAnimatedTransitioning {
   //动画时长
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        isPresented ? presentAnimation(transitionContext: transitionContext) : dismissAnimation(transitionContext: transitionContext)
    }
    
    /// 展现动画
    private func presentAnimation(transitionContext: UIViewControllerContextTransitioning) {
        //获取model 要展现的控制器的跟视图
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        //将视图添加到容器视图中
        transitionContext.containerView.addSubview(toView)
        toView.alpha = 0
        
        //开始动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
            animations: { () -> Void in

                //iv.frame = presentDelegate.photoBrowserPresentToRect(indexPath)
                toView.alpha = 1

            }) { (_) -> Void in

//                // 将图像视图删除
      //         iv.removeFromSuperview()
//
//                // 显示目标视图控制器的 collectioView
//                toVC.collectionView.hidden = false

                // 告诉系统转场动画完成
                transitionContext.completeTransition(true)
        }
    }
    //解除转场动画
    private func dismissAnimation(transitionContext: UIViewControllerContextTransitioning) {
        // 1. 获取要 dismiss 的控制器的视图
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       animations: { () -> Void in


                fromView.alpha = 0

//                // 让 iv 运动到目标位置
//                iv.frame = presentDelegate.photoBrowserPresentFromRect(IndexPath)
//
            }) { (_) -> Void in

                // 将 iv 从父视图中删除
                fromView.removeFromSuperview()

                // 告诉系统动画完成
                transitionContext.completeTransition(true)
        }
        
    }
    
    
    
    
    
    
    
    
}

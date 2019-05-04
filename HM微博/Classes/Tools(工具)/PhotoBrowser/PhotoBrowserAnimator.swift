//
//  PhotoBrowserAnimator.swift
//  HM微博
//
//  Created by hongmei on 2019/5/4.
//  Copyright © 2019年 itheima. All rights reserved.
//

import UIKit

// MARK: - 展现动画协议
protocol PhotoBrowserPresentDelegate: NSObjectProtocol {
    
    /// 指定 indexPath 对应的 imageView，用来做动画效果
    func imageViewForPresent(indexPath: NSIndexPath) -> UIImageView
    
    /// 动画转场的起始位置
    func photoBrowserPresentFromRect(indexPath: NSIndexPath) -> CGRect
    
    /// 动画转场的目标位置
    func photoBrowserPresentToRect(indexPath: NSIndexPath) -> CGRect
}

// MARK: - 解除动画协议
protocol PhotoBrowserDismissDelegate: NSObjectProtocol {
    
    /// 解除转场的图像视图（包含起始位置）
    func imageViewForDismiss() -> UIImageView
    
    /// 解除转场的图像索引
    func indexPathForDismiss() -> NSIndexPath
}

// MARK: - 提供动画转场的`代理`
class PhotoBrowserAnimator: NSObject,UIViewControllerTransitioningDelegate {
    /// 展现代理
    weak var presentDelegate: PhotoBrowserPresentDelegate?
    
    /// 解除代理
    weak var dismissDelegate: PhotoBrowserDismissDelegate?
    
    /// 动画图像的索引
    var indexPath: NSIndexPath?
    
    /// 是否有 modal 展现的标记
    private var isPresented = false
    
    /// 设置代理相关属性
    ///
    /// - parameter presentDelegate: 展现代理对象
    /// - parameter indexPath:       图像索引
    func setDelegateParams(presentDelegate: PhotoBrowserPresentDelegate,
                           indexPath: NSIndexPath,dismissDelegate:PhotoBrowserDismissDelegate) {
    
        self.presentDelegate = presentDelegate
        self.dismissDelegate = dismissDelegate
        self.indexPath = indexPath
    }
    
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
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        isPresented ? presentAnimation(transitionContext: transitionContext) : dismissAnimation(transitionContext: transitionContext)
    }
    
    /// 展现动画
    private func presentAnimation(transitionContext: UIViewControllerContextTransitioning) {
        //判断参数是否存在
        guard let presentDelegate = presentDelegate, let indexPath = indexPath else {
            return
        }
        
        //获取model 要展现的控制器的跟视图
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        //将视图添加到容器视图中
        transitionContext.containerView.addSubview(toView)
        //图像视图
         let iv = presentDelegate.imageViewForPresent(indexPath: indexPath)
        //指定图像视图位置
        iv.frame = presentDelegate.photoBrowserPresentFromRect(indexPath: indexPath)
        // 将图像视图添加到容器视图
        transitionContext.containerView.addSubview(iv)

        toView.alpha = 0
        
        //开始动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
            animations: { () -> Void in

                iv.frame = presentDelegate.photoBrowserPresentToRect(indexPath: indexPath)
                toView.alpha = 1

            }) { (_) -> Void in

//                // 将图像视图删除
                iv.removeFromSuperview()
//
//                // 显示目标视图控制器的 collectioView
//                toVC.collectionView.hidden = false

                // 告诉系统转场动画完成
                transitionContext.completeTransition(true)
        }
    }
    //解除转场动画
    private func dismissAnimation(transitionContext: UIViewControllerContextTransitioning) {
     // guard let 会把属性变成局部变量，后续的闭包中不需要 self，也不需要考虑解包！
        guard let presentDelegate = presentDelegate,let dismissDelegate = dismissDelegate else {
                return
        }
        
        // 1. 获取要 dismiss 的控制器的视图
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        fromView.removeFromSuperview()
        //获取图像视图
        let iv = dismissDelegate.imageViewForDismiss()
        //添加到容器视图
        transitionContext.containerView.addSubview(iv)

        // 3. 获取dismiss的indexPath
        let indexPath = dismissDelegate.indexPathForDismiss()

        UIView.animate(withDuration: transitionDuration(using: transitionContext),animations: { () -> Void in
            
            //iv.frame = presentDelegate.photoBrowserPresentFromRect(indexPath: indexPath)

                
            }) { (_) -> Void in

                // 将 iv 从父视图中删除
                iv.removeFromSuperview()

                // 告诉系统动画完成
                transitionContext.completeTransition(true)
        }
        
    }
}

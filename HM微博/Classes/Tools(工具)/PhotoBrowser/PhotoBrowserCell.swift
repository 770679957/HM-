//
//  PhotoBrowserCell.swift
//  HM微博
//
//  Created by hongmei on 2019/5/2.
//  Copyright © 2019年 itheima. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD

protocol PhotoBrowserCellDelegate: NSObjectProtocol {
    
    /// 视图控制器将要关闭
    func photoBrowserCellShouldDismiss()
    
    /// 通知代理缩放的比例
    func photoBrowserCellDidZoom(scale: CGFloat)
}


class PhotoBrowserCell: UICollectionViewCell {
    weak var photoDelegate: PhotoBrowserCellDelegate?
    
    // MARK: - 监听方法
    @objc private func tapImage() {
        
        photoDelegate?.photoBrowserCellShouldDismiss()
    }
    
    var imageURL:URL? {
        
        didSet {
            guard let url = imageURL else {
                
                return
            }
            
            // 1. 恢复 scrollView
            resetScrollView()
            
            // 2. url 缩略图的地址
            // 从磁盘加载缩略图的图像
            imageView.image = SDWebImageManager.shared().imageCache?.imageFromCache(forKey: url.absoluteString)
            //设置大小
            imageView.sizeToFit()
            //设置中心点
            imageView.center = scrollView.center
            
            //setPlaceHolder(placeholderImage)
            
            // 3. 异步加载大图
            imageView.sd_setImageWithPreviousCachedImage(with: bmiddleURL(url: url),
                                          placeholderImage: nil,
                                          options: [SDWebImageOptions.retryFailed, SDWebImageOptions.refreshCached],
                                          progress: { (current, total , _) -> Void in
                                                    //print("current\(current)")
                                                    //print("total\(total)")
                                            
                                                    // 更新进度
                                                    DispatchQueue.main.sync {
                                                        // 主线程中
                                                        self.placeHolder.progress = CGFloat(current/total)
                                                    }
                                            
                                                 }) { (image, _, _, _) -> Void in
                                                    
                                                    // 判断图像下载是否成功
                                                    if image == nil {
                                                        SVProgressHUD.showInfo(withStatus: "您的网络不给力")
                                                        return
                                                    }
                                                    
                                                    // 隐藏占位图像
                                                    self.placeHolder.isHidden = true
                                                    
                                                    // 设置图像视图位置
                                                    self.setPositon(image: image!)
                                                    }

        }
    }
    
    /// 设置占位图像视图的内容
    ///
    /// - parameter image: 本地缓存的缩略图，如果缩略图下载失败，image 为 nil
    private func setPlaceHolder(image: UIImage?) {
        
        placeHolder.isHidden = false
        placeHolder.image = image
        placeHolder.sizeToFit()
        placeHolder.center = scrollView.center
    }
    
    /// 重设 scrollView 内容属性
    private func resetScrollView() {
        //重设imageView 的 transform 属性
        imageView.transform = CGAffineTransform.identity
        //重设scrollView 的属性
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.contentOffset = CGPoint.zero
        scrollView.contentSize = CGSize.zero
        
    }
    
    /// 设置 imageView 的位置
    ///
    /// - parameter image: image
    /// - 长/短图
    private func setPositon(image: UIImage) {
        // 自动设置大小
        let size = self.displaySize(image: image)
        
        // 判断图片高度
        if size.height < scrollView.bounds.height {
            // 上下居中显示 - 调整 frame 的 x/y，一旦缩放，影响滚动范围
            imageView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            
            // 内容边距 － 会调整控件位置，但是不会影响控件的滚动
            let y = (scrollView.bounds.height - size.height) * 0.5
            scrollView.contentInset = UIEdgeInsets(top: y, left: 0, bottom: 0, right: 0)
        } else {
            imageView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            scrollView.contentSize = size
        }
    }
    
    //懒加载控件
    lazy var scrollView: UIScrollView = UIScrollView()
    lazy var imageView: UIImageView = UIImageView()
    
    /// 占位图像
    private lazy var placeHolder: ProgressImageView = ProgressImageView()
    
    
    /// 根据 scrollView 的宽度计算等比例缩放之后的图片尺寸
    ///
    /// - parameter image: image
    ///
    /// - returns: 缩放之后的 size
    private func displaySize(image:UIImage) -> CGSize {
        let w = scrollView.bounds.width
        let h = image.size.height * w / image.size.width
        return CGSize(width: w, height: h)
        
    }
    
    //设置imageView 的位置
    private func setPosition(_image: UIImage) {
        //计算的大小
        let size = self.displaySize(image: _image)
        //判断图片高度
        if size .height < scrollView.bounds.height {
            //上下居中显示
            imageView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            //内容边距 - 调整控件位置，但是不会影响控件的滚动
            let y = (scrollView.bounds.height - size.height) * 0.5
            scrollView.contentInset = UIEdgeInsets(top: y, left: 0, bottom: 0, right: 0)
        } else {
            //较长图片
            imageView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            scrollView.contentSize = size
            
        }
        
        
    }
    
    
    
    //返回中等尺寸图片
    private func bmiddleURL(url: URL) -> URL {
        // 1. 转换成 string
        var urlString = url.absoluteString
        // 2. 替换单词
        urlString = urlString.replacingOccurrences(of: "/thumbnail/f", with: "/bmiddle/")
        
        return URL(string: urlString)!
        
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func setupUI() {
        //添加控件
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(placeHolder)
        
        // 2. 设置位置
        var rect = bounds
        rect.size.width -= 20
        scrollView.frame = rect
        
        // 设置 scrollView 缩放
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 2.0
        
        // 4. 添加手势识别
        let tap = UITapGestureRecognizer(target: self, action: #selector(PhotoBrowserCell.tapImage))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
        
        
    }
    
}

extension PhotoBrowserCell:UIScrollViewDelegate {
    //返回被缩放的视图
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    /// 缩放完成后执行一次
    ///
    /// - parameter scrollView: scrollView
    /// - parameter view:       view 被缩放的视图
    /// - parameter scale:      被缩放的比例
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        var offsetY = (scrollView.bounds.height - view!.frame.height) * 0.5
        //如果offsetY小于0，说明图片y值超出屏幕，此时让offsety为0
        offsetY = offsetY < 0 ? 0 : offsetY
        //如果offsetY小于0，说明图片x值超出屏幕，此时让offsety为0
        var offsetX = (scrollView.bounds.width - view!.frame.width) * 0.5
        offsetX = offsetX < 0 ? 0 : offsetX
        //设置间距
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
    }
}


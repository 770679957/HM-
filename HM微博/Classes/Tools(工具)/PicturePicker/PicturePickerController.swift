//
//  PicturePickerController.swift
//  SelectPhotos
//
//  Created by hongmei on 2019/4/30.
//  Copyright © 2019年 itheima. All rights reserved.
//

import UIKit

/// 可重用 cell
private let PicturePickerCellId = "PicturePickerCellId"
//选择照片的最大数量
private let PicturePickerMaxCount = 8

class PicturePickerController: UICollectionViewController {
    //配图数组
    lazy var pictures = [UIImage]()
    //当前用户选中的照片索引
    private var selectedIndex = 0
    
//构造函数
    init() {
        
        super.init(collectionViewLayout: PicturePickerLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.backgroundColor = UIColor.white
       

        // 注册可重用 Cell
        self.collectionView!.register(PicturePickerCell.self, forCellWithReuseIdentifier: PicturePickerCellId)
 
    }
    
    // MARK: - 照片选择器布局
    private class PicturePickerLayout: UICollectionViewFlowLayout {
        
         override func prepare() {
            super.prepare()
            
            // iOS 9.0 之后，尤其是 iPad 支持分屏，不建议过分依赖 UIScreen 作为布局参照！
            let count: CGFloat = 4
            let margin = UIScreen.main.scale * 4
            let w = (collectionView!.bounds.width - (count + 1) * margin) / count
            
            itemSize = CGSize(width: w, height: w)
            sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: 0, right: margin)
            minimumInteritemSpacing = margin
            minimumLineSpacing = margin
        }
    }
   

}

extension PicturePickerController {

    // 返回每个表情包中的表情数量
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 保证末尾有一个加号按钮，如果达到上限，不再显示加号按钮！
        return pictures.count + (pictures.count == PicturePickerMaxCount ? 0 : 1)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PicturePickerCellId, for: indexPath) as! PicturePickerCell
        cell.image = (indexPath.item < pictures.count) ?
            pictures[indexPath.item] : nil
        // 设置代理
        cell.pictureDelegate = self
        //cell.backgroundColor = UIColor.red
        
        return cell

    }
    
}

// MARK: - PicturePickerCellDelegate
extension PicturePickerController: PicturePickerCellDelegate {
    fileprivate func picturePickerCellDidAdd(cell: PicturePickerCell) {
        
        //判断是否允许访问相册
        if !UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            print("无法访问")
        }
        
        // 记录当前用户选中的照片索引
        selectedIndex = collectionView?.indexPath(for: cell)?.item ?? 0
       
        // 显示照片选择器
        let picker = UIImagePickerController()
        // 设置代理
        picker.delegate = self
        
        present(picker, animated: true, completion: nil)
    }
    fileprivate func picturePickerCellDidRemove(cell: PicturePickerCell) {
        //print("删除照片")
        //获取照片索引
        // 1. 获取照片索引
        let indexPath = collectionView!.indexPath(for: cell)!
        //判断索引是否超出上线
        if indexPath.item >= pictures.count {
            return
        }
        //删除数据
        //pictures.removeAtIndex(indexPath.item)
        //set1.remove(at: set1.index(of: 3)!)
        pictures.remove(at: indexPath.item)
        // 4. 动画刷新视图 - 重新调用数据行数的数据源方法
        // reloadData 方法只是单纯的刷新数据，没有动画，但是不会检测具体的 item 的数量
        collectionView?.reloadData()
       
    }
    
    
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension PicturePickerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let scaleImage = image.scaleToWith(width: 600)
        // 将图像添加到数组
        // 判断当前选中的索引是否超出数组上限
        if selectedIndex >= pictures.count {
            pictures.append(scaleImage)
        } else {
            pictures[selectedIndex] = scaleImage
        }
        //// 释放控制器
        //将图像添加到数组
        //pictures.append(image)
        //print(image)
        //刷新视图
        collectionView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    
}

/// PicturePickerCellDelegate 代理
/// 如果协议中包含 optional 的函数，协议需要使用 @objc 修饰
@objc
private protocol PicturePickerCellDelegate: NSObjectProtocol {
    /// 添加照片
    func picturePickerCellDidAdd(cell: PicturePickerCell)
    
    /// 删除照片
    func picturePickerCellDidRemove(cell: PicturePickerCell)
}

/// 照片选择 Cell - private修饰类，内部的一切方法和属性，都是私有的
private class PicturePickerCell: UICollectionViewCell {

    //照片选择器代理
    weak var pictureDelegate: PicturePickerCellDelegate?
    
    //照片选择代理
    var image:UIImage? {
        didSet{
            addButton.setImage(image ?? UIImage(named: "compose_pic_add"), for: .normal)
            //隐藏删除按钮
            removeButton.isHidden = (image == nil)
        }
    }
    
    //监听方法
    @objc func addPicture() {
        
        
        pictureDelegate?.picturePickerCellDidAdd(cell: self)
    }
    @objc func removePicture(){
        pictureDelegate?.picturePickerCellDidRemove(cell: self)
    }
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //懒加载控件
    //添加按钮
    private lazy var addButton: UIButton = UIButton(imageName: "compose_pic_add", backImageName: nil)
    /// 删除按钮
    private lazy var removeButton: UIButton = UIButton(imageName: "compose_photo_close", backImageName: nil)
    //设置控件
    private func setupUI(){
        
        
        //添加控件
        contentView.addSubview(addButton)
        contentView.addSubview(removeButton)
        
        //设置布局
        addButton.frame = bounds
        
        removeButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(contentView.snp_top)
            make.right.equalTo(contentView.snp_right)
        }
        //监听方法
        addButton.addTarget(self, action: #selector(PicturePickerCell.addPicture), for: .touchUpInside)
        removeButton.addTarget(self, action: #selector(PicturePickerCell.removePicture), for: .touchUpInside)
        
        //设置填充模式
        addButton.imageView?.contentMode = .scaleToFill
        
        
    }
    
    
    
    
}

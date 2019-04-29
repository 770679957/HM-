//
//  EmoticonView.swift
//  表情键盘01
//
//  Created by yangyingwei on 2019/4/13.
//  Copyright © 2019 yangyingwei. All rights reserved.
//

import UIKit
import SnapKit

/// 可重用 Cell Id
private let EmoticonViewCellId = "EmoticonViewCellId"

class EmoticonView: UIView {
    
    /// 选中表情回调
    private var selectedEmoticonCallBack: (_ emoticon: Emoticon)->()

    // 表情键盘集合视图
    private lazy var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: EmoticonLayout())
    //工具栏
    private lazy var toolbar = UIToolbar()
    
    // 表情包数组
    private lazy var packages = EmoticonManager.sharedManager.packages
    
    // MARK: - 监听方法
   @objc private func clickItem(item: UIBarButtonItem) {
        print("选中分类 \(item.tag)")
    
        let tag = item.tag
        let indexPath = IndexPath(item: 0, section: tag)
       // let indexPath = IndexPath(item: 0, section: item.tag)
        print("选中分类indexPath\(indexPath)")
        
        // 滚动 collectionView
        //collectionView.scrollToItem(at: indexPath as IndexPath, at: .left, animated: true)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
 
    // MARK: - 构造函数
    init(selectedEmoticon:@escaping (_ emoticon: Emoticon)->()) {
        // 记录闭包属性
        selectedEmoticonCallBack = selectedEmoticon
        
        // 调用父类的构造函数
        var rect = UIScreen.main.bounds
        rect.size.height = 226
        
        super.init(frame: rect)
        
        backgroundColor = UIColor.white
        
        setupUI()
        
        // 滚动到第一页
//        let indexPath = IndexPath(forItem: 0, inSection: 1)
//        dispatch_async(dispatch_get_main_queue()) { () -> Void in
//            self.collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Left, animated: false)
//        }
        
        // 滚动到第一页
//        let indexPath = IndexPath(item: 0, section: 1)
//        DispatchQueue.main.async {
//                self.collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
//        }
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - 表情布局(类中类－只允许被包含的类使用)
    class EmoticonLayout: UICollectionViewFlowLayout {
        
         override func prepare() {
            super.prepare()
            
            let col: CGFloat = 7
            let row: CGFloat = 3
            
            let w = collectionView!.bounds.width / col
            // 如果在 iPhone 4 的屏幕，只能显示两行
            let margin = CGFloat(Int((collectionView!.bounds.height - row * w) * 0.5))
            
            itemSize = CGSize(width: w, height: w)
            minimumInteritemSpacing = 0
            minimumLineSpacing = 0
            sectionInset = UIEdgeInsets(top: margin, left: 0, bottom: margin, right: 0)
            
            scrollDirection = .horizontal
            
            collectionView?.isPagingEnabled = true
           // collectionView?.bounces = false
            collectionView?.showsHorizontalScrollIndicator = false
            collectionView?.showsHorizontalScrollIndicator = true
            
            
        }
    }
    
    
   
}

private extension EmoticonView {
    
    func setupUI(){
        backgroundColor = UIColor.white
        addSubview(collectionView)
        addSubview(toolbar)
        
        // 2. 自动布局
        toolbar.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(self.snp_bottom)
            make.left.equalTo(self.snp_left)
            make.right.equalTo(self.snp_right)
            make.height.equalTo(44)
        }
        collectionView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.snp_top)
            make.bottom.equalTo(toolbar.snp_top)
            make.left.equalTo(self.snp_left)
            make.right.equalTo(self.snp_right)
        }
        
        //3.设置collectionview的布局
        prepareCollectionView()
        //4.设置toolBar的布局
        prepareToolbar()
        
        
        
    }
    
    
    /// 准备工具栏
    private func prepareToolbar() {
        // 0. tintColor
        toolbar.tintColor = UIColor.darkGray
        //设置按钮内容
        var items = [UIBarButtonItem]()
        var index = 0
//        for s in ["最近","默认","emoji","浪小花"]{
//            items.append(UIBarButtonItem(title: s, style: .plain, target: self, action: #selector(clickItem)))
//            index = index + 1
//            items.last?.tag = index
//            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
//        }
        for p in packages {
//            print(" p.group_name_cn:\( p.group_name_cn)")
//            items.append(UIBarButtonItem(title: p.group_name_cn, style: .plain, target: self, action: #selector(clickItem)))
//            print("items.last?.tag\(items.last?.tag)")
//            items.last?.tag = index
//            index += 1
//            // 添加弹簧
//            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
            
            let item = UIBarButtonItem(title: p.group_name_cn, style: .plain, target: self, action: #selector(clickItem))
            item.tag = index
            index += 1
            items.append(item)
            //添加空格弹簧item
            let flexibleItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            items.append(flexibleItem)
            
        }
    
        items.removeLast()
        toolbar.items = items
 
    }
    
    /// 准备 collectionView
    private func prepareCollectionView() {
        collectionView.backgroundColor = UIColor.lightGray
        
        // 注册 cell
        //collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: EmoticonViewCellId)
        collectionView.register(EmoticonViewCell.self, forCellWithReuseIdentifier: EmoticonViewCellId)
        
        // 设置数据源
        collectionView.dataSource = self
        // 设置代理
        collectionView.delegate = self
    }
    
}


// MARK: - UICollectionViewDataSource
extension EmoticonView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    /// 返回分组数量 － 表情包的数量
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return packages.count
    }

    
    /// 返回每个表情包中的表情数量
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("section:\(packages[section].emoticons.count)")
        return packages[section].emoticons.count
    }
 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmoticonViewCellId, for: indexPath) as! EmoticonViewCell
        //cell.backgroundColor = indexPath.item % 2 == 0 ? UIColor.red : UIColor.green
        //cell.emoticonButton.setTitle("\(indexPath.item)", for: .normal)
        cell.emoticon = packages[indexPath.section].emoticons[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击图标"+String(indexPath.item))
        //1.取出点击的表情
        let em = packages[indexPath.section].emoticons[indexPath.item]
        //2.把取出的表情model插入到最近表情空白列表中
        insertRecentlyEmoticon(emoticon: em)
        //3.闭包回调emoticon表情模型
        selectedEmoticonCallBack(em)
    }
    
    private func insertRecentlyEmoticon(emoticon : Emoticon){
        //1.如果是空白表情或者删除按钮，不需要插入
        if emoticon.isRemoved || emoticon.isEmpty{
            return
        }
        //2.删除重复表情或者空格表情
        if (packages.first!.emoticons.contains(emoticon))
        {
            //原来有该表情
            let index = packages.first?.emoticons.index(of: emoticon)!
            packages.first?.emoticons.remove(at: index!)
            
        }else
        {
            //原来没有这个表情
            packages.first?.emoticons.remove(at: 19)
        }
        //3.将emoticon插入最近分组中
        packages.first?.emoticons.insert(emoticon, at: 0)
    }
    
}





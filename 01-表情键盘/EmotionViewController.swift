//
//  EmoticonViewController.swift
//  表情键盘界面布局
//
//  Created by xiaomage on 15/9/16.
//  Copyright © 2015年 小码哥. All rights reserved.
//


import UIKit

private let XMGEmoticonCellReuseIdentifier = "XMGEmoticonCellReuseIdentifier"
class EmoticonViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.redColor()
        
        // 1.初始化UI
        setupUI()
        
    }
    /**
     初始化UI
     */
    private func setupUI()
    {
        // 1.添加子控件
        view.addSubview(collectionVeiw)
        view.addSubview(toolbar)
        
        // 2.布局子控件
        collectionVeiw.translatesAutoresizingMaskIntoConstraints = false
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        // 提示: 如果想自己封装一个框架, 最好不要依赖其它框架
        var cons = [NSLayoutConstraint]()
        let dict = ["collectionVeiw": collectionVeiw, "toolbar": toolbar]
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[collectionVeiw]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[toolbar]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[collectionVeiw]-[toolbar(44)]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)
        
        view.addConstraints(cons)
    }
    
    func itemClick(item: UIBarButtonItem)
    {
        
    }
    
    // MARK: - 懒加载
    private lazy var collectionVeiw: UICollectionView = {
        let clv = UICollectionView(frame: CGRectZero, collectionViewLayout: EmoticonLayout())
        // 注册cell
        clv.registerClass(EmoticonCell.self, forCellWithReuseIdentifier: XMGEmoticonCellReuseIdentifier)
        clv.dataSource = self
        return clv
    }()
    
    private lazy var toolbar: UIToolbar = {
        let bar = UIToolbar()
        bar.tintColor = UIColor.darkGrayColor()
        var items = [UIBarButtonItem]()
        
        var index = 0
        for title in ["最近", "默认", "emoji", "浪小花"]
        {
            let item = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.Plain, target: self, action: "itemClick:")
            item.tag = index++
            items.append(item)
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        bar.items = items
        return bar
    }()
    
    private lazy var packages: [EmoticonPackage] = EmoticonPackage.loadPackages()
}

extension EmoticonViewController: UICollectionViewDataSource
{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return packages.count
    }
    // 告诉系统每组有多少行
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return packages[section].emoticons?.count ?? 0
    }
    // 告诉系统每行显示什么内容
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionVeiw.dequeueReusableCellWithReuseIdentifier(XMGEmoticonCellReuseIdentifier, forIndexPath: indexPath) as! EmoticonCell
        
        cell.backgroundColor = (indexPath.item % 2 == 0) ? UIColor.redColor() : UIColor.greenColor()
        
        // 1.取出对应的组
        let package = packages[indexPath.section]
        // 2.取出对应组对应行的模型
        let emoticon = package.emoticons![indexPath.item]
        // 3.赋值给cell
        cell.emoticon = emoticon
        
        return cell
    }
}

class EmoticonCell: UICollectionViewCell {
    
    var emoticon: Emoticon?
        {
        didSet{
            // 1.判断是否是图片表情
            if emoticon!.chs != nil
            {
                iconButton.setImage(UIImage(contentsOfFile: emoticon!.imagePath!), forState: UIControlState.Normal)
            }else
            {
                // 防止重用
                iconButton.setImage(nil, forState: UIControlState.Normal)
            }
            
            // 2.设置emoji表情
            // 注意: 加上??可以防止重用
            iconButton.setTitle(emoticon!.emojiStr ?? "", forState: UIControlState.Normal)
            
            // 3.判断是否是删除按钮
            if emoticon!.isRemoveButton
            {
                iconButton.setImage(UIImage(named: "compose_emotion_delete"), forState: UIControlState.Normal)
                iconButton.setImage(UIImage(named: "compose_emotion_delete_highlighted"), forState: UIControlState.Highlighted)
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    /**
     初始化UI
     */
    private func setupUI()
    {
        contentView.addSubview(iconButton)
        iconButton.backgroundColor = UIColor.whiteColor()
        //        iconButton.frame = contentView.bounds
        iconButton.frame = CGRectInset(contentView.bounds, 4, 4)
        
    }
    
    // MARK: - 懒加载
    private lazy var iconButton: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFontOfSize(32)
        return btn
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

/// 自定义布局
class EmoticonLayout: UICollectionViewFlowLayout {
    
    override func prepareLayout() {
        super.prepareLayout()
        // 1.设置cell相关属性
        let width = collectionView!.bounds.width / 7
        itemSize = CGSize(width: width, height: width)
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        // 2.设置collectionview相关属性
        collectionView?.pagingEnabled = true
        collectionView?.bounces = false
        collectionView?.showsHorizontalScrollIndicator = false
        
        // 注意:最好不要乘以0.5, 因为CGFloat不准确, 所以如果乘以0.5在iPhone4/4身上会有问题
        let y = (collectionView!.bounds.height - 3 * width) * 0.45
        collectionView?.contentInset = UIEdgeInsets(top: y, left: 0, bottom: y, right: 0)
        
    }
}

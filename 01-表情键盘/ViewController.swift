//
//  ViewController.swift
//  01-表情键盘
//
//  Created by nimingM on 16/4/6.
//  Copyright © 2016年 蔡凌云. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // 添加自控制器
        addChildViewController(emoticonVC)
        
        // 将表情键盘设置车呼出键盘
        textView.inputView = emoticonVC.view
    }
    
    
    // weak 相当于OC中的 __weak , 特点对象释放之后会将变量设置为nil
    // unowned 相当于OC中的 unsafe_unretained, 特点对象释放之后不会将变量设置为nil
    private lazy var emoticonVC: EmoticonViewController = EmoticonViewController { [unowned self] (emoticon) -> () in
        
        // 1.判断当前点击的是否是emoji表情
        if emoticon.emojiStr != nil{
            self.textView.replaceRange(self.textView.selectedTextRange!, withText: emoticon.emojiStr!)
        }
    }
    
    
    deinit {
        print("控制器被销毁了")
     
    }
}


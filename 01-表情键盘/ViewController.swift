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
        addChildViewController(emotionVc)
        
        // 将表情键盘设置车呼出键盘
        textView.inputView = emotionVc.view
    }
    

    private lazy var emotionVc:EmoticonViewController = EmoticonViewController()
}


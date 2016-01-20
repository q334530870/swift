//
//  publicCommentViewController.swift
//  IDAI360
//
//  Created by YaoJ on 15/12/31.
//  Copyright © 2015年 YaoJ. All rights reserved.
//

import UIKit

class publicCommentViewController: UIViewController {
    
    var productId:Int = 0
    
    @IBOutlet weak var textView: FloatLabelTextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //解决导航栏引起的顶部内容往下bug
        self.automaticallyAdjustsScrollViewInsets = false
        textView.becomeFirstResponder()
        textView.hint = "评论内容"
        textView.hintYPadding = 0
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.5).CGColor
        //添加键盘显示通知，获得键盘高度
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardShouldShow:", name: UIKeyboardDidShowNotification, object: nil)
    }
    
    //键盘出现时获得键盘高度，并让textview向上移动
    func keyboardShouldShow(notification:NSNotification){
        var info:Dictionary = notification.userInfo!
        let size = (info[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size.height)!
        self.textView.contentInset = UIEdgeInsetsMake(0, 0, size, 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //发表评论
    @IBAction func publish(sender: AnyObject) {
        if textView.text == ""{
            Common.showAlert(self, title: nil, message: "请输入评论内容")
            return
        }
        let url = API_URL + "/api/comment"
        let token = Common.getToken()
        let param = ["token":token,"productId":productId,"ct":textView.text]
        self.view.makeToastActivity(position: HRToastPositionCenter, message: "数据加载中")
        Common.doRepuest(self, url: url, method: .POST, param: param  as? [String : AnyObject]) { (response, json) -> Void in
            self.performSegueWithIdentifier("unwindComment", sender: nil)
        }
        
        
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

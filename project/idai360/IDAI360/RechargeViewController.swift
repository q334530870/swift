//
//  RechargeViewController.swift
//  IDAI360
//
//  Created by YaoJ on 16/1/4.
//  Copyright © 2016年 YaoJ. All rights reserved.
//

import UIKit

class RechargeViewController: UIViewController {
    
    @IBOutlet weak var cash: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //支付
    @IBAction func recharge(sender: AnyObject) {
        if cash.text == "" || Double(cash.text!) == nil{
            Common.showAlert(self, title: nil, message: "请输入金额")
        }
        else{
            let url = API_URL + "/api/recharge"
            let token = Common.getToken()
            let param = ["token":token,"amount":cash.text!]
            self.view.makeToastActivity(position: HRToastPositionCenter, message: "数据加载中")
            Common.doRepuest(self, url: url, method: .POST, param: param, failed: nil, complete: { (Response, json) -> Void in
                Common.showAlert(self, title: nil, message: "充值成功") { (action) -> Void in
                    //支付成功
                    self.navigationController?.popViewControllerAnimated(false)
                }
            })
        }
    }
    
    //选择支付方式
    @IBAction func selectType(sender: AnyObject) {
        let tag = sender.tag
        let parent = self.view.viewWithTag(1)
        for v in parent!.subviews{
            if let imageView = v as? UIImageView{
                if imageView.tag > 0 && imageView.tag == tag{
                    imageView.image = UIImage(named: "ok")
                }
                else if imageView.tag > 0 && imageView.tag != tag{
                    imageView.image = UIImage(named: "no-ok")
                }
            }
        }
    }
}

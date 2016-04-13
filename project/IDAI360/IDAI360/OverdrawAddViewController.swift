//
//  OverdrawAddViewController.swift
//  IDAI360
//
//  Created by YaoJ on 16/4/13.
//  Copyright © 2016年 JieYao. All rights reserved.
//

import UIKit

class OverdrawAddViewController: UIViewController {
    
    @IBOutlet weak var amount: FloatLabelTextField!
    
    @IBOutlet weak var number: FloatLabelTextField!
    
    @IBOutlet weak var remark: FloatLabelTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func submit(sender: AnyObject) {
        if amount.text!.isEmpty{
            Common.showAlert(self, title: "", message: "请输入金额")
        }
        else if number.text!.isEmpty{
            Common.showAlert(self, title: "", message: "请输入参考号")
        }
        else{
            let url = API_URL + "/api/Overdraft"
            let token = Common.getToken()
            let param = ["token":token,"creditamount":amount.text,"refno":number.text,"remarks":remark.text]
            self.view.makeToastActivity(position: HRToastPositionCenter, message: "数据加载中")
            Common.doRepuest(self, url: url, method: .POST, param: param, failed: nil) { (response, json) -> Void in
                Common.showAlert(self, title: "", message: json["message"].stringValue, ok: { (action) in
                    self.performSegueWithIdentifier("unwindOverdraw", sender: nil)
                })
            }
            
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

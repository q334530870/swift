//
//  FriendViewController.swift
//  IDAI360
//
//  Created by YaoJ on 16/3/31.
//  Copyright © 2016年 JieYao. All rights reserved.
//

import UIKit

class FriendViewController: UIViewController {
    
    @IBOutlet weak var name: FloatLabelTextField!
    
    @IBOutlet weak var email: FloatLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func submit(sender: AnyObject) {
        if name.text!.isEmpty{
            Common.showAlert(self, title: "", message: "请填写名字")
        }
        else if email.text!.isEmpty || !Common.isEmail(email.text){
            Common.showAlert(self, title: "", message: "请完善邮箱")
        }
        else{
            let url = API_URL + "/api/Invitation"
            let token = Common.getToken()
            let param = ["token":token,"name":name.text!,"mail":email.text!]
            self.view.makeToastActivity(position: HRToastPositionCenter, message: "数据加载中")
            Common.doRepuest(self, url: url, method: .POST, param: param, failed: nil) { (response, json) -> Void in
                Common.showAlert(self, title: "", message: json["message"].stringValue, ok: { (action) in
                    self.name.text = ""
                    self.email.text = ""
                })
            }
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

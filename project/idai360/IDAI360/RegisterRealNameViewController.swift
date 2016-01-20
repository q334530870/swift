//
//  RegisterRealNameViewController.swift
//  IDAI360
//
//  Created by YaoJ on 15/12/30.
//  Copyright © 2015年 YaoJ. All rights reserved.
//

import UIKit

class RegisterRealNameViewController: UIViewController {

    var user = User()
    
    @IBOutlet weak var idCard: UITextField!
    @IBOutlet weak var name: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //下一步
    @IBAction func next(sender: AnyObject) {
        if name.text == ""{
            Common.showAlert(self, title: "", message: "请输入真实姓名")
        }
        else if (idCard.text == "" || !Common.isIdCard(idCard.text)){
            Common.showAlert(self, title: "", message: "请输入真实身份证")
        }
        else{
            //调用实名认证接口
            
            //认证成功
            self.user.name = name.text!
            self.user.idNumber = idCard.text!
            self.performSegueWithIdentifier("Register4", sender: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let registerInfo = segue.destinationViewController as? RegisterInfoViewController
        if registerInfo != nil{
            registerInfo?.user = user
        }
    }
}

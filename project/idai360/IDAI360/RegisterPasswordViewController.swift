//
//  RegisterPasswordViewController.swift
//  IDAI360
//
//  Created by YaoJ on 15/12/11.
//  Copyright © 2015年 YaoJ. All rights reserved.
//

import UIKit

class RegisterPasswordViewController: UIViewController {
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    var user = User()
    var second = 60
    var timer:NSTimer!
    var buttonColor:UIColor!
    
    @IBOutlet weak var yzm: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //临时显示
        codeTextField.text = user.code
        setTimer()
    }
    
    //重新获取验证码
    @IBAction func getCode(sender: AnyObject) {
        let url = API_URL + "/api/sms"
        let param = ["mobile":self.user.cellphone]
        self.view.makeToastActivity(position: HRToastPositionCenter, message: "数据加载中")
        Common.doRepuest(self, url: url, method: Method.GET, param: param){ (response,json) -> Void in
            self.setTimer()
            self.user.code = json["data"].string!
            self.codeTextField.text = self.user.code
        }
    }
    
    //显示或隐藏密码
    @IBAction func showPassword(sender: UIButton) {
        if sender.titleLabel?.text == "显示"{
            password.secureTextEntry = false
            sender.setTitle("隐藏", forState: UIControlState.Normal)
        }
        else{
            password.secureTextEntry = true
            sender.setTitle("显示", forState: UIControlState.Normal)
        }
        
    }
    
    //下一步
    @IBAction func next(sender: AnyObject) {
        if codeTextField.text != self.user.code{
            Common.showAlert(self, title: "", message: "验证码不正确")
        }
        else if (password.text == "" || password.text?.characters.count<6 || password.text?.characters.count>16){
            Common.showAlert(self, title: "", message: "请输入正确的密码")
        }
        else{
            user.password = password.text!
            self.performSegueWithIdentifier("Register3", sender: nil)
        }
    }
    
    //启动计时器
    func setTimer(){
        if(second == 60){
            buttonColor = yzm.titleColorForState(UIControlState.Normal)
            yzm.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            yzm.setTitle("重新获取验证码 \(second)", forState: UIControlState.Normal)
            yzm.enabled = false
            timer?.invalidate()
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(RegisterPasswordViewController.countDown), userInfo: nil, repeats: true)
        }
    }
    
    //计时器更新倒计时
    func countDown(){
        second -= 1
        if second < 1{
            timer.invalidate()
            second = 60
            yzm.setTitleColor(buttonColor, forState: UIControlState.Normal)
            yzm.setTitle("重新获取验证码", forState: UIControlState.Normal)
            yzm.enabled = true
            return
        }
        yzm.setTitle("重新获取验证码 \(second)", forState: UIControlState.Normal)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let registerRealName = segue.destinationViewController as? RegisterRealNameViewController
        if registerRealName != nil{
            registerRealName?.user = user
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

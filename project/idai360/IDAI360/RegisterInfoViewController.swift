//
//  RegisterInfoViewController.swift
//  IDAI360
//
//  Created by YaoJ on 15/12/11.
//  Copyright © 2015年 YaoJ. All rights reserved.
//

import UIKit

class RegisterInfoViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {
    
    var user = User()
    var temp = ["请选择","2000以下","2000~5000","5000~8000","8000~12000","12000~20000","20000以上"]
    
    @IBOutlet weak var pickView: UIPickerView!
    @IBOutlet weak var receive: UITextField!
    @IBOutlet weak var tax: UISegmentedControl!
    @IBOutlet weak var sex: UISegmentedControl!
    @IBOutlet weak var telephone: UITextField!
    @IBOutlet weak var email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        //选择收入
        if textField.restorationIdentifier == "sr"{
            selectReceive()
            return false
        }
        else{
            self.pickView.hidden = true
            return true
        }
    }
    
    //完成注册
    @IBAction func complete(sender: AnyObject) {
        
        if email.text == "" || !Common.isEmail(email.text){
            Common.showAlert(self, title: "", message: "请输入正确的邮箱")
        }
        else if telephone.text == "" || !Common.isTel(telephone.text){
            Common.showAlert(self, title: "", message: "请输入正确的电话号码")
        }
        else if receive.text == ""{
            Common.showAlert(self, title: "", message: "请选择月收入")
        }
        else{
            self.user.email = email.text!
            self.user.homePhone = telephone.text!
            self.user.monthlyIncome = receive.text!
            self.user.gender = sex.selectedSegmentIndex
            self.user.invoiceTypeId = tax.selectedSegmentIndex == 0 ? 2 : 3
            //调用接口完成注册
            let url = API_URL + "/api/users"
            let param = PrintObject.getObjectData(user) as! [String:AnyObject]
            self.view.makeToastActivity(position: HRToastPositionCenter, message: "数据加载中")
            Common.doRepuest(self, url: url, method: Method.POST, param: param){ (response,json) -> Void in
                //注册成功
                Common.saveDefault(json["token"].string!, key: "token")
                Common.saveDefault(json["data"].object, key: "user")
                self.performSegueWithIdentifier("registerUnwind", sender: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //显示收入选择控件
    func selectReceive() {
        pickView.reloadAllComponents()
        pickView.hidden = false
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.temp[row]
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return temp.count
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row>0{
            receive.text = temp[row]
        }
        else{
            receive.text = ""
        }
        pickView.hidden = true
    }
    
    
}

//
//  SafeDetailTableViewController.swift
//  IDAI360
//
//  Created by YaoJ on 16/1/11.
//  Copyright © 2016年 YaoJ. All rights reserved.
//

import UIKit

class SafeDetailTableViewController: UITableViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate{
    
    //选中的行
    var selectCell = SafeType(rawValue: 1)!
    var navTitle:String = ""
    //pickview列表title
    var list:[String]!
    var pickView:UIPickerView?
    //基本信息
    var pickList = [String]()
    var phoneTextField:FloatLabelTextField!
    var srTextField:FloatLabelTextField!
    var sexSeg:UISegmentedControl!
    var billSeg:UISegmentedControl!
    //密码修改
    var oldPwdTextField:FloatLabelTextField!
    var newPwdTextField:FloatLabelTextField!
    var confirmPwdTextField:FloatLabelTextField!
    //实名认证
    var realNameTextField:FloatLabelTextField!
    var idCardTextField:FloatLabelTextField!
    //邮箱认证
    //var emailTextField:FloatLabelTextField!
    //银行卡认证
    var bankNameTextfield:FloatLabelTextField!
    var bankAddressTextfield:FloatLabelTextField!
    var bankCardTextfield:FloatLabelTextField!
    var bankList:Dictionary<String,String>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = navTitle
        //初始化pickView
        self.pickView = Common.initPickView(self, frame: CGRectMake(0,self.view.frame.height / 2,self.view.frame.width,self.view.frame.height / 2))
        self.pickView?.delegate = self
        self.pickView?.dataSource = self
        switch selectCell{
        case SafeType.基本信息:
            
            list = ["家庭电话","月收入","性别","开票方式"]
            pickList = ["请选择","2000以下","2000~5000","5000~8000","8000~12000","12000~20000","20000以上"]
            //调用接口读取数据
            let url = API_URL + "/api/account"
            let token = Common.getToken()
            let param = ["action":"BasicInfo","token":token]
            self.view.makeToastActivity(position: HRToastPositionCenter, message: "数据加载中")
            Common.doRepuest(self, url: url, method: Method.GET, param: param){ (response,json) -> Void in
                //提交成功
                self.phoneTextField.text = json["data"]["homephone"].stringValue
                self.srTextField.text = json["data"]["monthlyincome"].stringValue
                self.sexSeg.selectedSegmentIndex = json["data"]["gender"].intValue
                self.billSeg.selectedSegmentIndex = (json["data"]["invoicetypeid"].intValue == 3 ? 1 : 0)
            }
            
            break
        case SafeType.登录密码:
            
            list = ["原始密码","新密码(6~16位,英文和数字)","确认密码"]
            break
        case SafeType.实名认证:
            
            list = ["真实姓名","身份证号"]
            //调用接口读取数据
            let url = API_URL + "/api/account"
            let token = Common.getToken()
            let param = ["action":"RealNameAuth","token":token]
            self.view.makeToastActivity(position: HRToastPositionCenter, message: "数据加载中")
            Common.doRepuest(self, url: url, method: Method.GET, param: param){ (response,json) -> Void in
                //提交成功
                self.realNameTextField.text = json["data"]["realname"].string
                self.idCardTextField.text = json["data"]["idnumber"].stringValue
            }
            
            break
            //            case 3:
            //                list = ["邮箱地址"]
        //
        case SafeType.银行卡绑定:
            
            list = ["开户银行","开户网点","银行卡号"]
            bankList = ["中国工商银行":"ICBC","中国建设银行":"CCB","招商银行":"CMB","中国农业银行":"ABC","广发银行":"GDB",
                        "中国银行":"BOC","中国民生银行":"CMBC","交通银行":"CIB","中国光大银行":"BCM"]
            pickList.append("请选择")
            for key in (bankList?.keys)!{
                pickList.append(key)
            }
            //调用接口读取数据
            let url = API_URL + "/api/account"
            let token = Common.getToken()
            let param = ["action":"BankCardAuth","token":token]
            self.view.makeToastActivity(position: HRToastPositionCenter, message: "数据加载中")
            Common.doRepuest(self, url: url, method: Method.GET, param: param){ (response,json) -> Void in
                //提交成功
                self.bankCardTextfield.text = json["data"]["account"].string
                self.bankNameTextfield.text = self.getBankName(json["data"]["bankname"].stringValue)
                self.bankAddressTextfield.text = json["data"]["bankaddress"].string
            }
            break
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
    }
    
    func getBankName(value:String) ->String{
        var key = ""
        for (k,v) in bankList!{
            if v == value{
                key = k
                break
            }
        }
        return key
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func complete(sender: AnyObject) {
        switch selectCell{
        case SafeType.基本信息:
            
            if phoneTextField.text == "" || !Common.isTel(phoneTextField.text){
                Common.showAlert(self, title: "", message: "请输入正确的电话号码")
            }
            else if srTextField.text == ""{
                Common.showAlert(self, title: "", message: "请选择月收入")
            }
            else{
                let homePhone = phoneTextField.text!
                let monthlyIncome = srTextField.text!
                let gender = sexSeg.selectedSegmentIndex
                let invoiceTypeId = billSeg.selectedSegmentIndex == 0 ? 2 : 3
                //调用接口完成注册
                let url = API_URL + "/api/account"
                let token = Common.getToken()
                let param = ["token":token,"action":"BasicInfo","homephone":homePhone,"monthlyincome":monthlyIncome,"gender":gender,"invoicetypeid":invoiceTypeId]
                self.view.makeToastActivity(position: HRToastPositionCenter, message: "数据加载中")
                Common.doRepuest(self, url: url, method: Method.POST, param: param as? [String : AnyObject]){ (response,json) -> Void in
                    //修改成功
                    self.navigationController?.popViewControllerAnimated(true)
                }
                
            }
        case SafeType.登录密码:
            
            if oldPwdTextField.text == ""{
                Common.showAlert(self, title: "", message: "请输入原始密码")
            }
            else if (newPwdTextField.text == "" || newPwdTextField.text?.characters.count<6 || newPwdTextField.text?.characters.count>16){
                Common.showAlert(self, title: "", message: "请输入正确的新密码")
            }
            else if newPwdTextField.text != confirmPwdTextField.text{
                Common.showAlert(self, title: "", message: "两次密码输入不一致")
            }
            else{
                let oldPassword = oldPwdTextField.text!
                let newPassword = newPwdTextField.text!
                //调用接口完成注册
                let url = API_URL + "/api/account"
                let token = Common.getToken()
                let param = ["token":token,"action":"ChangePassword","oldpassword":oldPassword,"newpassword":newPassword]
                self.view.makeToastActivity(position: HRToastPositionCenter, message: "数据加载中")
                Common.doRepuest(self, url: url, method: Method.POST, param: param){ (response,json) -> Void in
                    //修改成功
                    self.navigationController?.popViewControllerAnimated(true)
                    
                }
            }
            break
        case SafeType.实名认证:
            
            if realNameTextField.text == ""{
                Common.showAlert(self, title: "", message: "请输入真实姓名")
            }
            else if idCardTextField.text == ""{
                Common.showAlert(self, title: "", message: "请输入身份证号")
            }
            else{
                let realName = realNameTextField.text!
                let idcard = idCardTextField.text!
                //调用接口完成注册
                let url = API_URL + "/api/account"
                let token = Common.getToken()
                let param = ["action":"RealNameAuth","token":token,"realname":realName,"idnumber":idcard]
                self.view.makeToastActivity(position: HRToastPositionCenter, message: "数据加载中")
                Common.doRepuest(self, url: url, method: Method.POST, param: param){ (response,json) -> Void in
                    //提交成功
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
            break
            //邮箱认证
            //        case 3:
            //            if emailTextField.text == "" || !Common.isEmail(emailTextField.text){
            //                Common.showAlert(self, title: "", message: "请输入正确的邮箱")
            //            }
            //            else{
            //                //let email = emailTextField.text
            //                //调用接口完成注册
            //                //            let url = API_URL + "/api/users"
            //                //            let param = ["email":email]
            //                //            self.view.makeToastActivity(position: HRToastPositionCenter, message: "数据加载中")
            //                //            Common.doRepuest(self, url: url, method: Method.POST, param: param as! [String : AnyObject]){ (response,json) -> Void in
            //                //                //提交成功
            //                //                self.navigationController?.popViewControllerAnimated(true)
            //                //
            //
            //            }
        //            break
        case SafeType.银行卡绑定:
            
            if bankNameTextfield.text == "" {
                Common.showAlert(self, title: "", message: "请选择开户银行")
            }
            else if bankAddressTextfield.text == "" {
                Common.showAlert(self, title: "", message: "请输入开户网点")
            }
            else if bankCardTextfield.text == "" || !Common.isBankCard(bankCardTextfield.text!) {
                Common.showAlert(self, title: "", message: "请输入正确的银行卡号")
            }
            else{
                let bankName = bankList![bankNameTextfield.text!]!
                let bankAddress = bankAddressTextfield.text!
                let bankCard = bankCardTextfield.text!
                //调用接口完成注册
                let url = API_URL + "/api/account"
                let token = Common.getToken()
                let param = ["action":"BankCardAuth","token":token,"bankname":bankName,"bankaddress":bankAddress,"account":bankCard]
                self.view.makeToastActivity(position: HRToastPositionCenter, message: "数据加载中")
                Common.doRepuest(self, url: url, method: Method.POST, param: param){ (response,json) -> Void in
                    //提交成功
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
            break
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ScrollCell", forIndexPath: indexPath)
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        let imageView = UIImageView(frame: CGRectMake(15, (cell.frame.height-24)/2, 24, 24))
        cell.contentView.addSubview(imageView)
        switch selectCell{
        case SafeType.基本信息:
            
            let sex = ["女","男"]
            let bill = ["营业税","增值税"]
            switch indexPath.row{
            case 0:
                imageView.image = UIImage(named: "phone")
                phoneTextField = FloatLabelTextField(frame: CGRectMake(50, 5, cell.frame.width-60, cell.frame.height-10))
                phoneTextField.placeholder = list[indexPath.row]
                phoneTextField.font = UIFont.systemFontOfSize(14)
                phoneTextField.clearButtonMode = .Always
                phoneTextField.delegate = self
                phoneTextField.returnKeyType = .Done
                cell.contentView.addSubview(phoneTextField)
                break
            case 1:
                imageView.image = UIImage(named: "money")
                srTextField = FloatLabelTextField(frame: CGRectMake(50, 5, cell.frame.width-60, cell.frame.height-10))
                srTextField.placeholder = list[indexPath.row]
                srTextField.restorationIdentifier = "sr"
                srTextField.font = UIFont.systemFontOfSize(14)
                srTextField.clearButtonMode = .Always
                srTextField.tag = 66
                srTextField.delegate = self
                cell.contentView.addSubview(srTextField)
                break
            case 2:
                imageView.image = UIImage(named: "sex")
                sexSeg = UISegmentedControl(items: sex)
                sexSeg.frame = CGRectMake(50, 7, 60, cell.frame.height - 14)
                sexSeg.selectedSegmentIndex = 1
                sexSeg.tintColor = MAIN_COLOR
                cell.contentView.addSubview(sexSeg)
                break
            case 3:
                imageView.image = UIImage(named: "bill")
                billSeg = UISegmentedControl(items: bill)
                billSeg.frame = CGRectMake(50, 7, 150, cell.frame.height - 14)
                billSeg.selectedSegmentIndex = 0
                billSeg.tintColor = MAIN_COLOR
                cell.contentView.addSubview(billSeg)
                break
            default:
                break
            }
            break
        case SafeType.登录密码:
            
            switch indexPath.row{
            case 0:
                imageView.image = UIImage(named: "password")
                oldPwdTextField = FloatLabelTextField(frame: CGRectMake(50, 5, cell.frame.width-60, cell.frame.height-10))
                oldPwdTextField.placeholder = list[indexPath.row]
                oldPwdTextField.font = UIFont.systemFontOfSize(14)
                oldPwdTextField.clearButtonMode = .Always
                oldPwdTextField.returnKeyType = .Done
                oldPwdTextField.secureTextEntry = true
                oldPwdTextField.delegate = self
                cell.contentView.addSubview(oldPwdTextField)
                break
            case 1:
                imageView.image = UIImage(named: "password")
                newPwdTextField = FloatLabelTextField(frame: CGRectMake(50, 5, cell.frame.width-60, cell.frame.height-10))
                newPwdTextField.placeholder = list[indexPath.row]
                newPwdTextField.font = UIFont.systemFontOfSize(14)
                newPwdTextField.clearButtonMode = .Always
                newPwdTextField.returnKeyType = .Done
                newPwdTextField.secureTextEntry = true
                newPwdTextField.delegate = self
                cell.contentView.addSubview(newPwdTextField)
                break
            case 2:
                imageView.image = UIImage(named: "password")
                confirmPwdTextField = FloatLabelTextField(frame: CGRectMake(50, 5, cell.frame.width-60, cell.frame.height-10))
                confirmPwdTextField.placeholder = list[indexPath.row]
                confirmPwdTextField.font = UIFont.systemFontOfSize(14)
                confirmPwdTextField.clearButtonMode = .Always
                confirmPwdTextField.returnKeyType = .Done
                confirmPwdTextField.secureTextEntry = true
                confirmPwdTextField.delegate = self
                cell.contentView.addSubview(confirmPwdTextField)
                break
            default:
                break
            }
            break
        case SafeType.实名认证:
            
            switch indexPath.row{
            case 0:
                imageView.image = UIImage(named: "user")
                realNameTextField = FloatLabelTextField(frame: CGRectMake(50, 5, cell.frame.width-60, cell.frame.height-10))
                realNameTextField.placeholder = list[indexPath.row]
                realNameTextField.font = UIFont.systemFontOfSize(14)
                realNameTextField.clearButtonMode = .Always
                realNameTextField.returnKeyType = .Done
                realNameTextField.delegate = self
                cell.contentView.addSubview(realNameTextField)
                break
            case 1:
                imageView.image = UIImage(named: "idcard")
                idCardTextField = FloatLabelTextField(frame: CGRectMake(50, 5, cell.frame.width-60, cell.frame.height-10))
                idCardTextField.placeholder = list[indexPath.row]
                idCardTextField.font = UIFont.systemFontOfSize(14)
                idCardTextField.clearButtonMode = .Always
                idCardTextField.returnKeyType = .Done
                idCardTextField.delegate = self
                cell.contentView.addSubview(idCardTextField)
                break
            default:
                break
            }
            break
            //邮箱认证
            //        case 3:
            //            imageView.image = UIImage(named: "email")
            //            emailTextField = FloatLabelTextField(frame: CGRectMake(50, 5, cell.frame.width-60, cell.frame.height-10))
            //            emailTextField.placeholder = list[indexPath.row]
            //            emailTextField.font = UIFont.systemFontOfSize(14)
            //            emailTextField.clearButtonMode = .Always
            //            emailTextField.returnKeyType = .Done
            //            emailTextField.delegate = self
            //            cell.contentView.addSubview(emailTextField)
        //            break
        case SafeType.银行卡绑定:
            
            switch indexPath.row{
            case 0:
                imageView.image = UIImage(named: "bankName")
                bankNameTextfield = FloatLabelTextField(frame: CGRectMake(50, 5, cell.frame.width-60, cell.frame.height-10))
                bankNameTextfield.placeholder = list[indexPath.row]
                bankNameTextfield.font = UIFont.systemFontOfSize(14)
                bankNameTextfield.restorationIdentifier = "sr"
                bankNameTextfield.tag = 66
                bankNameTextfield.clearButtonMode = .Always
                bankNameTextfield.returnKeyType = .Done
                bankNameTextfield.delegate = self
                cell.contentView.addSubview(bankNameTextfield)
                break
            case 1:
                imageView.image = UIImage(named: "bankAddress")
                bankAddressTextfield = FloatLabelTextField(frame: CGRectMake(50, 5, cell.frame.width-60, cell.frame.height-10))
                bankAddressTextfield.placeholder = list[indexPath.row]
                bankAddressTextfield.font = UIFont.systemFontOfSize(14)
                bankAddressTextfield.clearButtonMode = .Always
                bankAddressTextfield.returnKeyType = .Done
                bankAddressTextfield.delegate = self
                cell.contentView.addSubview(bankAddressTextfield)
                break
            case 2:
                imageView.image = UIImage(named: "bankCard")
                bankCardTextfield = FloatLabelTextField(frame: CGRectMake(50, 5, cell.frame.width-60, cell.frame.height-10))
                bankCardTextfield.placeholder = list[indexPath.row]
                bankCardTextfield.font = UIFont.systemFontOfSize(14)
                bankCardTextfield.clearButtonMode = .Always
                bankCardTextfield.returnKeyType = .Done
                bankCardTextfield.delegate = self
                cell.contentView.addSubview(bankCardTextfield)
                break
            default:
                break
            }
            break
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        //选择收入/银行
        if textField.restorationIdentifier == "sr"{
            self.view.endEditing(true)
            selectReceive()
            return false
        }
        else{
            self.pickView!.superview!.superview!.hidden = true
            return true
        }
    }
    
    //显示收入选择控件
    func selectReceive() {
        pickView!.reloadAllComponents()
        self.pickView!.superview!.superview!.hidden = false
        if let scale = pickView!.pop_animationForKey("popSafePickView") as? POPSpringAnimation{
            scale.fromValue = NSValue(CGRect: CGRectMake(pickView!.frame.origin.x,self.view.frame.height,self.pickView!.frame.width,pickView!.frame.height))
        }
        else{
            let scale = POPSpringAnimation(propertyNamed: kPOPViewFrame)
            scale.fromValue = NSValue(CGRect: CGRectMake(pickView!.frame.origin.x,self.view.frame.height,self.pickView!.frame.width,pickView!.frame.height))
            scale.springBounciness = 20
            scale.springSpeed = 20
            pickView!.superview!.pop_addAnimation(scale, forKey: "popSafePickView")
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickList[row]
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickList.count
    }
    
    func selectSeg(){
        let textField = self.view.viewWithTag(66) as! UITextField
        let row = pickView?.selectedRowInComponent(0)
        if row>0{
            textField.text = pickList[row!]
        }
        else{
            textField.text = ""
        }
        self.pickView!.superview!.superview!.hidden = true
    }
    
}

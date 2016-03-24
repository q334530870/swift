//
//  GatherSellTableViewController.swift
//  IDAI360
//
//  Created by YaoJ on 16/2/16.
//  Copyright © 2016年 YaoJ. All rights reserved.
//

import UIKit

class GatherSellTableViewController: UITableViewController,UITextFieldDelegate {
    var titleList:[String]?
    var result:[JSON]?
    var productList = [(title:"请选择",value:"")]
    var detail:JSON?
    var product:JPick?
    var tk:JPick?
    var startDate:JDatePick?
    var endDate:JDatePick?
    var defaultCount = 1
    var selectedName = ""
    var selectedId = ""
    var bl:UITextField?
    var tempValue = Dictionary<Int,String>()
    var tkValue = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //初始化pickView
        product = JPick(controller:self, target: self.tableView,textField:UITextField(),height:200)
        tk = JPick(controller:self,target: self.tableView,textField:UITextField())
        startDate = JDatePick(controller:self,target: self.tableView, textField: UITextField())
        endDate = JDatePick(controller:self,target: self.tableView, textField: UITextField())
        
        getProduct()
        titleList = ["请选择出售产品","1-是否初次发行？","2-是否接受T+1交易（全款24小时内付清）？","3-是否接受集合竞价交易？","4-认购下单，可接受支付的选项（单选）","交易条款","条款比例（%）","出售数量/片","过息利息金额","最低收益率（%）","竞价开始日期","竞价结束日期"]
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        product?.setOffset(scrollView.contentOffset.y)
        tk?.setOffset(scrollView.contentOffset.y)
        startDate?.setOffset(scrollView.contentOffset.y)
        endDate?.setOffset(scrollView.contentOffset.y)
    }
    
    //获取产品列表
    func getProduct(){
        let url = API_URL + "/api/Transaction"
        let token = Common.getToken()
        let param = ["token":token,"type":"2"]
        self.view.makeToastActivity(position: HRToastPositionCenter, message: "数据加载中")
        Common.doRepuest(self, url: url, method: .GET, param: param) { (response, json) -> Void in
            self.result = json["data"].array!
            var i = 0
            for r in self.result!{
                self.productList.append((r["产品"].stringValue,"\(i)"))
                i += 1
            }
            //绑定产品数据
            self.product!.pickList = self.productList
        }
    }
    
    //获得产品明细
    func productDetail(){
        let pt = result![Int(selectedId)!]
        let url = API_URL + "/api/Transaction"
        let token = Common.getToken()
        let param = ["token":token,"productId":pt["product_factor_rental_id"].stringValue,
                     "seniority":pt["seniority"].stringValue,"isinitialissue":pt["isinitialissue"].stringValue,"type":"2"]
        self.view.makeToastActivity(position: HRToastPositionCenter, message: "数据加载中")
        Common.doRepuest(self, url: url, method: .GET, param: param) { (response, json) -> Void in
            //绑定默认数据
            self.detail = json["data"]
            if  self.detail!["IsInitialIssue"].stringValue == "1"{
                self.tk!.pickList = [("请选择",""),("（T+1）首付款","2"),("（T+1）全款","3")]
            }
            else{
                self.tk!.pickList = [("请选择",""),("（T+1）保证金","1"),("（T+1）首付款","2"),("（T+1）全款","3"),("（T+0）全款","4")]
            }
            let term = self.tk?.pickList.filter({ (ft:(title: String, value: String)) -> Bool in
                return ft.value == self.detail!["OrderTerms"].stringValue
            })[0].title
            self.tempValue[0] = self.selectedName
            self.tempValue[1] = self.detail!["IsInitialIssue"].stringValue
            self.tempValue[2] = self.detail!["IsTradeConditionalAcceptable"].stringValue
            self.tempValue[3] = self.detail!["IsAutoMatchAcceptable"].stringValue
            self.tempValue[4] = self.detail!["IsBuyAgainstDepositAllowed"].stringValue
            self.tempValue[5] = term
            self.tempValue[6] = self.detail!["OrderTerms"].stringValue == "1" ? self.detail!["EarnestMoneyRatio"].stringValue : self.detail!["DepositRatio"].stringValue
            self.tempValue[7] = self.detail!["UnitsToSell"].stringValue
            self.tempValue[8] = self.detail!["EarnedInterestToSell"].stringValue
            self.tempValue[9] = self.detail!["IrrForQuotation"].stringValue
            self.tempValue[10] = Common.stringDateFromString(self.detail!["BidStartDatetime"].stringValue,fmt: "yyyy-MM-dd")
            self.tempValue[11] = Common.stringDateFromString(self.detail!["BidEndDatetime"].stringValue,fmt: "yyyy-MM-dd")
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return defaultCount
    }
    
    func selectSeg(button:UIButton){
        //选择产品
        if button == product?.pickButton{
            tempValue.removeAll()
            let value = product?.selectSeg(button)
            if (value?.isEmpty == false){
                defaultCount = (titleList?.count)!
                selectedName = (product?.textField?.text)!
                selectedId = value!
                productDetail()
            }
            else{
                defaultCount = 1
                selectedName = ""
                selectedId = ""
                tkValue = ""
                self.tableView.reloadData()
            }
        }
            //选择交易条款
        else if button == tk?.pickButton{
            let value = tk?.selectSeg(button)
            tempValue[(tk?.textField?.tag)!] = tk?.textField?.text
            tkValue = value!
            if value?.isEmpty == false{
                switch value!{
                case "3","4":
                    bl?.text = "100"
                    tempValue[(bl?.tag)!] = "100"
                    bl?.enabled = false
                    break
                default:
                    bl?.text = ""
                    bl?.enabled = true
                    break
                }
            }
            else{
                bl?.text = ""
            }
        }
            //选择时间
        else{
            if button == startDate?.pickButton{
                startDate?.selectSeg(button)
                tempValue[(startDate?.textField?.tag)!] = startDate?.textField?.text
            }
            else if button == endDate?.pickButton{
                endDate?.selectSeg(button)
                tempValue[(endDate?.textField?.tag)!] = endDate?.textField?.text
            }
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ScrollCell", forIndexPath: indexPath)
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        //多选项
        if indexPath.row > 0 && indexPath.row < 5{
            let titleLabel = UILabel(frame: CGRectMake(15,3,cell.width-50,cell.height-6))
            titleLabel.font = UIFont.systemFontOfSize(14)
            titleLabel.text = titleList![indexPath.row]
            titleLabel.textColor = UIColor.grayColor()
            let imageView = UIImageView(frame: CGRectMake(cell.width - 44,(cell.height-24)/2,24,24))
            var imageName = "no-ok"
            if tempValue.count>0{
                if  tempValue[indexPath.row] == "1"{
                    imageName = "ok"
                }
            }
            //初次发行
            if indexPath.row == 1{
                titleLabel.textColor = UIColor.lightGrayColor()
                imageView.alpha = 0.5
            }
            imageView.image = UIImage(named: imageName)
            cell.contentView.addSubview(titleLabel)
            cell.contentView.addSubview(imageView)
        }
        else{
            let textField = FloatLabelTextField(frame: CGRectMake(15,3,cell.width-20,cell.height-6))
            textField.font = UIFont.systemFontOfSize(14)
            textField.placeholder = titleList![indexPath.row]
            textField.tag = indexPath.row
            cell.contentView.addSubview(textField)
            if tempValue.count>0{
                textField.text = tempValue[indexPath.row]
            }
            //比例输入框赋值
            if titleList![indexPath.row] == "条款比例（%）"{
                bl = textField
            }
            //产品项
            if indexPath.row == 0{
                if !selectedName.isEmpty{
                    textField.text = selectedName
                }
                //初始化选择框
                product?.initTextField(textField)
            }
                //交易条款项
            else if indexPath.row == 5{
                //初始化选择框
                tk?.initTextField(textField)
            }
            else if indexPath.row == 10{
                startDate?.initTextField(textField)
            }
            else if indexPath.row == 11{
                endDate?.initTextField(textField)
            }
            else{
                textField.keyboardType = .NumbersAndPunctuation
                textField.returnKeyType = .Done
                textField.delegate = self
            }
        }
        return cell
    }
    
    //点击done后隐藏键盘
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //输入内容临时存储，避免表格滚动时数据消失
    func textFieldDidEndEditing(textField: UITextField) {
        let tag = textField.tag
        tempValue[tag] = textField.text
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let tag = textField.tag
        tempValue[tag] = textField.text
        return true
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //多选项的选中和取消选中设置
        if indexPath.row > 1 && indexPath.row < 5{
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            var stat = "True"
            for v in (cell?.contentView.subviews)!{
                if let imageView = v as? UIImageView{
                    if imageView.image == UIImage(named: "no-ok"){
                        imageView.image = UIImage(named: "ok")
                        stat = "1"
                    }
                    else{
                        imageView.image = UIImage(named: "no-ok")
                        stat = "0"
                    }
                }
            }
            tempValue[indexPath.row] = stat
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    @IBAction func submit(sender: AnyObject) {
        if selectedName == ""{
            Common.showAlert(self, title: "", message: "请选择产品")
        }
        else{
            let url = API_URL + "/api/Transaction"
            let token = Common.getToken()
            var param = ["token":token]
            param["type"] = "2"
            param["orderterms"] = self.tk?.pickList.filter({ (ft:(title: String, value: String)) -> Bool in
                return ft.title == tempValue[5]
            })[0].value
            if param["orderterms"]! == "1"{
                param["earnestmoneyratio"] = tempValue[6]
            }
            else if param["orderterms"]! == "2"{
                param["depositratio"] = tempValue[6]
            }
            param["isinitialissue"] = tempValue[1]
            param["tvalue"] = "t1"
            param["productid"] = detail!["ProductFactorRentalId"].stringValue
            param["seniority"] = detail!["Seniority"].stringValue
            param["unitstosell"] = tempValue[7]
            param["irrforquotation"] = tempValue[9]
            //        param["istradeconditionalacceptable"] = tempValue[2]
            param["isautomatchacceptable"] = tempValue[3]
            param["isbuyagainstdepositallowed"] = tempValue[4]
            param["earnedinteresttosell"] = tempValue[8]
            param["bidstartdatetime"] = tempValue[10]
            param["bidenddatetime"] = tempValue[11]
            self.view.makeToastActivity(position: HRToastPositionCenter, message: "数据加载中")
            Common.doRepuest(self, url: url, method: .POST, param: param) { (response, json) -> Void in
                //绑定默认数据
                Common.showAlert(self, title: "", message: "提交成功", ok: { (action) in
                    self.performSegueWithIdentifier("unwindSell", sender: nil)
                })
            }
        }
    }
}

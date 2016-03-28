//
//  GatherSellTableViewController.swift
//  IDAI360
//
//  Created by YaoJ on 16/2/16.
//  Copyright © 2016年 YaoJ. All rights reserved.
//

import UIKit

class GatherBuyTableViewController: UITableViewController,UITextFieldDelegate {
    var titleList:[String]?
    var result:[JSON]?
    var productList = [(title:"请选择",value:"")]
    var detail:JSON?
    
    var product:JPick?
    var startDate:JDatePick?
    var endDate:JDatePick?
    var defaultCount = 1
    var selectedName = ""
    var selectedId = ""
    var tempValue = Dictionary<Int,String>()
    var selectTK = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        product = JPick(controller:self, target: self.tableView,textField:UITextField(),height:200)
        startDate = JDatePick(controller:self,target: self.tableView, textField: UITextField())
        endDate = JDatePick(controller:self,target: self.tableView, textField: UITextField())
        
        getProduct()
        titleList = ["点击选择买入产品","1-是否接受初次发行？","2-是否接受T+1交易（全款24小时内付清）？","3-是否接受集合竞价交易？","4-是否是发行人的回购？","5-认购下单，可接受支付的选项（可多选）","(T+1) 保证金","(T+1) 首付款","(T+1) 全款","(T+0) 全款","购买数量/片","过息利息金额","最低收益率（%）","竞价开始日期","竞价结束日期"]
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        product?.setOffset(scrollView.contentOffset.y)
        startDate?.setOffset(scrollView.contentOffset.y)
        endDate?.setOffset(scrollView.contentOffset.y)
    }
    
    //获取产品列表
    func getProduct(){
        let url = API_URL + "/api/Transaction"
        let token = Common.getToken()
        let param = ["token":token,"type":"3"]
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
                     "seniority":pt["seniority"].stringValue,"type":"3"]
        self.view.makeToastActivity(position: HRToastPositionCenter, message: "数据加载中")
        Common.doRepuest(self, url: url, method: .GET, param: param) { (response, json) -> Void in
            //绑定默认数据
            self.detail = json["data"]
            let terms = self.detail!["ProductToBuyDetailOrderTerms"].array
            for t in terms!{
                self.selectTK.append(t["OrderTermsAcceptable"].stringValue)
            }
            self.tempValue[0] = self.selectedName
            self.tempValue[1] = self.detail!["IsInitialIssueAcceptable"].stringValue
            self.tempValue[2] = self.detail!["IsTradeConditionalAcceptable"].stringValue
            self.tempValue[3] = self.detail!["IsAutoMatchAcceptable"].stringValue
            self.tempValue[4] = self.detail!["IsIssuerBuyback"].stringValue
            self.tempValue[5] = self.detail!["IsBuyAgainstDepositAllowed"].stringValue
            self.tempValue[6] = self.detail!["EarnestMoneyRatioUpperLimit"].stringValue
            self.tempValue[7] = self.detail!["DepositRatioUpperLimit"].stringValue
            self.tempValue[8] = "100"
            self.tempValue[9] = "100"
            self.tempValue[10] = self.detail!["UnitsToBuy"].stringValue
            self.tempValue[11] = self.detail!["EarnedInterestToBuy"].stringValue
            self.tempValue[12] = self.detail!["IrrForQuotation"].stringValue
            self.tempValue[13] = Common.stringDateFromString(self.detail!["BidStartDatetime"].stringValue,fmt: "yyyy-MM-dd")
            self.tempValue[14] = Common.stringDateFromString(self.detail!["BidEndDatetime"].stringValue,fmt: "yyyy-MM-dd")
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
                self.tableView.reloadData()
            }
            
        }
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
        if indexPath.row > 0 && indexPath.row < 6{
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
            imageView.image = UIImage(named: imageName)
            cell.contentView.addSubview(titleLabel)
            cell.contentView.addSubview(imageView)
        }
        else{
            let textField = FloatLabelTextField(frame: CGRectMake(15,3,cell.width-20,cell.height-6))
            textField.font = UIFont.systemFontOfSize(14)
            textField.placeholder = titleList![indexPath.row]
            if(indexPath.row == 0){
                textField.font = UIFont.systemFontOfSize(18)
            }
            textField.tag = indexPath.row
            cell.contentView.addSubview(textField)
            if tempValue.count>0{
                textField.text = tempValue[indexPath.row]
            }
            if indexPath.row == 0{
                if !selectedName.isEmpty{
                    textField.text = selectedName
                }
                //初始化选择框
                product?.initTextField(textField)
            }
            else if indexPath.row > 5 && indexPath.row < 10{
                textField.frame = CGRectMake(15,3,cell.width-100,cell.height-6)
                textField.keyboardType = .NumbersAndPunctuation
                textField.returnKeyType = .Done
                textField.delegate = self
                textField.enabled = false
                let imageView = UIImageView(frame: CGRectMake(cell.width - 44,(cell.height-24)/2,24,24))
                var imageName = "no-ok"
                if tempValue.count>0{
                    var termValue = 0
                    switch titleList![indexPath.row] {
                    case "(T+1) 保证金":
                        termValue = 1
                        break
                    case "(T+1) 首付款":
                        termValue = 2
                        break
                    case "(T+1) 全款":
                        termValue = 3
                        break
                    case "(T+0) 全款":
                        termValue = 4
                        break
                    default:
                        break
                    }
                    if self.selectTK.contains("\(termValue)"){
                        imageName = "ok"
                        if indexPath.row != 8 && indexPath.row != 9{
                            textField.enabled = true
                        }
                    }
                }
                imageView.image = UIImage(named: imageName)
                cell.contentView.addSubview(imageView)
            }
            else if indexPath.row == 13{
                startDate?.initTextField(textField)
            }
            else if indexPath.row == 14{
                endDate?.initTextField(textField)
            }
            else{
                textField.keyboardType = .NumbersAndPunctuation
                textField.returnKeyType = .Done
                textField.delegate = self
            }
            if indexPath.row >= 10 && indexPath.row <= 12{
                textField.titleTextColour = MAIN_COLOR
            }
        }
        return cell
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        let tag = textField.tag
        tempValue[tag] = textField.text
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let tag = textField.tag
        tempValue[tag] = textField.text! + string
        return true
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row > 0 && indexPath.row < 6){
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
        else if (indexPath.row > 5 && indexPath.row < 10){
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            var termValue = 0
            switch titleList![indexPath.row] {
            case "(T+1) 保证金":
                termValue = 1
                break
            case "(T+1) 首付款":
                termValue = 2
                break
            case "(T+1) 全款":
                termValue = 3
                break
            case "(T+0) 全款":
                termValue = 4
                break
            default:
                break
            }
            for v in (cell?.contentView.subviews)!{
                if let imageView = v as? UIImageView{
                    if imageView.image == UIImage(named: "no-ok"){
                        imageView.image = UIImage(named: "ok")
                        selectTK.append("\(termValue)")
                        if let textField = self.view.viewWithTag(indexPath.row) as? UITextField{
                            textField.enabled = true
                            switch indexPath.row{
                            case 8,9:
                                textField.text = "100"
                                tempValue[indexPath.row] = "100"
                                textField.enabled = false
                                break
                            default:
                                tempValue[indexPath.row] = ""
                                textField.becomeFirstResponder()
                                break
                            }
                        }
                        
                    }
                    else{
                        selectTK.removeAtIndex(selectTK.indexOf("\(termValue)")!)
                        imageView.image = UIImage(named: "no-ok")
                        if let textField = self.view.viewWithTag(indexPath.row) as? UITextField{
                            textField.enabled = false
                            textField.text = ""
                            tempValue[indexPath.row] = ""
                            
                        }
                    }
                }
            }
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
            param["type"] = "3"
            param["orderterms"] = self.selectTK.joinWithSeparator("|")
            param["depositratioupperlimit"] = tempValue[6]
            param["earnestmoneyratioupperlimit"] = tempValue[7]
            param["isinitialissueacceptable"] = tempValue[1]
            param["istradeconditionalacceptable"] = tempValue[2]
            param["isautomatchacceptable"] = tempValue[3]
            param["isissuerbuyback"] = tempValue[4]
            //        param["isbuyagainstdepositallowed"] = tempValue[5]
            param["productid"] = detail!["ProductFactorRentalId"].stringValue
            param["seniority"] = detail!["Seniority"].stringValue
            param["unitstobuy"] = tempValue[10]
            param["earnedinteresttobuy"] = tempValue[11]
            param["irrforquotation"] = tempValue[12]
            param["bidstartdatetime"] = tempValue[13]
            param["bidenddatetime"] = tempValue[14]
            self.view.makeToastActivity(position: HRToastPositionCenter, message: "数据加载中")
            Common.doRepuest(self, url: url, method: .POST, param: param) { (response, json) -> Void in
                //绑定默认数据
                Common.showAlert(self, title: "", message: "提交成功", ok: { (action) in
                    self.performSegueWithIdentifier("unwindBuy", sender: nil)
                })
            }
        }
    }
    
}

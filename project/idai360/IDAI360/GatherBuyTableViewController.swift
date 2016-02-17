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
    var product:JPick?
    var tk:JPick?
    var startDate:JDatePick?
    var endDate:JDatePick?
    var defaultCount = 1
    var selectedName = ""
    var bl:UITextField?
    var tempValue = Dictionary<Int,String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleList = ["出售产品","1-是否接受初次发行？","2-是否接受T+1交易（全款24小时内付清）？","3-是否接受集合竞价交易？","4-是否是发行人的回购？","5-认购下单，可接受支付的选项（可多选）","(T+1) 保证金","(T+1) 首付款","(T+1) 全款","(T+0) 全款","出售数量/片","过息利息金额","最低收益率（%）","竞价开始日期","竞价结束日期"]
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
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
            let value = product?.selectSeg(button)
            if (value?.isEmpty == false){
                defaultCount = (titleList?.count)!
                selectedName = (product?.textField?.text)!
            }
            else{
                defaultCount = 1
                selectedName = ""
            }
            tempValue.removeAll()
            self.tableView.reloadData()
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
                if  tempValue[indexPath.row] == "True"{
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
            textField.tag = indexPath.row
            cell.contentView.addSubview(textField)
            if titleList![indexPath.row] == "条款比例（%）"{
                bl = textField
            }
            if tempValue.count>0{
                textField.text = tempValue[indexPath.row]
            }
            if indexPath.row == 0{
                if !selectedName.isEmpty{
                    textField.text = selectedName
                }
                //初始化选择框
                product = JPick(controller:self, target: self.tableView,textField:textField)
                product!.pickList = [("请选择",""),("产品AA","1"),("产品B","2"),("产品C","3"),("产品D","4")]
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
                    if  tempValue[indexPath.row]?.isEmpty == false{
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
                startDate = JDatePick(controller:self,target: self.tableView, textField: textField)
            }
            else if indexPath.row == 14{
                endDate = JDatePick(controller:self,target: self.tableView, textField: textField)
            }
            else{
                textField.keyboardType = .NumbersAndPunctuation
                textField.returnKeyType = .Done
                textField.delegate = self
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row > 0 && indexPath.row < 6){
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            var stat = "True"
            for v in (cell?.contentView.subviews)!{
                if let imageView = v as? UIImageView{
                    if imageView.image == UIImage(named: "no-ok"){
                        imageView.image = UIImage(named: "ok")
                        stat = "True"
                    }
                    else{
                        imageView.image = UIImage(named: "no-ok")
                        stat = "False"
                    }
                }
            }
            tempValue[indexPath.row] = stat
        }
        else if (indexPath.row > 5 && indexPath.row < 10){
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            for v in (cell?.contentView.subviews)!{
                if let imageView = v as? UIImageView{
                    if imageView.image == UIImage(named: "no-ok"){
                        imageView.image = UIImage(named: "ok")
                        if let textField = self.view.viewWithTag(indexPath.row) as? UITextField{
                            textField.enabled = true
                            switch indexPath.row{
                            case 8,9:
                                textField.text = "100"
                                tempValue[indexPath.row] = "100"
                                textField.enabled = false
                                break
                            default:
                                textField.becomeFirstResponder()
                                break
                            }
                        }
                        
                    }
                    else{
                        imageView.image = UIImage(named: "no-ok")
                        if let textField = self.view.viewWithTag(indexPath.row) as? UITextField{
                            textField.enabled = false
                            textField.text = ""
                            
                        }
                    }
                }
            }
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    @IBAction func submit(sender: AnyObject) {
        self.performSegueWithIdentifier("unwindBuy", sender: nil)
    }
}

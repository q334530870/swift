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
    var product:JPick?
    var tk:JPick?
    var startDate:JDatePick?
    var endDate:JDatePick?
    var defaultCount = 1
    var selectedName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleList = ["出售产品","1-是否初次发行？","2-是否接受T+1交易（全款24小时内付清）？","3-是否接受集合竞价交易？","4-认购下单，可接受支付的选项（单选）","交易条款","条款比例（%）","出售数量/片","过息利息金额","最低收益率（%）","竞价开始日期","竞价结束日期"]
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
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
    
    func selectSeg(){
        product?.selectSeg()
        defaultCount = (titleList?.count)!
        selectedName = (product?.textField?.text)!
        self.tableView.reloadData()
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ScrollCell", forIndexPath: indexPath)
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        
        if indexPath.row > 0 && indexPath.row < 5{
            cell.textLabel?.text = titleList![indexPath.row]
            cell.textLabel?.font = UIFont.systemFontOfSize(14)
        }
        else{
            let textField = FloatLabelTextField(frame: CGRectMake(15,3,cell.width-20,cell.height-6))
            textField.font = UIFont.systemFontOfSize(14)
            textField.placeholder = titleList![indexPath.row]
            cell.contentView.addSubview(textField)
            if indexPath.row == 0{
                if !selectedName.isEmpty{
                    textField.text = selectedName
                }
                //初始化选择框
                product = JPick(controller:self, target: self.view,textField:textField,frame: CGRectMake(0,self.view.frame.height - self.view.frame.height / 3,self.view.frame.width,self.view.frame.height / 3+50))
                product!.pickList = [("请选择",""),("产品A","1"),("产品B","2"),("产品C","3"),("产品D","4")]
            }
            else if indexPath.row == 5{
                //初始化选择框
                tk = JPick(target: self.view,textField:textField,frame: CGRectMake(0,self.view.frame.height - self.view.frame.height / 3,self.view.frame.width,self.view.frame.height / 3+50))
                tk!.pickList = [("请选择",""),("（T+1）保证金","1"),("（T+1）首付款","2"),("（T+1）全款","3"),("（T+0）全款","4")]
            }
            else if indexPath.row == 10{
                startDate = JDatePick(target: self.view, textField: textField, frame: CGRectMake(0,self.view.frame.height - self.view.frame.height / 3 - 30,self.view.frame.width,self.view.frame.height / 3+80))
            }
            else if indexPath.row == 11{
                endDate = JDatePick(target: self.view, textField: textField, frame: CGRectMake(0,self.view.frame.height - self.view.frame.height / 3 - 30,self.view.frame.width,self.view.frame.height / 3+80))
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row > 0 && indexPath.row < 5{
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            if cell?.accessoryType == .Checkmark{
                cell?.accessoryType = .None
            }
            else{
                cell?.accessoryType = .Checkmark
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}

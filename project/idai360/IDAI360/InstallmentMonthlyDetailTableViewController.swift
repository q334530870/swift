//
//  InstallmentMonthlyDetailTableViewController.swift
//  IDAI360
//
//  Created by YaoJ on 15/12/24.
//  Copyright © 2015年 YaoJ. All rights reserved.
//

import UIKit

class InstallmentMonthlyDetailTableViewController: UITableViewController {
    
    var result:JSON?
    var data = [(text:String,value:String)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //模拟数据
        data.append(("还款周期",result!["PaymentCycle"].stringValue))
        data.append(("还款金额",result!["Payment"].stringValue))
        data.append(("还款周期天数",result!["PaymentCycleDays"].stringValue))
        data.append(("日利息(个人所得税)",result!["DailyInterestIndividual"].stringValue))
        data.append(("日利息(营业税)",result!["DailyInterestBizTax"].stringValue))
        data.append(("日利息(增值税)",result!["DailyInterestVat"].stringValue))
        data.append(("开始日",result!["StartDate"].stringValue))
        data.append(("到期日",result!["EndDate"].stringValue))
        data.append(("利息",result!["Interest"].stringValue))
        data.append(("本金",result!["Principle"].stringValue))
        data.append(("结余",result!["Balance"].stringValue))
        //设置表格尾部（去除多余cell线）
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ScrollCell", forIndexPath: indexPath)
        cell.textLabel?.text = data[indexPath.row].text
        cell.detailTextLabel?.text = data[indexPath.row].value
        return cell
    }
    
    
    
}

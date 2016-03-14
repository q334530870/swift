//
//  TotalViewTableViewController.swift
//  IDAI360
//
//  Created by YaoJ on 16/3/14.
//  Copyright © 2016年 JieYao. All rights reserved.
//

import UIKit

class TotalViewTableViewController: UITableViewController {
    
    var result :JSON?
    var titleList1:[String]?
    var titleList2:[String]?
    var valueList1 = [String]()
    var valueList2 = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleList1 = ["保证金","金币价值","买入已付","线下支付中","买入应付","卖出应收","本息到期应收","本息本月到期"]
        titleList2 = ["应收利息","本日利息","本周实际利息","本月实际利息","本年实际利息","本周持有到期利息","本月持有到期利息","本年持有到期利息"]
        valueList1.append(result!["cashBalance"]["cash_bal"].stringValue)
        valueList1.append(result!["cashBalance"]["coins_yet_to_redeem"].stringValue)
        valueList1.append(result!["cashBalance"]["condi_pmt_paid"].stringValue)
        valueList1.append(result!["cashBalance"]["condi_pmt_offline_paying"].stringValue)
        valueList1.append(result!["cashBalance"]["condi_pmt_payable"].stringValue)
        valueList1.append(result!["cashBalance"]["condi_receivable"].stringValue)
        valueList1.append(result!["cashBalance"]["instalments_receivable"].stringValue)
        valueList1.append(result!["cashBalance"]["instalments_due_mtd"].stringValue)
        
        valueList2.append(result!["interestSummary"]["interest_receivable"].stringValue)
        valueList2.append(result!["interestSummary"]["interest_today"].stringValue)
        valueList2.append(result!["interestSummary"]["interest_act_wtd"].stringValue)
        valueList2.append(result!["interestSummary"]["interest_act_mtd"].stringValue)
        valueList2.append(result!["interestSummary"]["interest_act_ytd"].stringValue)
        valueList2.append(result!["interestSummary"]["interest_maturity_week"].stringValue)
        valueList2.append(result!["interestSummary"]["interest_maturity_month"].stringValue)
        valueList2.append(result!["interestSummary"]["interest_maturity_year"].stringValue)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return titleList1!.count
        }
        else{
            return titleList2!.count
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ScrollCell", forIndexPath: indexPath)
        if indexPath.section == 0{
            cell.textLabel?.text = titleList1![indexPath.row]
            cell.detailTextLabel?.text = valueList1[indexPath.row]
        }
        else{
            cell.textLabel?.text = titleList2![indexPath.row]
            cell.detailTextLabel?.text = valueList2[indexPath.row]
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame:CGRectMake(0,0,self.view.frame.width,40))
        let label = UILabel(frame: CGRectMake(15,0,self.view.frame.width-40,40))
        var text = ""
        if section == 0{
            text = "现金余额"
        }
        else{
            text = "利息汇总"
        }
        label.text = text
        label.font = UIFont.systemFontOfSize(14)
        view.backgroundColor = UIColor.groupTableViewBackgroundColor()
        view.addSubview(label)
        return view
    }
    
}
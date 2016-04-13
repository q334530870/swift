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
    var titleList3:[String]?
    var titleList4:[String]?
    var titleList5:[String]?
    var valueList1 = [Double]()
    var valueList2 = [Double]()
    var valueList3 = [Double]()
    var valueList4 = [Double]()
    var valueList5 = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleList1 = ["保证金","金币价值","买入已付","线下支付中","买入应付","卖出应收","本息到期应收","本息本月到期"]
        titleList2 = ["应收利息","本日利息","本周实际利息","本月实际利息","本年实际利息","本周持有到期利息","本月持有到期利息","本年持有到期利息"]
        titleList3 = ["本息到期应收","实际本息本月到期","实际本息本年到期","持有到期本息本月到期","持有到期本息本年到期"]
        titleList4 = ["债余额价值","交易中/买入价值","交易中/卖出价值","交易委托中/买入价值","交易委托中/卖出价值"]
        titleList5 = ["本日购入价值","本周购入价值","本月购入价值","本年购入价值","本日出售价值","本周出售价值","本月出售价值","本年出售价值","本日退回价值","本周退回价值","本月退回价值","本年退回价值","本日交割价值","本周交割价值","本月交割价值","本年交割价值"]
        
        valueList1.append(result!["cashBalance"][0]["cash_bal"].doubleValue)
        valueList1.append(result!["cashBalance"][0]["coins_yet_to_redeem"].doubleValue)
        valueList1.append(result!["cashBalance"][0]["condi_pmt_paid"].doubleValue)
        valueList1.append(result!["cashBalance"][0]["condi_pmt_offline_paying"].doubleValue)
        valueList1.append(result!["cashBalance"][0]["condi_pmt_payable"].doubleValue)
        valueList1.append(result!["cashBalance"][0]["condi_receivable"].doubleValue)
        valueList1.append(result!["cashBalance"][0]["instalments_receivable"].doubleValue)
        valueList1.append(result!["cashBalance"][0]["instalments_due_mtd"].doubleValue)
        
        valueList2.append(result!["interestSummary"][0]["interest_receivable"].doubleValue)
        valueList2.append(result!["interestSummary"][0]["interest_today"].doubleValue)
        valueList2.append(result!["interestSummary"][0]["interest_act_wtd"].doubleValue)
        valueList2.append(result!["interestSummary"][0]["interest_act_mtd"].doubleValue)
        valueList2.append(result!["interestSummary"][0]["interest_act_ytd"].doubleValue)
        valueList2.append(result!["interestSummary"][0]["interest_maturity_week"].doubleValue)
        valueList2.append(result!["interestSummary"][0]["interest_maturity_month"].doubleValue)
        valueList2.append(result!["interestSummary"][0]["interest_maturity_year"].doubleValue)
        
        valueList3.append(result!["principalInterestSummary"][0]["instalments_receivable"].doubleValue)
        valueList3.append(result!["principalInterestSummary"][0]["instalments_due_mtd"].doubleValue)
        valueList3.append(result!["principalInterestSummary"][0]["instalments_due_ytd"].doubleValue)
        valueList3.append(result!["principalInterestSummary"][0]["instalments_maturity_month"].doubleValue)
        valueList3.append(result!["principalInterestSummary"][0]["instalments_maturity_year"].doubleValue)
        
        for var rst in result!["bondsSummary"].array!{
            //            valueList4.append(rst["products"].stringValue)
            //            valueList4.append(rst["units"].stringValue)
            valueList4.append(rst["NBV"].doubleValue)
        }
        
        for var rst in result!["transactionSummary"].array!{
            //            valueList5.append(rst["products"].stringValue)
            //            valueList5.append(rst["units"].stringValue)
            valueList5.append(rst["NBV"].doubleValue)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return titleList1!.count
        }
        else if section == 1{
            return titleList2!.count
        }
        else if section == 2{
            return titleList3!.count
        }
        else if section == 3{
            return titleList4!.count
        }
        else{
            return titleList5!.count
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ScrollCell", forIndexPath: indexPath)
        if indexPath.section == 0{
            cell.textLabel?.text = titleList1![indexPath.row]
            cell.detailTextLabel?.text = String(valueList1[indexPath.row])
        }
        else if indexPath.section == 1{
            cell.textLabel?.text = titleList2![indexPath.row]
            cell.detailTextLabel?.text = String(valueList2[indexPath.row])
        }
        else if indexPath.section == 2{
            cell.textLabel?.text = titleList3![indexPath.row]
            cell.detailTextLabel?.text = String(valueList3[indexPath.row])
        }
        else if indexPath.section == 3{
            cell.textLabel?.text = titleList4![indexPath.row]
            cell.detailTextLabel?.text = String(valueList4[indexPath.row])
        }
        else{
            cell.textLabel?.text = titleList5![indexPath.row]
            cell.detailTextLabel?.text = String(valueList5[indexPath.row])
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
        else if section == 1{
            text = "利息汇总"
        }
        else if section == 2{
            text = "本息汇总"
        }
        else if section == 3{
            text = "债汇总"
        }
        else{
            text = "交易汇总"
        }
        label.text = text
        label.font = UIFont.systemFontOfSize(14)
        view.backgroundColor = UIColor.groupTableViewBackgroundColor()
        view.addSubview(label)
        return view
    }
    
}

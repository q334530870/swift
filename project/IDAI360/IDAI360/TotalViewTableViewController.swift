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
    
    // MARK: - Table view data source
    
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
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "现金余额"
        }
        else{
            return "利息汇总"
        }
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
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }    
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}

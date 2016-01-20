//
//  MyTradeViewController.swift
//  IDAI360
//
//  Created by YaoJ on 15/12/16.
//  Copyright © 2015年 YaoJ. All rights reserved.
//

import UIKit

class MyTradeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var data = [(title:String,date:String)]()
    @IBOutlet weak var tv: UITableView!
    var selectCell = Payment.我的投资
    @IBOutlet weak var segmented: UISegmentedControl!
    @IBOutlet weak var tvTop: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //模拟数据
        switch selectCell{
        case Payment.我的投资:
            data.append(("CXD(A)-小弟借钱（待确认）","12:12:12"))
            data.append(("CXD(B)-小弟借钱（待确认）","13:13:13"))
            data.append(("CXD(C)-小弟借钱（待确认）","14:14:14"))
        case Payment.我的持仓量:
            data.append(("CXD(A)-小弟借钱（我的持仓量）","12:12:12"))
            data.append(("CXD(B)-小弟借钱（我的持仓量）","13:13:13"))
            data.append(("CXD(C)-小弟借钱（我的持仓量）","14:14:14"))
        case Payment.我的买入成交单:
            data.append(("CXD(A)-小弟借钱（我的买入成交单）","12:12:12"))
            data.append(("CXD(B)-小弟借钱（我的买入成交单）","13:13:13"))
            data.append(("CXD(C)-小弟借钱（我的买入成交单）","14:14:14"))
        case Payment.我的卖出成交单:
            data.append(("CXD(A)-小弟借钱（我的卖出成交单）","12:12:12"))
            data.append(("CXD(B)-小弟借钱（我的卖出成交单）","13:13:13"))
            data.append(("CXD(C)-小弟借钱（我的卖出成交单）","14:14:14"))
        case Payment.本息支付:
            data.append(("CXD(A)-小弟借钱（本息支付）","12:12:12"))
            data.append(("CXD(B)-小弟借钱（本息支付）","13:13:13"))
            data.append(("CXD(C)-小弟借钱（本息支付）","14:14:14"))
        case Payment.到期本息支付汇总:
            data.append(("CXD(A)-小弟借钱（到期本息支付汇总）","12:12:12"))
            data.append(("CXD(B)-小弟借钱（到期本息支付汇总）","13:13:13"))
            data.append(("CXD(C)-小弟借钱（到期本息支付汇总）","14:14:14"))
        default:
            break
        }
        if selectCell != Payment.我的投资{
            segmented.hidden = true
            tvTop.constant = 0
        }
        //下拉刷新
        tv.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "getData")
        //上拉加载
        tv.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "getData")
    }
    
    //绑定数据
    func getData(){
        self.view.makeToastActivity(position: HRToastPositionCenter, message: "数据加载中")
        tv.mj_header.endRefreshing()
        tv.mj_footer.endRefreshing()
        tv.reloadData()
        //tv.mj_footer.endRefreshingWithNoMoreData()
        self.view.hideToastActivity()
    }
    
    @IBAction func changeType(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == Payment.待确认.rawValue{
            data.removeAll()
            data.append(("CXD(A)-小弟借钱（待确认）","12:12:12"))
            data.append(("CXD(B)-小弟借钱（待确认）","13:13:13"))
            data.append(("CXD(C)-小弟借钱（待确认）","14:14:14"))
        }
        else if sender.selectedSegmentIndex == Payment.还款中.rawValue{
            data.removeAll()
            data.append(("CXD(A)-小弟借钱（还款中）",""))
            data.append(("CXD(B)-小弟借钱（还款中）",""))
            data.append(("CXD(C)-小弟借钱（还款中）",""))
        }
        else if sender.selectedSegmentIndex == Payment.还款结束.rawValue{
            data.removeAll()
            data.append(("CXD(A)-小弟借钱（还款结束）",""))
            data.append(("CXD(B)-小弟借钱（还款结束）",""))
            data.append(("CXD(C)-小弟借钱（还款结束）",""))
        }
        tv.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ScrollCell", forIndexPath: indexPath)
        cell.textLabel?.text = data[indexPath.row].title
        cell.detailTextLabel?.text = data[indexPath.row].date
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectData = data[indexPath.row]
        self.performSegueWithIdentifier("TradeDetail", sender: selectData.title)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let trade = segue.destinationViewController as? TradeDetailViewController{
            trade.navigationItem.title = String(sender!)
            if !segmented.hidden{
                trade.detailType = Payment(rawValue: segmented.selectedSegmentIndex)!
            }
            else{
                trade.detailType = selectCell
            }
        }
    }
    
    
}

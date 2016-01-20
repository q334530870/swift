//
//  TradeDetailTableViewController.swift
//  IDAI360
//
//  Created by YaoJ on 15/12/17.
//  Copyright © 2015年 YaoJ. All rights reserved.
//

import UIKit

class TradeDetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var detailInfo = [(key:String,value:String)]()
    var detailType:Payment?
    var hasOperate = false
    
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tvBottom: NSLayoutConstraint!
    
    @IBOutlet weak var tv: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        //隐藏操作按钮，调整表格高度
        if !hasOperate{
            payButton.hidden = true
            cancelButton.hidden = true
            tvBottom.constant = 0
        }
        //设置表格尾部（去除多余cell线）
        tv.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    override func viewWillAppear(animated: Bool) {
        if let tabBar = self.tabBarController?.tabBar{
            tabBar.hidden = true
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        if let tabBar = self.tabBarController?.tabBar{
            tabBar.hidden = false
        }
    }
    
    //模拟数据
    func loadData(){
        if detailType == Payment.待确认{
            detailInfo.append(("剩余确认时间","20:20:20"))
            detailInfo.append(("产品名称","CXD(A)-小弟借钱"))
            detailInfo.append(("年化收益率","8%"))
            detailInfo.append(("份数","50"))
            detailInfo.append(("单价","1,000"))
            detailInfo.append(("应付","50,000"))
            detailInfo.append(("已付","10,000"))
            detailInfo.append(("预期收益","4,000"))
            detailInfo.append(("还款方式","月付"))
            detailInfo.append(("还款周期","12"))
            detailInfo.append(("到期时间","2016-12-30"))
            hasOperate = true
        }
        else if detailType == Payment.还款中{
            detailInfo.append(("产品名称","CXD(A)-小弟借钱"))
            detailInfo.append(("等级","A"))
            detailInfo.append(("年化收益率","8%"))
            detailInfo.append(("数量","50"))
            detailInfo.append(("本金","1,000,000"))
            detailInfo.append(("本期收益","4,000"))
            detailInfo.append(("本期还款合计","10,000"))
            detailInfo.append(("剩余还款金额","80,000"))
            detailInfo.append(("剩余还款期数","10"))
        }
        else if detailType == Payment.还款结束{
            detailInfo.append(("产品名称","CXD(A)-小弟借钱"))
            detailInfo.append(("等级","A"))
            detailInfo.append(("年化收益率","8%"))
            detailInfo.append(("认购份数","50"))
            detailInfo.append(("单价","1,000"))
            detailInfo.append(("实际收益金额","40,000"))
            detailInfo.append(("完成时间","2016-12-30"))
            hasOperate = true
        }
        else if detailType == Payment.我的持仓量{
            detailInfo.append(("产品名称","CXD(A)-小弟借钱"))
            detailInfo.append(("付款周期","1"))
            detailInfo.append(("今日评价","1,000"))
            detailInfo.append(("持有数量","50"))
            detailInfo.append(("购买对价","1,000"))
            detailInfo.append(("购买价余额","4,000"))
            detailInfo.append(("条件持有量","100"))
            detailInfo.append(("条件购买对价","1,000"))
            detailInfo.append(("条件购买余额","10,000"))
            detailInfo.append(("总积数","1000"))
            detailInfo.append(("总利息","10,000"))
            detailInfo.append(("未清本息余额","80,000"))
            detailInfo.append(("累计支付本息","10,000"))
        }
        else if detailType == Payment.我的买入成交单{
            detailInfo.append(("成交时间","2015-12-12"))
            detailInfo.append(("交易对手","张三"))
            detailInfo.append(("产品名称","CXD(A)-小弟借钱"))
            detailInfo.append(("数量","11"))
            detailInfo.append(("价格","10,000"))
            detailInfo.append(("交易报酬率","10%"))
            detailInfo.append(("过息额","10,000"))
            detailInfo.append(("过息价","10,000"))
            detailInfo.append(("保证金支付","10,000"))
            detailInfo.append(("合计付款","10,000"))
            detailInfo.append(("交易条款","10,000"))
            detailInfo.append(("初发","10,000"))
            detailInfo.append(("条件交易",""))
            detailInfo.append(("毕业时间","2015-12-12"))
            detailInfo.append(("毕业结果",""))
        }
        else if detailType == Payment.我的卖出成交单{
            detailInfo.append(("成交时间","2015-12-12"))
            detailInfo.append(("交易对手","张三"))
            detailInfo.append(("产品名称","CXD(A)-小弟借钱"))
            detailInfo.append(("数量","11"))
            detailInfo.append(("价格","10,000"))
            detailInfo.append(("交易报酬率","10%"))
            detailInfo.append(("过息额","10,000"))
            detailInfo.append(("过息价","10,000"))
            detailInfo.append(("保证金支付","10,000"))
            detailInfo.append(("合计付款","10,000"))
            detailInfo.append(("交易条款","10,000"))
            detailInfo.append(("初发","10,000"))
            detailInfo.append(("条件交易",""))
            detailInfo.append(("毕业时间","2015-12-12"))
            detailInfo.append(("毕业结果",""))
        }
        else if detailType == Payment.本息支付{
            detailInfo.append(("通知日期","2015-12-12"))
            detailInfo.append(("投资人","张三"))
            detailInfo.append(("产品名称","CXD(A)-小弟借钱"))
            detailInfo.append(("付款周期","5"))
            detailInfo.append(("数量","5"))
            detailInfo.append(("本金应付","1,000"))
            detailInfo.append(("利息应付","1,000"))
            detailInfo.append(("过息应付","1,000"))
            detailInfo.append(("合计应付","1,000"))
            detailInfo.append(("已付金额","1,000"))
            detailInfo.append(("应付余额","1,000"))
            detailInfo.append(("本次付款","1,000"))
            detailInfo.append(("付款到期","2015-12-12"))
        }
        else if detailType == Payment.到期本息支付汇总{
            detailInfo.append(("日期","2015-12-12"))
            detailInfo.append(("产品名称","CXD(A)-小弟借钱"))
            detailInfo.append(("付款周期","5"))
            detailInfo.append(("数量","5"))
            detailInfo.append(("过息金额","1,000"))
            detailInfo.append(("利息积数","5"))
            detailInfo.append(("持有生息","1,000"))
            detailInfo.append(("本金到期","2015-12-12"))
            detailInfo.append(("本息合计","1,000"))
            detailInfo.append(("已付金额","1,000"))
            detailInfo.append(("应付余额","1,000"))
            detailInfo.append(("付款截止日期","2015-12-12"))
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailInfo.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ScrollCell", forIndexPath: indexPath)
        cell.textLabel?.text = detailInfo[indexPath.row].key
        cell.detailTextLabel?.text = detailInfo[indexPath.row].value
        return cell
    }
    
    //付款
    @IBAction func pay(sender: AnyObject) {
        let alertController = UIAlertController(title: "", message: "确认付款", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler:nil)
        let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Destructive,handler:{ (alertSheet) -> Void in
            self.navigationController?.popViewControllerAnimated(true)
        } )
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {
            let popPresenter = alertController.popoverPresentationController
            popPresenter!.sourceView = sender as? UIView
            popPresenter!.sourceRect = sender.bounds
        }
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //取消
    @IBAction func cancel(sender: AnyObject) {
        let alertController = UIAlertController(title: "", message: "确认取消", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler:nil)
        let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Destructive,handler:{ (alertSheet) -> Void in
            self.navigationController?.popViewControllerAnimated(true)
        } )
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

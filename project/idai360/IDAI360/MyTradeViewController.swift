//
//  MyTradeViewController.swift
//  IDAI360
//
//  Created by YaoJ on 15/12/16.
//  Copyright © 2015年 YaoJ. All rights reserved.
//

import UIKit

class MyTradeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    //接口获得的数据
    var result = [JSON]()
    //当前页数
    var pageIndex = 1
    //每页显示条数
    var pageSize = 10
    var tempValue:[(text:String,detailText:String)]!
    var selectCell = Payment.我的投资
    var dataType = Payment.待确认
    var isJump = false
    @IBOutlet weak var tv: UITableView!
    @IBOutlet weak var segmented: UISegmentedControl!
    @IBOutlet weak var tvTop: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(isJump){
            self.tabBarController?.tabBar.hidden = true
        }
        if selectCell == Payment.我的投资{
            dataType = Payment.待确认
        }
        else{
            dataType = selectCell
            segmented.hidden = true
            tvTop.constant = 0
        }
        //获取数据
        getData()
        //下拉刷新
        tv.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "refresh")
        //上拉加载
        tv.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "loadData")
    }
    
    func setTitle(){
        tempValue = [(text:String,detailText:String)]()
        switch dataType{
        case Payment.待确认:
            tempValue.append(("产品名称","到期时间"))
            break
        case Payment.还款中:
            tempValue.append(("产品名称","年化收益率"))
            break
        case Payment.还款结束:
            tempValue.append(("产品名称","完成时间"))
            break
        case Payment.我的持仓量:
            tempValue.append(("产品","条件持有量"))
            break
        case Payment.我的买入成交单:
            tempValue.append(("产品","成交时间"))
            break
        case Payment.我的卖出成交单:
            tempValue.append(("产品","成交时间"))
            break
        case Payment.现金收付明细表:
            tempValue.append(("摘要","日期"))
            break
        case Payment.到期本息支付汇总:
            tempValue.append(("产品","日期"))
            break
        default:
            break
        }
    }
    
    //绑定数据
    func getData(type:Int = RefreshType.下拉刷新.rawValue,let keyword:String? = nil){
        setTitle()
        self.view.makeToastActivity(position: HRToastPositionCenter, message: "数据加载中")
        let url = API_URL + "/api/report"
        let token = Common.getToken()
        let param = ["token":token,"type":dataType.rawValue]
        self.view.makeToastActivity(position: HRToastPositionCenter, message: "数据加载中")
        Common.doRepuest(self, url: url, method: .GET, param: param as? [String : AnyObject],failed: { () -> Void in
            self.tv.mj_header.endRefreshing()
            self.tv.mj_footer.endRefreshing()
            }) { (response, json) -> Void in
                if type == RefreshType.下拉刷新.rawValue{
                    self.result = json["data"].array!
                    self.tv.mj_header.endRefreshing()
                    self.tv.reloadData()
                    //暂时没有分页功能
                    self.tv.mj_footer.endRefreshingWithNoMoreData()
                }
                else if type == RefreshType.上拉加载.rawValue{
                    self.tv.mj_footer.endRefreshing()
                    if json["data"].count == 0{
                        self.tv.mj_footer.endRefreshingWithNoMoreData()
                    }
                    else{
                        self.pageIndex++
                        self.tv.reloadData()
                    }
                }
        }
        
    }
    
    //刷新数据
    func refresh(){
        pageIndex = 1
        getData(RefreshType.下拉刷新.rawValue)
    }
    
    //加载数据
    func loadData(){
        pageIndex++
        getData(RefreshType.上拉加载.rawValue)
    }
    
    @IBAction func changeType(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == Payment.待确认.rawValue{
            dataType = Payment.待确认
        }
        else if sender.selectedSegmentIndex == Payment.还款中.rawValue{
            dataType = Payment.还款中
        }
        else if sender.selectedSegmentIndex == Payment.还款结束.rawValue{
            dataType = Payment.还款结束
        }
        getData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let rowData = result[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ScrollCell", forIndexPath: indexPath)
        cell.textLabel?.text = rowData[tempValue[0].text].stringValue
        cell.detailTextLabel?.text = rowData[tempValue[0].detailText].stringValue
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("TradeDetail", sender: indexPath.row)
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
            trade.dataDetail = result[sender as! Int]
        }
    }
    
    
}

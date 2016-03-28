//
//  GatherTableViewController.swift
//  IDAI360
//
//  Created by YaoJ on 16/2/15.
//  Copyright © 2016年 YaoJ. All rights reserved.
//

import UIKit

class GatherTableViewController: UITableViewController {
    //接口获得的数据
    var result = [JSON]()
    //当前页数
    var pageIndex = 1
    //每页显示条数
    var pageSize = 100
    var tempValue = [(text:String,detailText:String)]()
    var selectCell:Gather?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tempValue.append(("产品","提交时间"))
        //获取数据
        getData()
        //下拉刷新
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(GatherTableViewController.refresh))
        //上拉加载
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(GatherTableViewController.loadData))
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    //绑定数据
    func getData(type:Int = RefreshType.下拉刷新.rawValue,let keyword:String? = nil){
        self.view.makeToastActivity(position: HRToastPositionCenter, message: "数据加载中")
        let url = API_URL + "/api/Transaction"
        let token = Common.getToken()
        let param = ["token":token,"type":selectCell!.rawValue]
        self.view.makeToastActivity(position: HRToastPositionCenter, message: "数据加载中")
        Common.doRepuest(self, url: url, method: .GET, param: param as? [String : AnyObject],failed: { () -> Void in
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
        }) { (response, json) -> Void in
            if type == RefreshType.下拉刷新.rawValue{
                self.result = json["data"].array!
                self.tableView.mj_header.endRefreshing()
                self.tableView.reloadData()
                //暂时没有分页功能
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            }
            else if type == RefreshType.上拉加载.rawValue{
                self.tableView.mj_footer.endRefreshing()
                if json["data"].count == 0{
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
                else{
                    self.pageIndex += 1
                    self.tableView.reloadData()
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
        pageIndex += 1
        getData(RefreshType.上拉加载.rawValue)
    }
    
    @IBAction func apply(sender: AnyObject) {
        if selectCell == Gather.委托卖出{
            self.performSegueWithIdentifier("sell", sender: nil)
        }
        else if selectCell == Gather.委托买入{
            self.performSegueWithIdentifier("buy", sender: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let rowData = result[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ScrollCell", forIndexPath: indexPath)
        cell.textLabel?.text = rowData[tempValue[0].text].stringValue
        cell.detailTextLabel?.text = rowData[tempValue[0].detailText].stringValue
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("gatherDetail", sender: indexPath.row)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let gather = segue.destinationViewController as? GatherDetailTableViewController{
            let detail = result[sender as! Int]
            gather.navigationItem.title = String(detail[tempValue[0].text])
            gather.dataDetail = detail
            gather.delegate = self
        }
        if let apy = segue.destinationViewController as? GatherSellTableViewController{
            apy.navigationItem.title = "\(Gather(rawValue: (selectCell?.rawValue)!)!)申请"
        }
        if let apy = segue.destinationViewController as? GatherBuyTableViewController{
            apy.navigationItem.title = "\(Gather(rawValue: (selectCell?.rawValue)!)!)申请"
        }
    }
    
    @IBAction func unwindToGather(segue:UIStoryboardSegue){
        getData()
    }
    
    
}

//
//  OverdrawTableViewController.swift
//  IDAI360
//
//  Created by YaoJ on 16/4/13.
//  Copyright © 2016年 JieYao. All rights reserved.
//

import UIKit

class OverdrawTableViewController: UITableViewController {
    //接口获得的数据
    var result = [JSON]()
    //当前页数
    var pageIndex = 1
    //每页显示条数
    var pageSize = 999
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //获取数据
        getData()
        //下拉刷新
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(GoldTableViewController.refresh))
        header.lastUpdatedTimeLabel?.hidden = true
        self.tableView.mj_header = header
        //上拉加载
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(GoldTableViewController.loadData))
        //设置表格尾部（去除多余cell线）
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ScrollCell", forIndexPath: indexPath)
        cell.textLabel?.text = "\(result[indexPath.row]["datetime"].stringValue) - \(result[indexPath.row]["typedecision"].stringValue)"
        cell.detailTextLabel?.text = result[indexPath.row]["creditamount"].stringValue
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("overdrawDetail", sender: indexPath.row)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let od = segue.destinationViewController as? OverdrawDetailTableViewController{
            let detail = result[sender as! Int]
            od.navigationItem.title = detail["datetime"].stringValue
            od.dataDetail = detail
        }
    }
    
    //绑定数据
    func getData(type:Int = RefreshType.下拉刷新.rawValue){
        let url = API_URL + "/api/Overdraft"
        let token = Common.getToken()
        let param = ["token":token]
        self.view.makeToastActivity(position: HRToastPositionCenter, message: "数据加载中")
        Common.doRepuest(self, url: url, method: .GET, param: param ,failed: { () -> Void in
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
        }){ (response, json) -> Void in
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
                    self.result += json["data"].array!
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
        getData(RefreshType.上拉加载.rawValue)
    }
    
    @IBAction func unwindToOverdraw(segue:UIStoryboardSegue){
        getData()
    }
    
}

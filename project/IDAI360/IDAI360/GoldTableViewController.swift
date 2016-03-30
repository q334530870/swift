//
//  GoldTableViewController.swift
//  IDAI360
//
//  Created by YaoJ on 16/3/30.
//  Copyright © 2016年 JieYao. All rights reserved.
//

import UIKit

class GoldTableViewController: UITableViewController {
    
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
    
    @IBAction func getCoin(sender: AnyObject) {
        //获取本次应付金额
        let alertController = UIAlertController(title: "金币申领", message: "请输入金币领取码", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addTextFieldWithConfigurationHandler { (tf) -> Void in
            tf.textAlignment = .Center
        }
        let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Destructive,handler:{ (alertSheet) -> Void in
            //确认领取
            let code = alertController.textFields![0].text
            if code!.isEmpty{
                Common.showAlert(self, title: "", message: "请填写领取码")
            }
            else{
                let url = API_URL + "/api/coin"
                let token = Common.getToken()
                let param = ["token":token,"code":code!]
                self.view.makeToastActivity(position: HRToastPositionCenter, message: "数据加载中")
                Common.doRepuest(self, url: url, method: .POST, param: param, failed: nil) { (response, json) -> Void in
                    Common.showAlert(self, title: "", message: json["message"].stringValue, ok: { (action) in
                        self.getData()
                    })
                }
            }
        })
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler:nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    //绑定数据
    func getData(type:Int = RefreshType.下拉刷新.rawValue){
        let url = API_URL + "/api/coin"
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
        let cell = tableView.dequeueReusableCellWithIdentifier("ScrollCell", forIndexPath: indexPath)
        cell.textLabel?.text = "\(result[indexPath.row]["name"].stringValue) - 价值：\(result[indexPath.row]["value"].stringValue)"
        cell.detailTextLabel?.text = result[indexPath.row]["receivetime"].stringValue
        return cell
    }
    
}

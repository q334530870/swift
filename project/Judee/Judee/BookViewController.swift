//
//  BookViewController.swift
//  Judee
//
//  Created by YaoJ on 16/1/22.
//  Copyright © 2016年 YaoJ. All rights reserved.
//

import UIKit

class BookViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tv: UITableView!
    //接口获得的数据
    var result = [JSON]()
    //当前页数
    var pageIndex = 0
    //每页显示条数
    var pageSize = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //解决导航栏引起的顶部内容往下bug
        self.automaticallyAdjustsScrollViewInsets = false
        tv.delegate = self
        tv.dataSource = self
        tv.tableFooterView = UIView()
        tv.estimatedRowHeight = 100
        getData()
        //下拉刷新
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "refresh")
        header.lastUpdatedTimeLabel?.hidden = true
        self.tv.mj_header = header
        //上拉加载
        self.tv.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "loadData")
    }
    
    //绑定数据
    func getData(type:Int = RefreshType.下拉刷新.rawValue){
        let url = API_URL + "/homeworks/"
        let token = Common.getToken()
        let headers = ["Authorization": "bearer \(token)"]
        let param = ["offset":pageIndex*pageSize,"limit":pageSize]
        self.view.makeToastActivity(position: HRToastPositionCenter, message: "数据加载中")
        Common.doRepuest(self, url: url, method: .GET, param: param,headers: headers, failed: { () -> Void in
            self.tv.mj_header.endRefreshing()
            self.tv.mj_footer.endRefreshing()
            }){ (response, json) -> Void in
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
                        self.result += json["data"].array!
                        self.pageIndex++
                        self.tv.reloadData()
                    }
                }
        }
    }
    
    //刷新数据
    func refresh(){
        pageIndex = 0
        getData(RefreshType.下拉刷新.rawValue)
    }
    
    //加载数据
    func loadData(){
        getData(RefreshType.上拉加载.rawValue)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tv.dequeueReusableCellWithIdentifier("ScrollCell", forIndexPath: indexPath)
        
        cell.imageView?.image = UIImage(named: "judy.jpg")
        cell.imageView!.layer.cornerRadius = 20
        cell.imageView?.layer.masksToBounds = true
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = result[indexPath.row]["content"].string
        cell.detailTextLabel?.text = Common.dateFormateUTCDate(result[indexPath.row]["work_date"].stringValue,fmt: "yyyy-MM-dd")
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tv.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier("bookDetail", sender: tv.cellForRowAtIndexPath(indexPath)?.detailTextLabel?.text)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let detail = segue.destinationViewController as? BookDetailViewController{
            detail.navigationItem.title = sender as? String
        }
    }
    
}

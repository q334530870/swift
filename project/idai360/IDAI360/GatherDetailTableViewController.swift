//
//  GatherDetailTableViewController.swift
//  IDAI360
//
//  Created by YaoJ on 16/2/15.
//  Copyright © 2016年 YaoJ. All rights reserved.
//

import UIKit

class GatherDetailTableViewController: UITableViewController {
    
    var detailInfo = [(key:String,value:String)]()
    var dataDetail:JSON?
    var delegate:GatherTableViewController?
    @IBOutlet weak var changeButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        //设置表格尾部（去除多余cell线）
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    //模拟数据
    func loadData(){
        if delegate?.selectCell == Gather.委托买入{
            detailInfo.append(("申请号",dataDetail!["申请号"].stringValue))
            detailInfo.append(("提交时间",dataDetail!["提交时间"].stringValue))
            detailInfo.append(("产品",dataDetail!["产品"].stringValue))
            detailInfo.append(("求购量",dataDetail!["求购量"].stringValue))
            detailInfo.append(("求购过息",dataDetail!["求购过息"].stringValue))
            detailInfo.append(("报价",dataDetail!["报价"].stringValue))
            detailInfo.append(("报价额",dataDetail!["报价额"].stringValue))
            detailInfo.append(("成交量",dataDetail!["成交量"].stringValue))
            detailInfo.append(("成交过息",dataDetail!["成交过息"].stringValue))
            detailInfo.append(("首付",dataDetail!["首付"].stringValue))
            detailInfo.append(("定金",dataDetail!["定金"].stringValue))
            detailInfo.append(("条件交易",dataDetail!["条件交易"].stringValue))
            detailInfo.append(("初发",dataDetail!["初发"].stringValue))
            detailInfo.append(("撮合",dataDetail!["撮合"].stringValue))
            detailInfo.append(("定金条件",dataDetail!["定金条件"].stringValue))
        }
        else{
            detailInfo.append(("申请号",dataDetail!["申请号"].stringValue))
            detailInfo.append(("提交时间",dataDetail!["提交时间"].stringValue))
            detailInfo.append(("产品",dataDetail!["产品"].stringValue))
            detailInfo.append(("求售量",dataDetail!["求售量"].stringValue))
            detailInfo.append(("求售过息",dataDetail!["求售过息"].stringValue))
            detailInfo.append(("报价",dataDetail!["报价"].stringValue))
            detailInfo.append(("报价额",dataDetail!["报价额"].stringValue))
            detailInfo.append(("成交量",dataDetail!["成交量"].stringValue))
            detailInfo.append(("成交过息",dataDetail!["成交过息"].stringValue))
            detailInfo.append(("首付",dataDetail!["首付"].stringValue))
            detailInfo.append(("定金",dataDetail!["定金"].stringValue))
            detailInfo.append(("条件交易",dataDetail!["条件交易"].stringValue))
            detailInfo.append(("撮合",dataDetail!["撮合"].stringValue))
            detailInfo.append(("定金条件",dataDetail!["定金条件"].stringValue))
            detailInfo.append(("发行成本",dataDetail!["发行成本"].stringValue))
            detailInfo.append(("交易成本",dataDetail!["交易成本"].stringValue))
            detailInfo.append(("留存履约金",dataDetail!["留存履约金"].stringValue))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailInfo.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ScrollCell", forIndexPath: indexPath)
        cell.textLabel?.text = detailInfo[indexPath.row].key
        cell.detailTextLabel?.text = detailInfo[indexPath.row].value
        return cell
    }
    
    //变更
    @IBAction func change(sender: AnyObject) {
        
    }
    
}

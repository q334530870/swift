//
//  OverdrawDetailTableViewController.swift
//  IDAI360
//
//  Created by YaoJ on 16/4/13.
//  Copyright © 2016年 JieYao. All rights reserved.
//

import UIKit

class OverdrawDetailTableViewController: UITableViewController {
    
    var dataDetail:JSON?
    var detailInfo = [(key:String,value:String)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        //设置表格尾部（去除多余cell线）
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    //模拟数据
    func loadData(){
        detailInfo.append(("申请日期",dataDetail!["datetime"].stringValue))
        detailInfo.append(("申请金额",dataDetail!["creditamount"].stringValue))
        detailInfo.append(("申请说明",dataDetail!["remark"].stringValue))
        detailInfo.append(("审核状态",dataDetail!["typedecision"].stringValue))
        detailInfo.append(("归还日期",dataDetail!["paybackdate"].stringValue))
        detailInfo.append(("年利率",dataDetail!["overdraftratedaily"].stringValue))
        detailInfo.append(("罚息日率",dataDetail!["penaltyratedaily"].stringValue))
        detailInfo.append(("审批说明",dataDetail!["approvalremarks"].stringValue))
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
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
    
}

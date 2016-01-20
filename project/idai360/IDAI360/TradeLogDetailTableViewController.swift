//
//  TradeLogDetailTableViewController.swift
//  IDAI360
//
//  Created by YaoJ on 15/12/24.
//  Copyright © 2015年 YaoJ. All rights reserved.
//

import UIKit

class TradeLogDetailTableViewController: UITableViewController {
    
    var result:JSON?
    var data = [(text:String,value:String)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //模拟数据
        data.append(("交易时间",result!["DateTime"].stringValue))
        data.append(("交易类别",result!["Type"].stringValue))
        data.append(("买方",result!["Buyer"].stringValue))
        data.append(("份数",result!["Count"].stringValue))
        data.append(("单价",result!["Price"].stringValue))
        data.append(("年化率",result!["Irr"].stringValue))
        data.append(("交易状态",result!["Status"].stringValue))
        //设置表格尾部（去除多余cell线）
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ScrollCell", forIndexPath: indexPath)
        cell.textLabel?.text = data[indexPath.row].text
        cell.detailTextLabel?.text = data[indexPath.row].value
        return cell
    }
    
}

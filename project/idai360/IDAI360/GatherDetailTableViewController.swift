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
        for dt in (dataDetail?.dictionary)!{
            if dt.0 != "subscription_detail_id"
            {
                detailInfo.append((dt.0,dt.1.stringValue))
            }
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

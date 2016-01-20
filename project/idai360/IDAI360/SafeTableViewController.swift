//
//  SafeTableViewController.swift
//  IDAI360
//
//  Created by YaoJ on 16/1/11.
//  Copyright © 2016年 YaoJ. All rights reserved.
//

import UIKit

class SafeTableViewController: UITableViewController {
    
    var list = [SafeType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //绑定枚举数据源
        for i in 1...4{
            list.append(SafeType(rawValue: i)!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ScrollCell", forIndexPath: indexPath)
        cell.textLabel?.text = "\(list[indexPath.row])"
        cell.textLabel?.font = UIFont.systemFontOfSize(14)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier("SafeDetail", sender: indexPath.row)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let detail = segue.destinationViewController as? SafeDetailTableViewController{
            detail.selectCell = list[sender as! Int]
            detail.navTitle = "\(detail.selectCell)"
        }
    }
    
}

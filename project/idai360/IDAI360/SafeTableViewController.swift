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
    var otherList = [(title:String,segue:String)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //绑定枚举数据源
        for i in 1...4{
            list.append(SafeType(rawValue: i)!)
        }
        otherList.append(("金币申领","gold"))
        otherList.append(("邀请朋友","friend"))
        otherList.append(("平台透支","overdraw"))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return list.count
        }
        if section == 1{
            return otherList.count
        }
        else{
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ScrollCell", forIndexPath: indexPath)
        if indexPath.section == 0{
            cell.textLabel?.text = "\(list[indexPath.row])"
            cell.textLabel?.font = UIFont.systemFontOfSize(14)
        }
        else if indexPath.section == 1{
            cell.textLabel?.text = otherList[indexPath.row].title
            cell.textLabel?.font = UIFont.systemFontOfSize(14)
        }
        else if indexPath.section == (tableView.numberOfSections - 1){
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
            label.text = "退出登录"
            label.textAlignment = .Center
            cell.accessoryType = .None
            cell.addSubview(label)
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0{
            self.performSegueWithIdentifier("SafeDetail", sender: indexPath.row)
        }
        else if indexPath.section == 1{
            self.performSegueWithIdentifier(otherList[indexPath.row].segue, sender: indexPath.row)
        }
        else{
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            let alertController = UIAlertController(title: "", message: "退出后不会删除任何历史数据，下次登录依然可以使用本账号。", preferredStyle: UIAlertControllerStyle.ActionSheet)
            let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
            let logoutAction = UIAlertAction(title: "退出登录", style: UIAlertActionStyle.Destructive,handler:{ (alertSheet) -> Void in
                Common.removeDefault("user")
                Common.removeDefault("token")
                self.presentViewController((self.storyboard?.instantiateViewControllerWithIdentifier("HomeTabBar"))!, animated: true, completion: nil)
            } )
            alertController.addAction(cancelAction)
            alertController.addAction(logoutAction)
            
            if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {
                let popPresenter = alertController.popoverPresentationController
                popPresenter!.sourceView = cell
                popPresenter!.sourceRect = (cell?.bounds)!
            }
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let detail = segue.destinationViewController as? SafeDetailTableViewController{
            detail.selectCell = list[sender as! Int]
            detail.navTitle = "\(detail.selectCell)"
        }
    }
    
}

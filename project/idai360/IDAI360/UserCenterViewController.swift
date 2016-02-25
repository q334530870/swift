//
//  UserCenterViewController.swift
//  IDAI360
//
//  Created by YaoJ on 15/12/16.
//  Copyright © 2015年 YaoJ. All rights reserved.
//

import UIKit

class UserCenterViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate{
    
    var cellData = [(title:String,detail:String,segue:String,type:Payment)]()
    var gatherData = [(title:String,detail:String,segue:String,type:Gather)]()
    var user:JSON?
    
    @IBOutlet weak var avatorButton: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phone: UILabel!
    var navBarHairlineImageView:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //获得导航下面的实现
        navBarHairlineImageView = Common.findHairlineImageViewUnder((self.navigationController?.navigationBar)!)
        //设置头像圆角
        avatorButton.layer.cornerRadius = avatorButton.frame.width/2
        avatorButton.clipsToBounds = true
        //绑定用户信息
        let user = Common.getCurrentUser()
        name.text = user.username
        phone.text = user.cellphone
        //设置头像
        if let avt = user.avatar{
            avatorButton.setImage(avt,forState: UIControlState.Normal)
        }
        //模拟数据
        for i in 4...8{
            cellData.append(("\(Payment(rawValue: i)!)","","myTrade",Payment(rawValue: i)!))
        }
        for i in 0...1{
            gatherData.append(("\(Gather(rawValue: i)!)","","gather",Gather(rawValue: i)!))
        }
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        //隐藏导航下面的实现
        navBarHairlineImageView.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        //显示导航下面的实现（其他页面）
        navBarHairlineImageView.hidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //解决cell分割线左边短的问题
        if cell.respondsToSelector(Selector("setSeparatorInset:")){
            cell.separatorInset = UIEdgeInsetsZero
        }
        if cell.respondsToSelector(Selector("setLayoutMargins:")){
            cell.layoutMargins = UIEdgeInsetsZero
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return cellData.count
        }
        else if section == 1{
            return gatherData.count
        }
        else{
            return 1
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ScrollCell", forIndexPath: indexPath)
        
        if indexPath.section == 0{
            let val = cellData[indexPath.row]
            cell.textLabel?.text = val.title
            cell.detailTextLabel?.text = val.detail
        }
        else if indexPath.section == 1{
            let gtr = gatherData[indexPath.row]
            cell.textLabel?.text = gtr.title
            cell.detailTextLabel?.text = gtr.detail
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //退出登录
        if indexPath.section == tableView.numberOfSections - 1{
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
        else if indexPath.section == 0{
            //跳转不同的页面
            if cellData[indexPath.row].segue != ""{
                self.performSegueWithIdentifier(cellData[indexPath.row].segue, sender: indexPath.row)
            }
        }
        else if indexPath.section == 1{
            //跳转不同的页面
            if gatherData[indexPath.row].segue != ""{
                self.performSegueWithIdentifier(gatherData[indexPath.row].segue, sender: indexPath.row)
            }
            
        }
        //取消选中效果
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let trade = segue.destinationViewController as? MyTradeViewController{
            trade.navigationItem.title = cellData[Int(sender! as! NSNumber)].title
            trade.selectCell = cellData[Int(sender! as! NSNumber)].type
        }
        else if let gather = segue.destinationViewController as? GatherTableViewController{
            gather.navigationItem.title = gatherData[Int(sender! as! NSNumber)].title
            gather.selectCell = gatherData[Int(sender! as! NSNumber)].type
        }
    }
    
    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

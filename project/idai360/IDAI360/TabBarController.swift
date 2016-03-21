//
//  TabBarController.swift
//  IDAI360
//
//  Created by YaoJ on 15/12/10.
//  Copyright © 2015年 YaoJ. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController,UITabBarControllerDelegate{
    
    var willSelectTab = ""
    var MyIdaiSelectIndex = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.tabBar.tintColor = MAIN_COLOR
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        willSelectTab = item.title!
    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        if willSelectTab == "我的账户" || willSelectTab == "市价卖出"{
            //判断是否登录
            let user = Common.loadDefault("user")
            if user == nil{
                self.performSegueWithIdentifier("login", sender: nil)
                return false
            }
            if willSelectTab == "我的账户"{
                self.selectedIndex = MyIdaiSelectIndex
            }
        }
        return true
    }
    
    //注册完成后回调跳转
    @IBAction func goMyIdai(segue:UIStoryboardSegue){
        //购买后跳转我的投资列表
        if let _ = segue.sourceViewController as? BuyViewController{
            if let myIdai = self.viewControllers![MyIdaiSelectIndex].childViewControllers[0] as? MyIdaiViewController {
                myIdai.jump = "MyTrade"
            }
        }
        else if let _ = segue.sourceViewController as? SellViewController{
            if let myIdai = self.viewControllers![MyIdaiSelectIndex].childViewControllers[0] as? MyIdaiViewController {
                myIdai.jump = "MyTrade"
                myIdai.jumpFilter = "Sell"
            }
        }
        else if let _ = segue.sourceViewController as? RegisterInfoViewController{
            if let myIdai = self.viewControllers![MyIdaiSelectIndex].childViewControllers[0] as? MyIdaiViewController {
                //                myIdai.jump = "Safe"
                myIdai.jump = ""
            }
        }
        self.selectedIndex = MyIdaiSelectIndex
        
        //        for view in self.viewControllers![0].childViewControllers{
        //            if let v = view as? ViewController{
        //                v.tableView.reloadData()
        //            }
        //        }
        //        self.tabBar.items![3].badgeValue = "1"
    }
    
}
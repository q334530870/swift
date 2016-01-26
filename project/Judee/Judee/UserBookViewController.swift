//
//  UserBookViewController.swift
//  Judee
//
//  Created by YaoJ on 16/1/26.
//  Copyright © 2016年 YaoJ. All rights reserved.
//

import UIKit

class UserBookViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tv: UITableView!
    var data:[String]?
    var foot:UIScrollView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //解决导航栏引起的顶部内容往下bug
        self.automaticallyAdjustsScrollViewInsets = false
        tv.delegate = self
        tv.dataSource = self
        tv.estimatedRowHeight = 100
        //隐藏返回按钮的文字
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), forBarMetrics: .Default)
        //模拟数据
        data = ["1：语文书抄一遍","2：倒过来在抄一遍","3：用英语翻译一遍"]
        foot = UIScrollView(frame:CGRectMake(0,0,self.view.frame.width,self.view.frame.height - tv.contentSize.height))
        tv.tableFooterView = foot!
    }
    
    func getInfo(index:Int){
        switch(index){
        case 0:foot!.backgroundColor = UIColor.redColor()
            break
        case 1:foot!.backgroundColor = UIColor.blueColor()
            break
        case 2:foot!.backgroundColor = UIColor.yellowColor()
            break
        default:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (data?.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tv.dequeueReusableCellWithIdentifier("ScrollCell", forIndexPath: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = data![indexPath.row]
        if indexPath.row > 0{
            cell.accessoryType = .Checkmark
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        getInfo(indexPath.row)
    }
    
    
}

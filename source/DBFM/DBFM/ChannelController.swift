//
//  ChannelController.swift
//  DBFM
//
//  Created by YaoJ on 15/11/5.
//  Copyright © 2015年 YaoJ. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol ChannelProtocol{
    //回调方法
    func onChangeChannel(channelId:String)
}

class ChannelController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tv: UITableView!
    
    //申明代理
    var delegate:ChannelProtocol?
    //频道数据
    var channelData:[JSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.alpha = 0.8
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tv.dequeueReusableCellWithIdentifier("channelCell")! as UITableViewCell
        let rowData:JSON = self.channelData[indexPath.row] as JSON
        cell.textLabel?.text = rowData["name"].string
        return cell

    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //设置cell显示动画为3d缩放，xy方向的缩放动画，初始值0.1，结束值1
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        UIView.animateWithDuration(0.25) { () -> Void in
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channelData.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //获取行数据
        let rowData:JSON = self.channelData[indexPath.row] as JSON
        //获取选中行频道ID
        let channelId = rowData["channel_id"].stringValue
        //频道ID反向传值给主界面
        delegate?.onChangeChannel(channelId)
        //关闭当前界面
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}

//
//  CommentTableViewController.swift
//  IDAI360
//
//  Created by YaoJ on 15/12/25.
//  Copyright © 2015年 YaoJ. All rights reserved.
//

import UIKit

class CommentTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tv: UITableView!
    //结果集
    var data = [JSON]()
    var ok:UIAlertAction!
    var user:User?
    var productId:Int = 0
    //当前头像
    var currentAvator:UIImage?
    //当前页数
    var pageIndex = 1
    //每页显示条数
    var pageSize = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //绑定用户信息
        user = Common.getCurrentUser()
        //设置头像
        if let avt = user?.avatar{
            currentAvator = avt
        }
        //获取数据
        getData()
        //下拉刷新
        self.tv.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "refresh")
        //上拉加载
        self.tv.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "loadData")
        //设置自适应行高
        tv.estimatedRowHeight = 100
        tv.rowHeight = UITableViewAutomaticDimension
        //解决导航栏引起的顶部内容往下bug
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //获取数据
    func getData(type:Int = RefreshType.下拉刷新.rawValue){
        let url = API_URL + "/api/comment"
        let param = ["id":productId]
        self.view.makeToastActivity(position: HRToastPositionCenter, message: "数据加载中")
        Common.doRepuest(self, url: url, method: .GET, param: param,failed: { () -> Void in
            self.tv.mj_header.endRefreshing()
            self.tv.mj_footer.endRefreshing()
            }) { (response, json) -> Void in
                if type == RefreshType.下拉刷新.rawValue{
                    self.tv.mj_header.endRefreshing()
                    self.data = json["data"].array!
                    //暂时没有分页功能
                    self.tv.mj_footer.endRefreshingWithNoMoreData()
                }
                else if type == RefreshType.上拉加载.rawValue{
                    self.tv.mj_footer.endRefreshing()
                    if json["data"].count == 0{
                        self.tv.mj_footer.endRefreshingWithNoMoreData()
                    }
                    else{
                        self.data += json["data"].array!
                        self.pageIndex++
                    }
                }
                self.tv.reloadData()
        }
    }
    
    //刷新数据
    func refresh(){
        pageIndex = 1
        getData(RefreshType.下拉刷新.rawValue)
    }
    
    //加载数据
    func loadData(){
        getData(RefreshType.上拉加载.rawValue)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 2
        if data[section]["FundRaiserReply"] != ""{
            count++
        }
        if data[section]["Idai360Reply"] != ""{
            count++
        }
        return count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 10
        }
        else{
            return 5
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    //回调发表评论
    @IBAction func unwindToComment(segue:UIStoryboardSegue){
        self.view.makeToast(message: "发表成功", duration: 2, position: HRToastPositionCenter)
        getData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        let rowData = data[indexPath.section]
        if(indexPath.row == 0){
            cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath)
            cell.selectionStyle = .None
            for view in cell.contentView.subviews{
                view.removeFromSuperview()
            }
            //头像
            let avatar = UIImageView(frame: CGRect(x: 16, y: cell.frame.height / 2-12, width: 24, height: 24))
            avatar.layer.cornerRadius = avatar.frame.width/2
            avatar.clipsToBounds = true
            var avatarImage = UIImage(named: "avatar")
            if rowData["CreatorName"].stringValue == user?.username && currentAvator != nil{
                avatarImage = currentAvator
            }
            avatar.image = avatarImage
            //用户
            let nameLabel = UILabel(frame: CGRect(x: 46, y: cell.frame.height / 2 - 8, width: cell.frame.width - 200, height: 16))
            nameLabel.text = rowData["CreatorName"].stringValue
            nameLabel.font = UIFont.systemFontOfSize(12)
            //发表日期
            let dateLabel = UILabel(frame: CGRect(x: cell.frame.width - 140 , y: cell.frame.height / 2 - 8, width: 130, height: 16))
            dateLabel.text = rowData["PublishTime"].stringValue
            dateLabel.textAlignment = .Right
            dateLabel.font = UIFont.systemFontOfSize(12)
            dateLabel.textColor = UIColor.grayColor()
            
            cell.contentView.addSubview(avatar)
            cell.contentView.addSubview(nameLabel)
            cell.contentView.addSubview(dateLabel)
        }
        else if indexPath.row == 1{
            cell = tableView.dequeueReusableCellWithIdentifier("CommentCell", forIndexPath: indexPath)
            for view in cell.contentView.subviews{
                view.removeFromSuperview()
            }
            cell.textLabel!.numberOfLines = 0
            cell.textLabel!.font = UIFont.systemFontOfSize(12)
            cell.textLabel!.text = rowData["Content"].stringValue
            cell.textLabel?.textColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
            //根据内容判断高度
            //            let newSize = rowData.comment.stringHeightWithFontSize(12, width: width)
        }
            //融资人或管理员回复
        else if indexPath.row == 2{
            cell = tableView.dequeueReusableCellWithIdentifier("CommentCell", forIndexPath: indexPath)
            cell.textLabel!.numberOfLines = 0
            cell.textLabel!.font = UIFont.systemFontOfSize(12)
            var text = ""
            if rowData["FundRaiserReply"].stringValue != ""{
                cell.textLabel?.textColor = UIColor(colorLiteralRed: 46/255, green: 167/255, blue: 224/255, alpha: 1.0)
                text = "融资人回复：\(rowData["FundRaiserReply"].stringValue)"
            }
            else{
                //融资方没有回复
                cell.textLabel?.textColor = UIColor.orangeColor()
                text = "管理员回复：\(rowData["Idai360Reply"].stringValue)"
            }
            cell.textLabel!.text = text
        }
            //管理员评论
        else if indexPath.row == 3{
            cell = tableView.dequeueReusableCellWithIdentifier("CommentCell", forIndexPath: indexPath)
            cell.textLabel!.numberOfLines = 0
            cell.textLabel!.font = UIFont.systemFontOfSize(12)
            cell.textLabel?.textColor = UIColor.orangeColor()
            cell.textLabel!.text = "管理员回复：\(rowData["Idai360Reply"].stringValue)"
        }
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController.childViewControllers[0] as? publicCommentViewController{
            controller.productId = productId
        }
    }
    
}

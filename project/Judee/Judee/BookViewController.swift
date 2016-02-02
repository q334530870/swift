//
//  BookViewController.swift
//  Judee
//
//  Created by YaoJ on 16/1/22.
//  Copyright © 2016年 YaoJ. All rights reserved.
//

import UIKit

class BookViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tv: UITableView!
    //接口获得的数据
    var result = [JSON]()
    //当前页数
    var pageIndex = 0
    //每页显示条数
    var pageSize = 3
    //班级选择视图
    var classBackgroundView:UIView?
    //作业ID
    var homeworkId:String?
    
    @IBOutlet weak var classBarButtonItem: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //解决导航栏引起的顶部内容往下bug
        self.automaticallyAdjustsScrollViewInsets = false
        tv.delegate = self
        tv.dataSource = self
        tv.tableFooterView = UIView()
        //获取数据
        getData()
        //初始化班级选择试图
        classBackgroundView = UIView(frame: CGRectMake(0,63,self.view.frame.width,self.view.frame.height))
        classBackgroundView?.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.3)
        classBackgroundView?.hidden = true
        //添加点击事件
        classBackgroundView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "closeClassBackgroundView"))
        self.view.addSubview(classBackgroundView!)
        //下拉刷新
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "refresh")
        header.lastUpdatedTimeLabel?.hidden = true
        self.tv.mj_header = header
        //上拉加载
        self.tv.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "loadData")
        //        tv.estimatedRowHeight = 100
    }
    
    //绑定数据
    func getData(type:Int = RefreshType.下拉刷新.rawValue){
        let url = API_URL + "/homeworks/"
        let token = Common.getToken()
        let headers = ["Authorization": "bearer \(token)"]
        let param = ["offset":pageIndex*pageSize,"limit":pageSize]
        self.view.makeToastActivity(position: HRToastPositionCenter, message: "数据加载中")
        Common.doRepuest(self, url: url, method: .GET, param: param,headers: headers, failed: { () -> Void in
            self.tv.mj_header.endRefreshing()
            self.tv.mj_footer.endRefreshing()
            }){ (response, json) -> Void in
                if type == RefreshType.下拉刷新.rawValue{
                    self.result = json["data"].array!
                    self.tv.mj_header.endRefreshing()
                    if self.result.count < self.pageSize{
                        self.tv.mj_footer.endRefreshingWithNoMoreData()
                    }
                    else{
                        self.tv.mj_footer.resetNoMoreData()
                    }
                    self.tv.reloadData()
                }
                else if type == RefreshType.上拉加载.rawValue{
                    self.tv.mj_footer.endRefreshing()
                    if json["data"].count == 0 || json["data"].count < self.pageSize{
                        self.tv.mj_footer.endRefreshingWithNoMoreData()
                    }
                    if json["data"].count > 0{
                        self.result += json["data"].array!
                        self.tv.reloadData()
                    }
                }
        }
    }
    
    //刷新数据
    func refresh(){
        pageIndex = 0
        getData(RefreshType.下拉刷新.rawValue)
    }
    
    //加载数据
    func loadData(){
        self.pageIndex++
        getData(RefreshType.上拉加载.rawValue)
    }
    
    @IBAction func selectClass(sender: AnyObject) {
        for view in (classBackgroundView?.subviews)!{
            view.removeFromSuperview()
        }
        let classView = UIView()
        classView.backgroundColor = UIColor(red:251/255, green:251/255, blue:251/255, alpha: 1)
        let allClsView = UIView()
        classView.addSubview(allClsView)
        let classList = ["二（1）班","二（2）班","二（3）班","二（4）班","二（5）班"]
        let leftMargin:CGFloat = 15
        let topMargin:CGFloat = 15
        var top:CGFloat = topMargin
        var i:CGFloat = 0
        let clsWidth:CGFloat = 90
        let clsHeight:CGFloat = 25
        var rightMargin:CGFloat = 0
        for cls in classList{
            if((i*(clsWidth+leftMargin) + clsWidth + leftMargin) > self.view.frame.width){
                top += clsHeight + topMargin
                rightMargin = self.view.frame.width - (i*(clsWidth+leftMargin)+leftMargin)
                i = 0
            }
            let clsLabel = UIButton(frame: CGRectMake(i*(clsWidth + leftMargin) + leftMargin,top,clsWidth,clsHeight))
            if cls == classBarButtonItem.title{
                clsLabel.backgroundColor = UIColor(red:211/255, green:211/255, blue:211/255, alpha: 1)
            }
            else{
                clsLabel.backgroundColor = UIColor.whiteColor()
            }
            clsLabel.layer.borderColor = UIColor(red:222/255, green:222/255, blue:222/255, alpha: 1).CGColor
            clsLabel.layer.borderWidth = 0.8
            clsLabel.titleLabel?.font = UIFont.systemFontOfSize(12)
            clsLabel.setTitleColor(UIColor.blackColor(), forState: .Normal)
            clsLabel.setTitle(cls, forState: .Normal)
            clsLabel.addTarget(self, action: "checkClass:", forControlEvents: .TouchUpInside)
            allClsView.addSubview(clsLabel)
            i++
        }
        allClsView.frame = CGRectMake(rightMargin/2,0,self.view.frame.width,top + topMargin + clsHeight)
        classView.frame = CGRectMake(0,0,self.view.frame.width,top + topMargin + clsHeight)
        classBackgroundView?.addSubview(classView)
        classBackgroundView?.hidden = false
        
    }
    
    func checkClass(btn:UIButton){
        //btn.backgroundColor = UIColor(red:200/255, green:200/255, blue:200/255, alpha: 1)
        classBackgroundView?.hidden = true
        classBarButtonItem.title = btn.titleLabel?.text
    }
    
    func closeClassBackgroundView(){
        classBackgroundView?.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tv.dequeueReusableCellWithIdentifier("ScrollCell", forIndexPath: indexPath)
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        
        cell.imageView?.image = UIImage(named: "judy.jpg")
        cell.imageView!.layer.cornerRadius = 16
        cell.imageView?.layer.masksToBounds = true
        
        let titleLabel = UILabel(frame: CGRectMake(70,12,cell.frame.width - 150,20))
        titleLabel.font = UIFont.systemFontOfSize(14)
        titleLabel.text = result[indexPath.row]["content"].string
        
        let dateLabel = UILabel(frame: CGRectMake(titleLabel.frame.origin.x + titleLabel.frame.width+5,12,80,20))
        dateLabel.font = UIFont.systemFontOfSize(12)
        dateLabel.textColor = UIColor.lightGrayColor()
        dateLabel.text = Common.dateFormateUTCDate(result[indexPath.row]["work_date"].stringValue,fmt: "yyyy-MM-dd")
        cell.contentView.addSubview(titleLabel)
        cell.contentView.addSubview(dateLabel)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tv.deselectRowAtIndexPath(indexPath, animated: true)
        homeworkId = result[indexPath.row]["id"].stringValue
        self.performSegueWithIdentifier("bookDetail", sender: Common.dateFormateUTCDate(result[indexPath.row]["work_date"].stringValue,fmt: "yyyy-MM-dd"))
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let detail = segue.destinationViewController as? BookDetailViewController{
            detail.navigationItem.title = sender as? String
            detail.homeworkId = self.homeworkId
        }
    }
    
}

//
//  SecondHandTableViewController.swift
//  IDAI360
//
//  Created by YaoJ on 15/12/14.
//  Copyright © 2015年 YaoJ. All rights reserved.
//

import UIKit

class SecondHandTableViewController: UITableViewController,UISearchBarDelegate,UISearchResultsUpdating {
    //接口获得的数据
    var result = [JSON]()
    //用于筛选的结果集
    var searchResult = [JSON]()
    //当前页数
    var pageIndex = 1
    //每页显示条数
    var pageSize = 10
    //搜索结果试图
    var searchController:UISearchController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        //下拉刷新
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "refresh")
        header.lastUpdatedTimeLabel?.hidden = true
        self.tableView.mj_header = header
        //上拉加载
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "loadData")
        //初始化UISearchController
        searchController = Common.initSearchController(self)
        self.tableView.tableHeaderView = searchController?.searchBar
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //解决cell分割线左边短的问题
        if cell.respondsToSelector(Selector("setSeparatorInset:")){
            cell.separatorInset = UIEdgeInsetsZero
        }
        if cell.respondsToSelector(Selector("setLayoutMargins:")){
            cell.layoutMargins = UIEdgeInsetsZero
        }
    }
    
    //绑定数据
    func getData(type:Int = RefreshType.下拉刷新.rawValue,let keyword:String? = nil){
        let url = API_URL + "/api/products"
        let token = Common.getToken()
        let param = ["token":token,"pageIndex":pageIndex,"pageSize":pageSize,"keyword":keyword ?? "","type":ProductType.二手转让.rawValue]
        self.view.makeToastActivity(position: HRToastPositionCenter, message: "数据加载中")
        Common.doRepuest(self, url: url, method: .GET, param: param as? [String : AnyObject],failed: { () -> Void in
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            }) { (response, json) -> Void in
                if type == RefreshType.下拉刷新.rawValue{
                    //筛选
                    if keyword != nil{
                        self.searchResult = json["data"].array!
                    }
                        //正常刷新
                    else{
                        self.result = json["data"].array!
                    }
                    self.tableView.mj_header.endRefreshing()
                    self.tableView.reloadData()
                    //暂时没有分页功能
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
                else if type == RefreshType.上拉加载.rawValue{
                    self.tableView.mj_footer.endRefreshing()
                    if json["data"].count == 0{
                        self.tableView.mj_footer.endRefreshingWithNoMoreData()
                    }
                    else{
                        self.searchResult += json["data"].array!
                        self.pageIndex++
                        self.tableView.reloadData()
                    }
                }
        }
    }
    
    //筛选数据
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let value = searchController.searchBar.text
        pageIndex = 1
        getData(RefreshType.下拉刷新.rawValue,keyword: value)
    }
    
    //刷新数据
    func refresh(){
        pageIndex = 1
        let keyword = self.searchController?.searchBar.text
        getData(RefreshType.下拉刷新.rawValue,keyword: keyword)
    }
    
    //加载数据
    func loadData(){
        let keyword = self.searchController?.searchBar.text
        getData(RefreshType.上拉加载.rawValue,keyword: keyword)
    }
    
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.searchController?.active == true{
            return self.searchResult.count
        }
        else{
            return result.count
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 90
        }
        else{
            return 45
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ScrollCell", forIndexPath: indexPath)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        for view in cell.subviews{
            if view.subviews.count > 0 || (view as? UILabel) != nil{
                view.removeFromSuperview()
            }
        }
        var cellData = result[indexPath.section]
        if self.searchController?.active == true{
            cellData = searchResult[indexPath.section]
        }
        if indexPath.row == 0{
            //上半部分视图
            let topView = UIView()
            //标题
            let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            titleLabel.text = cellData["Title"].string
            titleLabel.font = UIFont.boldSystemFontOfSize(16)
            var newsize = titleLabel.sizeThatFits(titleLabel.frame.size)
            var titleWidth = cell.frame.width/5*3
            if newsize.width < titleWidth{
                titleWidth = newsize.width
            }
            titleLabel.frame = CGRect(x: 10, y: 5, width: titleWidth, height: cell.frame.height/4)
            topView.addSubview(titleLabel)
            //付款周期
            let pmtCycleLabel = UILabel()
            pmtCycleLabel.text = cellData["PaymentCycle"].string
            pmtCycleLabel.backgroundColor = UIColor.orangeColor()
            pmtCycleLabel.textColor = UIColor.whiteColor()
            pmtCycleLabel.font = UIFont.systemFontOfSize(12)
            pmtCycleLabel.textAlignment = .Center
            newsize = pmtCycleLabel.sizeThatFits(pmtCycleLabel.frame.size)
            pmtCycleLabel.frame = CGRect(x: titleLabel.frame.width+20, y: 6, width: newsize.width+8, height: cell.frame.height/5)
            //pmtCycleLabel.numberOfLines=0
            //pmtCycleLabel.lineBreakMode=NSLineBreakMode.ByCharWrapping
            //设置圆角
            pmtCycleLabel.clipsToBounds = true
            pmtCycleLabel.layer.cornerRadius = 8
            topView.addSubview(pmtCycleLabel)
            //还款方式
            let repaymentLabel = UILabel()
            repaymentLabel.text = cellData["Repayment"].string
            repaymentLabel.backgroundColor = UIColor.orangeColor()
            repaymentLabel.textColor = UIColor.whiteColor()
            repaymentLabel.font = UIFont.systemFontOfSize(12)
            repaymentLabel.textAlignment = .Center
            newsize = repaymentLabel.sizeThatFits(repaymentLabel.frame.size)
            repaymentLabel.frame = CGRect(x: pmtCycleLabel.frame.width + titleLabel.frame.width + 25, y: 6, width: newsize.width+8, height: cell.frame.height/5)
            //设置圆角
            repaymentLabel.clipsToBounds = true
            repaymentLabel.layer.cornerRadius = 8
            topView.addSubview(repaymentLabel)
            //期数
            let cycleLabel = UILabel(frame: CGRect(x: 10, y:titleLabel.frame.height + 2, width: 30, height: cell.frame.height/4))
            cycleLabel.text = "期数:"
            cycleLabel.textColor = UIColor.grayColor()
            cycleLabel.font = UIFont.systemFontOfSize(12)
            topView.addSubview(cycleLabel)
            //当前期数
            let currentCycleLabel = UILabel(frame: CGRect(x: 38, y: titleLabel.frame.height + 2, width: 35, height: cell.frame.height/4))
            currentCycleLabel.text = cellData["Cycle"].string
            currentCycleLabel.textColor = MAIN_COLOR
            currentCycleLabel.font = UIFont.systemFontOfSize(12)
            topView.addSubview(currentCycleLabel)
            //发行人
            let issuerLabel = UILabel(frame: CGRect(x: 80, y: titleLabel.frame.height + 2, width: cell.frame.width - 80, height: cell.frame.height/4))
            issuerLabel.text = cellData["Issuer"].string
            issuerLabel.textColor = UIColor.grayColor()
            issuerLabel.font = UIFont.systemFontOfSize(12)
            topView.addSubview(issuerLabel)
            
            
            cell.addSubview(topView)
            
            //添加分割线
            let fgx = UIView(frame: CGRect(x: 10, y: cell.frame.height/2+3, width: cell.frame.width-20, height: 0.5))
            fgx.backgroundColor = self.tableView.separatorColor
            cell.addSubview(fgx)
            
            //下半部分试图
            let bottomView = UIView(frame: CGRect(x: 0, y: cell.frame.height/2+7, width: cell.frame.width, height: cell.frame.height/2-1))
            //第一列
            let interestLabel = UILabel(frame: CGRect(x: 0, y:0, width: cell.frame.width/3-1, height: cell.frame.height/4))
            interestLabel.text = cellData["Irr"].string
            interestLabel.textColor = UIColor.orangeColor()
            interestLabel.font = UIFont.systemFontOfSize(14)
            interestLabel.textAlignment = NSTextAlignment.Center
            bottomView.addSubview(interestLabel)
            let interestDesLabel = UILabel(frame: CGRect(x: 0, y:cell.frame.height/4-4, width: cell.frame.width/3-1, height: cell.frame.height/4))
            interestDesLabel.text = "报价利率"
            interestDesLabel.textColor = UIColor.grayColor()
            interestDesLabel.font = UIFont.systemFontOfSize(12)
            interestDesLabel.textAlignment = NSTextAlignment.Center
            bottomView.addSubview(interestDesLabel)
            let interestFgx = UIView(frame: CGRect(x: cell.frame.width/3, y: 10, width: 0.5, height: cell.frame.height/2-20))
            interestFgx.backgroundColor = self.tableView.separatorColor
            bottomView.addSubview(interestFgx)
            //第二列
            let cashLabel = UILabel(frame: CGRect(x: cell.frame.width/3+1, y:0, width: cell.frame.width/3-1, height: cell.frame.height/4))
            cashLabel.text = cellData["Quotation"].string
            cashLabel.font = UIFont.systemFontOfSize(14)
            cashLabel.textAlignment = NSTextAlignment.Center
            bottomView.addSubview(cashLabel)
            let cashDesLabel = UILabel(frame: CGRect(x: cell.frame.width/3+1, y:cell.frame.height/4-4, width: cell.frame.width/3-1, height: cell.frame.height/4))
            cashDesLabel.text = "产品报价"
            cashDesLabel.textColor = UIColor.grayColor()
            cashDesLabel.font = UIFont.systemFontOfSize(12)
            cashDesLabel.textAlignment = NSTextAlignment.Center
            bottomView.addSubview(cashDesLabel)
            let cashFgx = UIView(frame: CGRect(x: cell.frame.width/3*2, y: 10, width: 0.5, height: cell.frame.height/2-20))
            cashFgx.backgroundColor = self.tableView.separatorColor
            bottomView.addSubview(cashFgx)
            //第三列
            let countLabel = UILabel(frame: CGRect(x: cell.frame.width/3*2+1, y:0, width: cell.frame.width/3-1, height: cell.frame.height/4))
            countLabel.text = cellData["Quantity"].string
            countLabel.font = UIFont.systemFontOfSize(14)
            countLabel.textAlignment = NSTextAlignment.Center
            bottomView.addSubview(countLabel)
            let countDesLabel = UILabel(frame: CGRect(x: cell.frame.width/3*2+1, y:cell.frame.height/4-4, width: cell.frame.width/3-1, height: cell.frame.height/4))
            countDesLabel.text = "在售数量"
            countDesLabel.textColor = UIColor.grayColor()
            countDesLabel.font = UIFont.systemFontOfSize(12)
            countDesLabel.textAlignment = NSTextAlignment.Center
            bottomView.addSubview(countDesLabel)
            
            cell.addSubview(bottomView)
        }
        else if indexPath.row == 1{
            //左半部分视图
            let leftView = UIView(frame: CGRect(x: 10, y: 8, width: cell.frame.width - 110, height: cell.frame.height))
            //灰色部分文字
            let leftLabel = UILabel(frame: CGRect(x: 0,y: 0,width: 0,height: 0))
            leftLabel.text = "项目进度"
            leftLabel.textColor = UIColor.grayColor()
            leftLabel.font = UIFont.systemFontOfSize(12)
            //自适应宽度
            let content:NSString = leftLabel.text!
            let size = content.sizeWithAttributes([NSFontAttributeName : leftLabel.font])
            leftLabel.frame = CGRect(x: 0, y: 5, width: size.width, height: leftView.frame.height/2-5)
            leftView.addSubview(leftLabel)
            //红色部分文字
            let rightLabel = UILabel()
            rightLabel.text = "\(cellData["Progress"].stringValue)%"
            rightLabel.textColor = MAIN_COLOR
            rightLabel.font = UIFont.systemFontOfSize(12)
            rightLabel.textAlignment = NSTextAlignment.Left
            let newsize = rightLabel.sizeThatFits(rightLabel.frame.size)
            rightLabel.frame = CGRect(x: size.width, y: 5, width: newsize.width, height: leftView.frame.height/2-5)
            leftView.addSubview(rightLabel)
            //进度条
            let progressBar = UIProgressView(frame: CGRect(x: 0, y: leftView.frame.height/2+5, width: leftView.frame.width-30, height: 20))
            progressBar.progress = cellData["Progress"].floatValue/100
            progressBar.progressTintColor = MAIN_COLOR
            leftView.addSubview(progressBar)
            //结束日期
            let dateLabel = UILabel(frame: CGRect(x: leftLabel.frame.width+rightLabel.frame.width+5, y: 5, width: cell.frame.width, height: leftView.frame.height/2-5))
            dateLabel.text = "结束日期:\(cellData["EndTime"].stringValue)"
            dateLabel.textColor = UIColor.grayColor()
            dateLabel.font = UIFont.systemFontOfSize(12)
            leftView.addSubview(dateLabel)
            
            //右半部分试图
            let rightView = UIView(frame: CGRect(x: leftView.frame.width+3, y: 3, width: cell.frame.width - leftView.frame.width-5, height: cell.frame.height))
            let button = UIButton(frame: CGRect(x: 20, y: 3, width: rightView.frame.width-30, height: rightView.frame.height-12))
            button.backgroundColor = MAIN_COLOR
            button.setTitle("我要买", forState: UIControlState.Normal)
            button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            button.titleLabel?.font = UIFont.systemFontOfSize(14)
            button.layer.cornerRadius = 3
            rightView.addSubview(button)
            button.tag = indexPath.section
            button.addTarget(self, action: "buy:", forControlEvents: UIControlEvents.TouchUpInside)
            cell.addSubview(leftView)
            cell.addSubview(rightView)
        }
        else if indexPath.row == 2{
            let memoLabel = UILabel(frame: CGRect(x: 5,y: 0,width: cell.frame.width-5,height: cell.frame.height))
            memoLabel.text = cellData["Description"].string
            memoLabel.numberOfLines = 2
            memoLabel.textColor = UIColor.grayColor()
            memoLabel.font = UIFont.systemFontOfSize(12)
            cell.addSubview(memoLabel)
        }
        return cell
    }
    
    func buy(btn:UIButton){
        //判断是否登录
        let user = Common.loadDefault("user")
        if user == nil {
            self.tabBarController!.performSegueWithIdentifier("login", sender: nil)
        }
        else{
            self.performSegueWithIdentifier("second", sender: btn.tag)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        for view in segue.destinationViewController.childViewControllers{
            if let buy = view as? BuyViewController{
                let index = (sender as? Int)!
                buy.navTitle = self.result[index]["Title"].stringValue
                buy.detailId = result[index]["DetailId"].intValue
                buy.type = result[index]["Type"].intValue
                buy.seniority = Seniority(rawValue: result[index]["seniority"].intValue)
            }
        }
    }
    
}

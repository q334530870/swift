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
        classBackgroundView = UIView(frame: CGRect(x: 0,y: 63,width: self.view.frame.width,height: self.view.frame.height))
        classBackgroundView?.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        classBackgroundView?.isHidden = true
        //添加点击事件
        classBackgroundView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(BookViewController.closeClassBackgroundView)))
        self.view.addSubview(classBackgroundView!)
        //下拉刷新
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(BookViewController.refresh))
        header?.lastUpdatedTimeLabel?.isHidden = true
        self.tv.mj_header = header
        //上拉加载
        self.tv.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(BookViewController.loadData))
        //        tv.estimatedRowHeight = 100
    }
    
    //绑定数据
    func getData(_ type:Int = RefreshType.下拉刷新.rawValue){
        let url = API_URL + "/homeworks/"
        let token = Common.getToken()
        let headers = ["Authorization": "bearer \(token)"]
        let param = ["offset":pageIndex*pageSize,"limit":pageSize]
        self.view.makeToastActivity(position: HRToastPositionCenter as AnyObject, message: "数据加载中")
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
        self.pageIndex += 1
        getData(RefreshType.上拉加载.rawValue)
    }
    
    @IBAction func selectClass(_ sender: AnyObject) {
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
            let clsLabel = UIButton(frame: CGRect(x: i*(clsWidth + leftMargin) + leftMargin,y: top,width: clsWidth,height: clsHeight))
            if cls == classBarButtonItem.title{
                clsLabel.backgroundColor = UIColor(red:211/255, green:211/255, blue:211/255, alpha: 1)
            }
            else{
                clsLabel.backgroundColor = UIColor.white
            }
            clsLabel.layer.borderColor = UIColor(red:222/255, green:222/255, blue:222/255, alpha: 1).cgColor
            clsLabel.layer.borderWidth = 0.8
            clsLabel.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            clsLabel.setTitleColor(UIColor.black, for: UIControlState())
            clsLabel.setTitle(cls, for: UIControlState())
            clsLabel.addTarget(self, action: #selector(BookViewController.checkClass(_:)), for: .touchUpInside)
            allClsView.addSubview(clsLabel)
            i += 1
        }
        allClsView.frame = CGRect(x: rightMargin/2,y: 0,width: self.view.frame.width,height: top + topMargin + clsHeight)
        classView.frame = CGRect(x: 0,y: 0,width: self.view.frame.width,height: top + topMargin + clsHeight)
        classBackgroundView?.addSubview(classView)
        classBackgroundView?.isHidden = false
        
    }
    
    func checkClass(_ btn:UIButton){
        //btn.backgroundColor = UIColor(red:200/255, green:200/255, blue:200/255, alpha: 1)
        classBackgroundView?.isHidden = true
        classBarButtonItem.title = btn.titleLabel?.text
    }
    
    func closeClassBackgroundView(){
        classBackgroundView?.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tv.dequeueReusableCell(withIdentifier: "ScrollCell", for: indexPath)
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        
        cell.imageView?.image = UIImage(named: "judy.jpg")
        cell.imageView!.layer.cornerRadius = 16
        cell.imageView?.layer.masksToBounds = true
        
        let titleLabel = UILabel(frame: CGRect(x: 70,y: 12,width: cell.frame.width - 150,height: 20))
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.text = result[indexPath.row]["content"].string
        
        let dateLabel = UILabel(frame: CGRect(x: titleLabel.frame.origin.x + titleLabel.frame.width+5,y: 12,width: 80,height: 20))
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = UIColor.lightGray
        dateLabel.text = Common.dateFormateUTCDate(result[indexPath.row]["work_date"].stringValue,fmt: "yyyy-MM-dd")
        cell.contentView.addSubview(titleLabel)
        cell.contentView.addSubview(dateLabel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tv.deselectRow(at: indexPath, animated: true)
        homeworkId = result[indexPath.row]["id"].stringValue
        self.performSegue(withIdentifier: "bookDetail", sender: Common.dateFormateUTCDate(result[indexPath.row]["work_date"].stringValue,fmt: "yyyy-MM-dd"))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detail = segue.destination as? BookDetailViewController{
            detail.navigationItem.title = sender as? String
            detail.homeworkId = self.homeworkId
        }
    }
    
}

import UIKit

class InstallmentMonthlyViewController: UITableViewController{
    
    var productId = 0
    var seniority:Seniority?
    //接口获得的数据
    var result = [JSON]()
    //当前页数
    var pageIndex = 1
    //每页显示条数
    var pageSize = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //模拟数据
        //data.append(("","A份",""))
        getData()
        //下拉刷新
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "refresh")
        header.lastUpdatedTimeLabel?.hidden = true
        self.tableView.mj_header = header
        //上拉加载
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "loadData")
        //设置表格尾部（去除多余cell线）
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    //绑定数据
    func getData(type:Int = RefreshType.下拉刷新.rawValue){
        let url = API_URL + "/api/products"
        let token = Common.getToken()
        //let param = ["token":token,"pageIndex":pageIndex,"pageSize":pageSize,"type":ProductType.推荐区.rawValue]
        let param = ["token":token,"action":"RepaymentPlan","productId":productId,"seniority":seniority!.rawValue]
        self.view.makeToastActivity(position: HRToastPositionCenter, message: "数据加载中")
        Common.doRepuest(self, url: url, method: .GET, param: param as? [String : AnyObject],failed: { () -> Void in
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            }){ (response, json) -> Void in
                if type == RefreshType.下拉刷新.rawValue{
                    self.result = json["data"].array!
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
                        self.result += json["data"].array!
                        self.pageIndex += 1
                        self.tableView.reloadData()
                    }
                }
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //固定table中的headerView
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 40))
        headerView.backgroundColor = UIColor.whiteColor()
        let left = UILabel(frame: CGRect(x: 10, y: 0, width: headerView.frame.width/3-15, height: 40))
        left.font = UIFont.systemFontOfSize(14)
        left.textColor = UIColor.grayColor()
        left.text = "到期日"
        let center = UILabel(frame: CGRect(x: headerView.frame.width/3+10, y: 0, width: headerView.frame.width/3-15, height: 40))
        center.font = UIFont.systemFontOfSize(14)
        center.textAlignment = .Center
        center.textColor = UIColor.grayColor()
        center.text = "本金"
        let right = UILabel(frame: CGRect(x: headerView.frame.width/3*2+10, y: 0, width: headerView.frame.width/3-20, height: 40))
        right.font = UIFont.systemFontOfSize(14)
        right.textAlignment = .Right
        right.textColor = UIColor.grayColor()
        right.text = "利息"
        headerView.addSubview(left)
        headerView.addSubview(center)
        headerView.addSubview(right)
        return headerView
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ScrollCell", forIndexPath: indexPath)
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        let left = UILabel(frame: CGRect(x: 10, y: 0, width: cell.frame.width/3-15, height: 40))
        left.font = UIFont.systemFontOfSize(12)
        left.text = result[indexPath.row]["EndDate"].stringValue
        let center = UILabel(frame: CGRect(x: cell.frame.width/3+10, y: 0, width: cell.frame.width/3-15, height: 40))
        center.text = result[indexPath.row]["Principle"].stringValue
        if center.text == "A份" || center.text == "B份"{
            center.textColor = MAIN_COLOR
        }
        else{
            center.textColor = UIColor.redColor()
        }
        center.font = UIFont.systemFontOfSize(12)
        center.textAlignment = .Center
        let right = UILabel(frame: CGRect(x: cell.frame.width/3*2+10, y: 0, width: cell.frame.width/3-20, height: 40))
        right.font = UIFont.systemFontOfSize(12)
        right.textAlignment = .Right
        right.text = result[indexPath.row]["Interest"].stringValue
        cell.contentView.addSubview(left)
        cell.contentView.addSubview(center)
        cell.contentView.addSubview(right)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("InstallmentMonthlyDetail", sender:indexPath.row )
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let trade = segue.destinationViewController as? InstallmentMonthlyDetailTableViewController{
            trade.navigationItem.title = "还款计划明细"
            trade.result = result[(sender as? Int)!]
        }
    }
    
}

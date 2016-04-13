//
//  TradeDetailTableViewController.swift
//  IDAI360
//
//  Created by YaoJ on 15/12/17.
//  Copyright © 2015年 YaoJ. All rights reserved.
//

import UIKit

class TradeDetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    var detailInfo = [(key:String,value:String)]()
    var dataDetail:JSON?
    var detailType:Payment?
    var hasOperate = false
    var delegate:MyTradeViewController?
    
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tvBottom: NSLayoutConstraint!
    
    @IBOutlet weak var tv: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        //隐藏操作按钮，调整表格高度
        if !hasOperate{
            payButton.hidden = true
            cancelButton.hidden = true
            tvBottom.constant = 0
        }
        else if hasOperate && detailType == Payment.交易付款{
            if dataDetail!["认购金额"] == dataDetail!["已付认购款"]{
                payButton.hidden = true
                cancelButton.hidden = true
                tvBottom.constant = 0
            }
        }
        if detailType == Payment.我的持仓量{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "明细", style: .Plain, target: self, action: #selector(TradeDetailViewController.dt))
        }
        //设置表格尾部（去除多余cell线）
        tv.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    func dt(){
        self.performSegueWithIdentifier("unwindToMyTrade", sender: nil)
    }
    
    //模拟数据
    func loadData(){
        
        var titleList:[String] = []
        switch detailType!{
        case Payment.交易付款:
            titleList = ["认购单","条件结束日期","产品名称","年化收益率","认购份数","单价","认购金额","已付认购款","预期收益金额","还款方式","还款周期","到期时间"]
            break
        case Payment.我的持仓量:
            titleList = ["产品","今日平价","在售量","持有量","购买价","购买价余额","条件持有量","条件购买价","条件购买价余额","总积数","总利息","未清本息余额","累计支付本息"]
            break
        case Payment.买入成交单,Payment.卖出成交单:
            titleList = ["认购单","成交时间","交易对手","产品","数量","价格","交易报酬率","过息额","过息价","保证金支付","合计付款","交易条款","初发","条件交易","毕业时间","毕业结果"]
            break
        case Payment.现金日记账:
            titleList = ["合计行","类别","凭证号","日期","摘要","参考号","期初余额","收入","支出","期末余额","金额"]
            break
        case Payment.到期本息支付:
            titleList = ["日期","产品","付款周期","数量","过息金额","利息积数","持有生息","本金到期","本息合计","已付金额","应付余额","付款截止时间"]
            break
        case Payment.投资损益表:
            titleList = ["科目名称","金额_TT","金额_T0","金额_T1"]
            break
        case Payment.将到期本息汇总:
            titleList = ["发行人","产品","付款周期","数量","过息金额","利息积数","已持有生息","持有到期生息","本金到期","本息合计","截止时间","会计期间","条件持有量"]
            break
        case Payment.产品变动:
            titleList = ["product","SaleBuy","购售类","日期","交易类","成交单","初发","交易条款","成交量","报酬率","支付金额","交割量","条件持有量","退回量"]
            break
        default:
            break
        }
        if titleList.count > 0{
            for title in titleList{
                detailInfo.append((title,dataDetail![title].stringValue))
            }
        }
        else{
            for dt in (dataDetail?.dictionary)!{
                if (dt.0 != "subscription_detail_id" && dt.0 != "pid" && dt.0 != "seniority")
                {
                    detailInfo.append((dt.0,dt.1.stringValue))
                }
            }
        }
        if detailType == Payment.交易付款{
            hasOperate = true
        }
    }
    
    //设置读取字段顺序
    func getSort(type:Int){
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailInfo.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ScrollCell", forIndexPath: indexPath)
        cell.textLabel?.text = detailInfo[indexPath.row].key
        cell.detailTextLabel?.text = detailInfo[indexPath.row].value
        return cell
    }
    
    //付款
    @IBAction func pay(sender: AnyObject) {
        let url = API_URL + "/api/payment"
        let token = Common.getToken()
        let param = ["token":token,"id":dataDetail!["subscription_detail_id"].stringValue]
        self.view.makeToastActivity(position: HRToastPositionCenter, message: "数据加载中")
        Common.doRepuest(self, url: url, method: .GET, param: param, failed: nil) { (response, json) -> Void in
            //获取本次应付金额
            let alertController = UIAlertController(title: "本次付款金额", message: "应付余额：\(json["data"]["应付余额"])", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addTextFieldWithConfigurationHandler { (tf) -> Void in
                tf.text = "\(json["data"]["本次付款"])"
                tf.textAlignment = .Center
            }
            let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Destructive,handler:{ (alertSheet) -> Void in
                //确认付款
                let amount = alertController.textFields![0].text
                if amount == nil{
                    Common.showAlert(self, title: "", message: "请填写本次应付金额")
                }
                else if amount > json["data"]["应付余额"].stringValue{
                    Common.showAlert(self, title: "", message: "本次付款超过应付余额")
                }
                else{
                    let url = API_URL + "/api/payment"
                    let token = Common.getToken()
                    let param = ["token":token,"id":self.dataDetail!["subscription_detail_id"].stringValue,"amount":amount!]
                    self.view.makeToastActivity(position: HRToastPositionCenter, message: "数据加载中")
                    Common.doRepuest(self, url: url, method: .PUT, param: param, failed: nil) { (response, json) -> Void in
                        if json["code"] == "success"{
                            self.delegate?.getData()
                            Common.showAlert(self, title: "", message: json["message"].stringValue, ok: { (action) -> Void in
                                self.navigationController?.popViewControllerAnimated(true)
                            })
                        }
                    }
                }
                
            } )
            let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler:nil)
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            //            if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {
            //                let popPresenter = alertController.popoverPresentationController
            //                popPresenter!.sourceView = sender as? UIView
            //                popPresenter!.sourceRect = sender.bounds
            //            }
            self.presentViewController(alertController, animated: false, completion: nil)
        }
    }
    
    //取消
    @IBAction func cancel(sender: AnyObject) {
        let alertController = UIAlertController(title: "", message: "确定要取消吗？", preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler:nil)
        let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Destructive){ (act) -> Void in
            let url = API_URL + "/api/payment"
            let token = Common.getToken()
            let param = ["token":token,"id":self.dataDetail!["subscription_detail_id"].stringValue]
            self.view.makeToastActivity(position: HRToastPositionCenter, message: "数据加载中")
            Common.doRepuest(self, url: url, method: .DELETE, param: param, failed: nil) { (response, json) -> Void in
                if json["code"] == "success"{
                    Common.showAlert(self, title: "", message: json["message"].stringValue, ok: { (action) -> Void in
                        self.delegate?.getData()
                        self.navigationController?.popViewControllerAnimated(false)
                    })
                }
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}

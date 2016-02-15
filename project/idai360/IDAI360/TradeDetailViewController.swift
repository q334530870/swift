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
        //设置表格尾部（去除多余cell线）
        tv.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    override func viewWillAppear(animated: Bool) {
        if let tabBar = self.tabBarController?.tabBar{
            tabBar.hidden = true
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        if let tabBar = self.tabBarController?.tabBar{
            tabBar.hidden = false
        }
    }
    
    //模拟数据
    func loadData(){
        for dt in (dataDetail?.dictionary)!{
            if dt.0 != "subscription_detail_id"
            {
                detailInfo.append((dt.0,dt.1.stringValue))
            }
        }
        if detailType == Payment.待确认{
            hasOperate = true
        }
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
            self.presentViewController(alertController, animated: true, completion: nil)
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
                        self.navigationController?.popViewControllerAnimated(true)
                    })
                }
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

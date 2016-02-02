//
//  MyIdaiViewController.swift
//  IDAI360
//
//  Created by YaoJ on 15/12/8.
//  Copyright © 2015年 YaoJ. All rights reserved.
//

import UIKit

class MyIdaiViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    var navBarHairlineImageView:UIImageView!
    var jump = ""
    var jumpFilter = ""
    
    @IBOutlet weak var bnjqyqsyl: UILabel!
    @IBOutlet weak var bnly: UILabel!
    @IBOutlet weak var sxsy: UILabel!
    @IBOutlet weak var dqjq: UILabel!
    @IBOutlet weak var dqzsy: UILabel!
    @IBOutlet weak var cy: UILabel!
    @IBOutlet weak var tzp: UILabel!
    @IBOutlet weak var tz: UILabel!
    @IBOutlet weak var zc: UILabel!
    @IBOutlet weak var ye: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        //获得导航下面的实现
        navBarHairlineImageView = Common.findHairlineImageViewUnder((self.navigationController?.navigationBar)!)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        //隐藏导航下面的实线
        navBarHairlineImageView.hidden = true
        //购买后跳转我的投资列表
        if jump != ""{
            if jumpFilter == "Sell"{
                let controller = (self.storyboard?.instantiateViewControllerWithIdentifier(jump))! as! MyTradeViewController
                controller.selectCell = Payment.我的卖出成交单
                self.navigationController?.pushViewController(controller, animated: true)
            }
            else{
                let controller = (self.storyboard?.instantiateViewControllerWithIdentifier(jump))!
                self.navigationController?.pushViewController(controller, animated: true)
            }
            
            jump = ""
        }
        //刷新数据
        getData()
    }
    
    func getData(){
        let url = API_URL + "/api/account"
        let token = String(Common.loadDefault("token")!)
        let param = ["token":token,"action":"PersonInfo"]
        self.view.makeToastActivity(position: HRToastPositionCenter, message: "数据加载中")
        Common.doRepuest(self, url: url, method: .GET, param: param) { (response, json) -> Void in
            self.ye.text = json["data"]["banlace"].string
            self.zc.text = json["data"]["cyzcze"].string
            self.tz.text = json["data"]["cytzz"].string
            self.tzp.text = json["data"]["cytzp"].string
            self.cy.text = json["data"]["tjcyp"].string
            self.dqzsy.text = json["data"]["cydqzsy"].string
            self.dqjq.text = json["data"]["cydqjqsyl"].string
            self.sxsy.text = json["data"]["bnysxsy"].string
            self.bnly.text = json["data"]["bnsysjjyq"].string
            self.bnjqyqsyl.text = json["data"]["bnjqyqsyl"].string
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        //显示导航下面的实现（其他页面）
        navBarHairlineImageView.hidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

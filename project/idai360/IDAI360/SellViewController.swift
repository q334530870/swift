//
//  SellViewController.swift
//  IDAI360
//
//  Created by YaoJ on 16/2/1.
//  Copyright © 2016年 YaoJ. All rights reserved.
//

import UIKit

class SellViewController: UIViewController {
    
    var navTitle:String?
    var agree = false
    var size:CGFloat = 0
    var detailId:Int = 0
    var type:Int = 0
    var productId = 0
    var seniority:Seniority?
    var model:JSON?
    
    var jp:JPick?
    
    var animateView:SXWaveView?
    
    @IBOutlet weak var tk: UITextField!
    @IBOutlet weak var redView: UIView!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var count: UITextField!
    @IBOutlet weak var ok: UIImageView!
    
    @IBOutlet weak var bj: UILabel!
    @IBOutlet weak var sl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //初始化选择框
        jp = JPick(target: self.view,textField:tk,frame: CGRectMake(0,self.view.frame.height - self.view.frame.height / 3,self.view.frame.width,self.view.frame.height / 3+50))
        //获取数据
        getData()
        //设置圆角
        redView.layer.cornerRadius = redView.frame.width / 2
        self.navigationItem.title = navTitle
        //添加键盘显示通知，获得键盘高度
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardShouldShow:", name: UIKeyboardDidShowNotification, object: nil)
    }
    
    //获取数据
    func getData(){
        let url = API_URL + "/api/products"
        let token = String(Common.loadDefault("token")!)
        let param = ["token":token,"detailId":detailId,"type":type]
        self.view.makeToastActivity(position: HRToastPositionCenter, message: "数据加载中")
        Common.doRepuest(self, url: url, method: .GET, param: param as? [String : AnyObject]) { (response, json) -> Void in
            if json["data"].count > 0{
                self.model = json["data"][0]
                self.bindData()
                //红球动画
                self.animateView = SXWaveView(frame: CGRectMake(0,0,self.redView.frame.width,self.redView.frame.height))
                self.animateView?.layer.cornerRadius = (self.animateView?.frame.width)! / 2
                self.redView.addSubview(self.animateView!)
                var irr = self.model!["Irr"].stringValue
                irr.removeAtIndex(irr.endIndex.predecessor())
                self.animateView?.setPrecent(Int32(irr)! , description: "报价利率", textColor: UIColor.whiteColor(), bgColor: UIColor(red: 255/255, green: 102/255, blue: 102/255, alpha: 1), alpha: 1, clips: false)
                self.animateView?.addAnimateWithType(0)
            }
        }
    }
    
    //绑定数据
    func bindData(){
        bj.text = model!["Quotation"].string
        sl.text = model!["Quantity"].string
        productId = model!["ProductId"].intValue
        //tk.text = model!["OrderTerm"].stringValue
        let ot = model!["OrderTerm"].stringValue
        //初始化pickList
        jp!.pickList = [("请选择","")]
        for o in ot.characters.split("|"){
            //初始化pickView
            let temp = String(o).characters.split(",")
            jp!.pickList.append((String(temp[1]),String(temp[0])))
        }
    }
    
    //检查数量
    @IBAction func checkCount(sender: AnyObject) {
        if let ct = sender as? UITextField{
            if Int64(ct.text!) == 0{
                ct.text = ""
            }
        }
        checkNext()
    }
    //键盘出现时获得键盘高度，并让view向上移动
    func keyboardShouldShow(notification:NSNotification){
        var info:Dictionary = notification.userInfo!
        size = (info[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size.height)!
        let countSize = count.frame.origin.y
        //如果底部空间不足，就上移
        if self.view.frame.height - countSize < size{
            self.view.frame.origin.y = -size
        }
    }
    
    //键盘消失时让view向下移动
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        if textField.text == ""{
            textField.text = "0"
        }
        self.view.frame.origin.y = 0
        return true
    }
    
    //协议回调函数
    @IBAction func unwindToBuy(segue: UIStoryboardSegue){
        agree = true
        ok.image = UIImage(named: "ok")
        checkNext()
    }
    
    //点击空白处隐藏键盘
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //检查是否可以进入下一步
    func checkNext(){
        if(agree == true && count.text != nil && Int64(count.text!) > 0){
            self.buyButton.enabled = true
            self.buyButton.alpha = 1
        }
        else{
            self.buyButton.enabled = false
            self.buyButton.alpha = 0.5
        }
    }
    
    @IBAction func buy(sender: AnyObject) {
        if tk.text == "" || jp!.pickValue == ""{
            Common.showAlert(self, title: "", message: "请选择交易条款")
        }
        else{
            let url = API_URL + "/api/products"
            let token = Common.getToken()
            let param = ["token":token,"id":model!["DetailId"].stringValue,"quantity":count.text!,"type":type,"orderterm":jp!.pickValue]
            self.view.makeToastActivity(position: HRToastPositionCenter, message: "数据加载中")
            Common.doRepuest(self, url: url, method: .POST, param: param as? [String : AnyObject], failed: nil) { (response, json) -> Void in
                self.performSegueWithIdentifier("BuyToMyTrade", sender: nil)
            }
        }
        
    }
    
    //关闭当前页面
    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let comment = segue.destinationViewController as? CommentTableViewController{
            comment.productId = productId
        }
        else if let tradeLog = segue.destinationViewController as? TradeLogTableViewController{
            tradeLog.productId = productId
            tradeLog.seniority = seniority
        }
        else if let monthly = segue.destinationViewController as? InstallmentMonthlyViewController{
            monthly.productId = productId
            monthly.seniority = seniority
        }
        else{
            let destination = segue.destinationViewController as? InfoViewController
            if destination == nil{
                for child in (segue.destinationViewController.childViewControllers){
                    if let info = child as? InfoViewController{
                        info.segue = "buySegue"
                        info.content = "尊敬的各位用户，首先感谢大家对爱贷360的关注和支持！\r爱贷360团队是一支优秀的、年轻的、充满热情的一支队伍。经过3年的沉淀和积累，1年的精心策划，6个月的研发。爱贷360在P2P网络借贷平台迅速发展的今天正式成立并面向大家了！\r爱贷360是基于目前中国民间资本发展现状应运而生的，它是一个新的阳光化产业，同时借助于网络高新技术的支持，爱贷360专注网络金融服务领域，力求为民间资本创造一个安全、高效、公正的流通互动平台，并引入多家第三方担保机构和第三方支付平台，为投资人做好正确的引导和投资保障。\r爱贷360为资金需求者提供了一条新的融资渠道，为投资者拓宽了投资渠道。激活了民间处于低使用率状态的资金，让它们更好的服务于广大需求者。爱贷360平台完善的审核制度、监管制度、保障制度将为我们未来的公信度建设打下坚实的基础，为未来的整体发展做好准备。\r我们坚信，在我国社会信用体系、网络技术、服务水平不断完善和提高的过程中，爱贷360团队将不惜一切努力做到最好，用服务赢得口碑，用态度实现承诺，用实力证明能力，打造出中国最诚信最可靠的P2P网络借贷平台。"
                    }
                }
            }
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

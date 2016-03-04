//
//  MyIdaiViewController.swift
//  IDAI360
//
//  Created by YaoJ on 15/12/8.
//  Copyright © 2015年 YaoJ. All rights reserved.
//

import UIKit

class MyIdaiViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MWPhotoBrowserDelegate,UITabBarDelegate {
    
    var topView:UIView!
    @IBOutlet var tv: UITableView!
    var buttonList = [(title:String,image:String)]()
    var navBarHairlineImageView:UIImageView!
    var jump = ""
    var jumpFilter = ""
    var avatorButton:PopButton!
    var name: UILabel!
    var phone: UILabel!
    var yeValue:UILabel!
    var user:JSON?
    var imagePick:UIImagePickerController?
    var cellData = [(title:String,detail:String,segue:String,type:Payment)]()
    var gatherData = [(title:String,detail:String,segue:String,type:Gather)]()
    var otherData = [(title:String,detail:String,segue:String)]()
    var imageList = [String]()
    var titleList = [[(title:String,value:String)]]()
    var sectionList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sectionList = ["过程中...","现金余额","利息汇总","本息汇总"]
        
        //初始化按钮标题和图片
        buttonList = [("\(Payment(rawValue: 0)!)","wait"),("\(Payment(rawValue: 1)!)","in"),("\(Payment(rawValue: 2)!)","finish")]
        //初始化头部隐藏view
        topView = UIView(frame: CGRectMake(0,-10000,self.view.frame.width,10000))
        topView.backgroundColor = MAIN_COLOR
        self.view.addSubview(topView)
        //初始化表格头部
        let head = UIView(frame: CGRectMake(0,0,self.view.frame.width,self.view.frame.width/4*2+2+130))
        let headerView = UIView(frame: CGRectMake(0,0,self.view.frame.width,60))
        headerView.backgroundColor = MAIN_COLOR
        //绑定用户信息
        let user = Common.getCurrentUser()
        //头像按钮
        avatorButton = PopButton(frame: CGRectMake(10,0,48,48))
        avatorButton.setImage(UIImage(named: "avatar1"), forState: .Normal)
        //设置头像
        if let avt = user.avatar{
            avatorButton.setImage(avt,forState: UIControlState.Normal)
        }
        avatorButton.addTarget(self, action: "setAvator:", forControlEvents: UIControlEvents.TouchUpInside)
        //设置头像圆角
        avatorButton.layer.cornerRadius = avatorButton.frame.width/2
        avatorButton.clipsToBounds = true
        //用户名
        name = UILabel(frame: CGRectMake(65,5,100,23))
        name.textColor = UIColor.whiteColor()
        name.font = UIFont.systemFontOfSize(14)
        name.text = user.username
        //手机号
        phone = UILabel(frame: CGRectMake(65,23,120,25))
        phone.textColor = UIColor.whiteColor()
        phone.font = UIFont.systemFontOfSize(17)
        phone.text = user.cellphone
        //余额标题
        let ye = UILabel(frame: CGRectMake(headerView.frame.width - 150,5,140,23))
        ye.textColor = UIColor.whiteColor()
        ye.font = UIFont.systemFontOfSize(14)
        ye.textAlignment = .Right
        ye.text = "账户余额"
        //余额
        yeValue = UILabel(frame: CGRectMake(headerView.frame.width - 150,23,140,25))
        yeValue.textColor = UIColor.whiteColor()
        yeValue.font = UIFont.systemFontOfSize(17)
        yeValue.textAlignment = .Right
        
        headerView.addSubview(avatorButton)
        headerView.addSubview(name)
        headerView.addSubview(phone)
        headerView.addSubview(ye)
        headerView.addSubview(yeValue)
        head.addSubview(headerView)
        //操作按钮
        let tabbar = UITabBar(frame: CGRectMake(0,70,head.frame.width,44))
        tabbar.translucent = false
        let tbi1 = UITabBarItem(title: buttonList[0].title, image: UIImage(named: buttonList[0].image), tag: 1)
        tbi1.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.blackColor()], forState:.Normal)
        tbi1.tag = 0
        let tbi2 = UITabBarItem(title: buttonList[1].title, image: UIImage(named: buttonList[1].image), tag: 2)
        tbi2.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.blackColor()], forState:.Normal)
        tbi2.tag = 1
        let tbi3 = UITabBarItem(title: buttonList[2].title, image: UIImage(named: buttonList[2].image), tag: 3)
        tbi3.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.blackColor()], forState:.Normal)
        tbi3.tag = 2
        let tbiArray = [tbi1,tbi2,tbi3]
        tabbar.setItems(tbiArray, animated: true)
        tabbar.delegate = self
        head.addSubview(tabbar)
        
        //模拟数据
        for i in 0...8{
            cellData.append(("\(Payment(rawValue: i)!)","","myTrade",Payment(rawValue: i)!))
        }
        for i in 0...1{
            gatherData.append(("\(Gather(rawValue: i)!)","","gather",Gather(rawValue: i)!))
        }
        otherData.append(("充值","","recharge"))
        imageList = ["ccl","buyIn","buyOut","detailTable","bx","gatherBuy","gatherSell","cz"]
        //初始化表格底部
        //        let footerView = UIView(frame: CGRectMake(0,0,self.view.frame.width,self.view.frame.width / 4 * 3 + 3))
        //        footerView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        let vWidth:CGFloat = self.view.frame.width / 4
        //初始化快捷按钮
        let kjView = UIView(frame:CGRectMake(0,130,head.frame.width,vWidth*2+2))
        var vTop:CGFloat = 0
        var vLeft:CGFloat = 0
        for i in 0...7{
            if i == 4{
                vTop = vTop + 1
                vLeft = 0
            }
            let v = UIView(frame: CGRectMake(CGFloat(vLeft) * (vWidth+1),vTop * (vWidth+1),vWidth,vWidth))
            v.backgroundColor = UIColor.whiteColor()
            if i < (cellData.count - 4) + gatherData.count + otherData.count{
                let width:CGFloat = 32
                let imageView = UIImageView(frame: CGRectMake(v.frame.width/2-width/2,20,width,width))
                imageView.image = UIImage(named:imageList[i])
                let label = UILabel(frame: CGRectMake(0,width+22,v.frame.width,30))
                label.font = UIFont.systemFontOfSize(10)
                label.textAlignment = .Center
                var index = -1
                if i < cellData.count - 4{
                    index = i+4
                    label.text = cellData[index].title
                    //点击payment手势
                    let tapGesture = UITapGestureRecognizer(target: self, action: "tapPayment:")
                    v.addGestureRecognizer(tapGesture)
                }
                else{
                    index = i - (cellData.count - 4)
                    if index < gatherData.count{
                        label.text = gatherData[index].title
                        //点击gather手势
                        let tapGesture = UITapGestureRecognizer(target: self, action: "tapGather:")
                        v.addGestureRecognizer(tapGesture)
                    }
                    else{
                        index = i - (cellData.count - 4) - gatherData.count
                        if index < otherData.count{
                            label.text = otherData[index].title
                            //点击other手势
                            let tapGesture = UITapGestureRecognizer(target: self, action: "tapOther:")
                            v.addGestureRecognizer(tapGesture)
                        }
                    }
                }
                v.tag = index
                v.addSubview(label)
                v.addSubview(imageView)
            }
            kjView.addSubview(v)
            vLeft = vLeft + 1
        }
        head.addSubview(kjView)
        tv.tableHeaderView = head
        //获得导航下面的实现
        navBarHairlineImageView = Common.findHairlineImageViewUnder((self.navigationController?.navigationBar)!)
    }
    
    //点击手势触发事件
    func tapPayment(sender: UITapGestureRecognizer){
        let tag = sender.view?.tag
        if cellData[tag!].segue != ""{
            self.performSegueWithIdentifier(cellData[tag!].segue, sender: tag)
        }
    }
    
    //点击手势触发事件
    func tapGather(sender: UITapGestureRecognizer){
        let tag = sender.view?.tag
        if gatherData[tag!].segue != ""{
            self.performSegueWithIdentifier(gatherData[tag!].segue, sender: tag)
        }
    }
    
    //点击手势触发事件
    func tapOther(sender: UITapGestureRecognizer){
        let tag = sender.view?.tag
        if otherData[tag!].segue != ""{
            self.performSegueWithIdentifier(otherData[tag!].segue, sender: tag)
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        //隐藏导航下面的实线
        navBarHairlineImageView.hidden = true
        //购买后跳转我的投资列表
        if jump != ""{
            self.tabBarController?.tabBar.hidden = true
            let controller = (self.storyboard?.instantiateViewControllerWithIdentifier(jump))! as! MyTradeViewController
            controller.isJump = true
            if jumpFilter == "Sell"{
                controller.selectCell = Payment.我的卖出成交单
            }
            self.navigationController?.pushViewController(controller, animated: false)
            jump = ""
            jumpFilter = ""
        }
        else{
            self.tabBarController?.tabBar.hidden = false
            //刷新数据
            getData()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        //显示导航下面的实现（其他页面）
        navBarHairlineImageView.hidden = false
    }
    
    func getData(){
        let url = API_URL + "/api/account"
        let token = String(Common.loadDefault("token")!)
        let param = ["token":token,"action":"PersonInfo"]
        self.view.makeToastActivity(position: HRToastPositionCenter, message: "数据加载中")
        Common.doRepuest(self, url: url, method: .GET, param: param) { (response, json) -> Void in
            self.yeValue.text = json["data"]["banlace"].stringValue
            //绑定表格数据
            let process = json["data"]["process"]
            self.titleList.append([("买入交易中-数量",process["condi_buy_units"].stringValue),
                ("买入交易中-购买价格",process["condi_buy_price"].stringValue),
                ("买入交易中-待付款",process["condi_buy_payable"].stringValue),
                ("待下单提交-数量",process["orders_yet_submitted_units"].stringValue),
                ("待下单提交-购买价格",process["orders_yet_submitted_price"].stringValue),
                ("待下单提交-待付款","")])
            
            let cashBalance = json["data"]["cashBalance"]
            self.titleList.append([("保证金",cashBalance["cash_bal"].stringValue),
                ("金币价值",cashBalance["coins_yet_to_redeem"].stringValue),
                ("债款交易中-买入已付",cashBalance["condi_pmt_paid"].stringValue),
                ("债款交易中-线下支付中",cashBalance["condi_pmt_offline_paying"].stringValue),
                ("债款交易中-买入应付",cashBalance["condi_pmt_payable"].stringValue),
                ("债款交易中-卖出应收",cashBalance["condi_receivable"].stringValue),
                ("本息到期应收",cashBalance["instalments_receivable"].stringValue),
                ("本息本月到期",cashBalance["instalments_due_mtd"].stringValue)])
            
            let interestSummary = json["data"]["interestSummary"]
            self.titleList.append([("应收利息",interestSummary["interest_receivable"].stringValue),
                ("本日利息",interestSummary["interest_today"].stringValue),
                ("实际利息-本周",interestSummary["interest_act_wtd"].stringValue),
                ("实际利息-本月",interestSummary["interest_act_mtd"].stringValue),
                ("实际利息-本年",interestSummary["interest_act_ytd"].stringValue),
                ("持有到期利息-本周",interestSummary["interest_maturity_week"].stringValue),
                ("持有到期利息-本月",interestSummary["interest_maturity_month"].stringValue),
                ("持有到期利息-本年",interestSummary["interest_maturity_year"].stringValue)])
            
            let principalInterestSummary = json["data"]["principalInterestSummary"]
            self.titleList.append([("本息到期应收",principalInterestSummary["instalments_receivable"].stringValue),
                ("实际本息-本月到期",principalInterestSummary["instalments_due_mtd"].stringValue),
                ("实际利息-本年到期",principalInterestSummary["instalments_due_ytd"].stringValue),
                ("持有到期本息-本月到期",principalInterestSummary["instalments_maturity_month"].stringValue),
                ("持有到期本息-本年到期",principalInterestSummary["instalments_maturity_year"].stringValue)])
            
            self.tv.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 40
        }
        return 20
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionList.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionList[section]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < titleList.count{
            return titleList[section].count
        }
        else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ScrollView", forIndexPath: indexPath)
        cell.selectionStyle = .None
        for v in cell.contentView.subviews{
            v.removeFromSuperview()
        }
        let title = titleList[indexPath.section]
        cell.textLabel?.text = title[indexPath.row].title
        cell.detailTextLabel?.text = title[indexPath.row].value
        return cell
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if cellData[item.tag].segue != ""{
            self.performSegueWithIdentifier(cellData[item.tag].segue, sender: item.tag)
        }
        tabBar.selectedItem = nil
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let trade = segue.destinationViewController as? MyTradeViewController{
            trade.navigationItem.title = cellData[Int(sender! as! NSNumber)].title
            trade.selectCell = cellData[Int(sender! as! NSNumber)].type
        }
        else if let gather = segue.destinationViewController as? GatherTableViewController{
            gather.navigationItem.title = gatherData[Int(sender! as! NSNumber)].title
            gather.selectCell = gatherData[Int(sender! as! NSNumber)].type
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //设置头像
    @IBAction func setAvator(sender: AnyObject) {
        imagePick = UIImagePickerController()
        //支持裁剪
        imagePick?.allowsEditing = true
        imagePick!.delegate = self
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        //从相册选取
        let photo = UIAlertAction(title: "从相册选择", style: UIAlertActionStyle.Default) { (action) -> Void in
            self.imagePick!.sourceType = .PhotoLibrary
            self.presentViewController(self.imagePick!, animated: true, completion: nil)
            
        }
        //拍照
        let camera = UIAlertAction(title: "拍照", style: UIAlertActionStyle.Destructive) { (action) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
                self.imagePick!.sourceType = .Camera
                self.imagePick!.showsCameraControls = true
                self.presentViewController(self.imagePick!, animated: true, completion: nil)
            }
            else{
                Common.showAlert(self, title: nil, message: "该手机无摄像头")
            }
        }
        //查看高清大图
        let review = UIAlertAction(title: "查看高清大图", style: UIAlertActionStyle.Default) { (action) -> Void in
            let browser = MWPhotoBrowser(delegate: self)
            browser.alwaysShowControls = false
            browser.modalTransitionStyle = .CrossDissolve
            self.presentViewController(browser, animated: true, completion: nil)
        }
        //取消
        let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel,handler: nil)
        alert.addAction(camera)
        alert.addAction(photo)
        alert.addAction(review)
        alert.addAction(cancel)
        //ipad特殊处理
        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {
            let popPresenter = alert.popoverPresentationController
            popPresenter!.sourceView = sender as? UIView
            popPresenter!.sourceRect = sender.bounds
        }
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //取消选择后处理
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.imagePick?.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    
    //选择完图片后处理
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.imagePick?.dismissViewControllerAnimated(true, completion: { () -> Void in
            self.view.makeToastActivity(position: HRToastPositionCenter, message: "数据加载中")
            let image = info[UIImagePickerControllerEditedImage] as? UIImage
            
            self.avatorButton.setImage(image, forState: .Normal)
            //保存图片到应用沙盒
            let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)
            //区分不用账号头像
            let fileName = "\(self.phone.text!)-avatar"
            let filePath = path[0].stringByAppendingString("/\(fileName).png")
            let result = UIImagePNGRepresentation(image!)?.writeToFile(filePath, atomically: true)
            if (result == true){
                if picker.sourceType == .Camera{
                    Common.showAlert(self, title: nil, message: "是否存入相册？",cancel:true,okTitle: "是", cancelTitle:"否", ok: { (action) -> Void in
                        //保存图片到相册
                        UIImageWriteToSavedPhotosAlbum(image!, self, "saveImage:didFinishSavingWithError:contextInfo:", nil)
                    })
                }
                //保存图片变量
                Common.saveDefault(filePath, key: fileName)
            }
            self.view.hideToastActivity()
        })
    }
    
    //保存图片到相册后的回调
    func saveImage(image:UIImage,didFinishSavingWithError error:NSError?,contextInfo:AnyObject){
        
    }
    
    //关闭预览后回调
    func photoBrowserDidFinishModalPresentation(photoBrowser: MWPhotoBrowser!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func numberOfPhotosInPhotoBrowser(photoBrowser: MWPhotoBrowser!) -> UInt {
        return 1
    }
    
    func photoBrowser(photoBrowser: MWPhotoBrowser!, photoAtIndex index: UInt) -> MWPhotoProtocol {
        return MWPhoto(image: self.avatorButton.imageView?.image)
    }
    
}

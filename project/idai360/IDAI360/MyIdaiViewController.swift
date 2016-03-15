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
    var cellData = [(title:String,detail:String,segue:String,type:Payment?)]()
    var gatherData = [(title:String,detail:String,segue:String,type:Gather)]()
    var otherData = [(title:String,detail:String,segue:String)]()
    var buyData = [(title:String,image:String)]()
    var imageList = [String]()
    var result:JSON?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //初始化头部隐藏view
        topView = UIView(frame: CGRectMake(0,-10000,self.view.frame.width,10000))
        topView.backgroundColor = MAIN_COLOR
        self.view.addSubview(topView)
        //初始化表格头部
        let headerView = UIView(frame: CGRectMake(0,0,self.view.frame.width,100))
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
        
        //标题
        let tv0 = UIView(frame: CGRectMake(0,60,self.view.frame.width,40))
        tv0.backgroundColor = UIColor.whiteColor()
        let label0 = UILabel(frame: CGRectMake(10,0,self.view.frame.width,40))
        label0.text = "我要交易"
        label0.font = UIFont.systemFontOfSize(14)
        tv0.addSubview(label0)
        
        headerView.addSubview(avatorButton)
        headerView.addSubview(name)
        headerView.addSubview(phone)
        headerView.addSubview(ye)
        headerView.addSubview(yeValue)
        headerView.addSubview(tv0)
        tv.tableHeaderView = headerView
        //模拟数据
        for i in 0...8{
            cellData.append(("\(Payment(rawValue: i)!)","","myTrade",Payment(rawValue: i)!))
        }
        cellData.append(("账户总览","","totalView",nil))
        for i in 0...1{
            gatherData.append(("\(Gather(rawValue: i)!)","","gather",Gather(rawValue: i)!))
        }
        buyData = [("市价买入","sjmr"),("市价卖出","sjmc"),("委托买入","wtmr"),("委托买出","wtmc")]
        otherData.append(("充值","","recharge"))
        imageList = ["dqr","hkz","hkjs","cz","ccl","buyIn","buyOut","detailTable","bx","zl"]
        //初始化表格底部
        let footerView = UIView(frame: CGRectMake(0,0,self.view.frame.width,self.view.frame.width / 4 * 4 + 3))
        footerView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        //初始化快捷按钮
        let tv1 = UIView(frame: CGRectMake(0,0,self.view.frame.width,40))
        tv1.backgroundColor = UIColor.whiteColor()
        let label = UILabel(frame: CGRectMake(10,0,self.view.frame.width,40))
        label.text = "我的订单"
        label.font = UIFont.systemFontOfSize(14)
        tv1.addSubview(label)
        footerView.addSubview(tv1)
        
        
        for i in 0...3{
            let v = UIView(frame: CGRectMake(0+CGFloat(i) * self.view.frame.width/4,41,self.view.frame.width/4-1,self.view.frame.width/4-1))
            v.backgroundColor = UIColor.whiteColor()
            let imageView = UIImageView(frame: CGRectMake(v.frame.width/2-32/2,20,32,32))
            imageView.image = UIImage(named:imageList[i])
            let label = UILabel(frame: CGRectMake(0,32+22,v.frame.width,30))
            label.font = UIFont.systemFontOfSize(10)
            label.textAlignment = .Center
            label.text = cellData[i].title
            v.tag = i
            v.addSubview(label)
            v.addSubview(imageView)
            
            if i == 3{
                //点击other手势
                v.tag = 0
                let tapGesture = UITapGestureRecognizer(target: self, action: "tapOther:")
                v.addGestureRecognizer(tapGesture)
                label.text = "充值"
            }
            else{
                //点击payment手势
                let tapGesture = UITapGestureRecognizer(target: self, action: "tapPayment:")
                v.addGestureRecognizer(tapGesture)
            }
            
            footerView.addSubview(v)
        }
        
        let tv2 = UIView(frame: CGRectMake(0,self.view.frame.width/4 + 50,self.view.frame.width,40))
        tv2.backgroundColor = UIColor.whiteColor()
        let label2 = UILabel(frame: CGRectMake(10,0,self.view.frame.width,40))
        label2.text = "我的报表"
        label2.font = UIFont.systemFontOfSize(14)
        tv2.addSubview(label2)
        footerView.addSubview(tv2)
        
        for i in 0...7{
            let v:UIView?
            if i >= 4{
                v = UIView(frame:CGRectMake(0+CGFloat(i-4) * self.view.frame.width/4,self.view.frame.width/4*2 + 91,
                    self.view.frame.width/4-1,self.view.frame.width/4-1))
            }
            else{
                v = UIView(frame: CGRectMake(0+CGFloat(i) * self.view.frame.width/4,self.view.frame.width/4 + 91,
                    self.view.frame.width/4-1,self.view.frame.width/4-1))
            }
            v!.backgroundColor = UIColor.whiteColor()
            if cellData.count > i+4{
                let imageView = UIImageView(frame: CGRectMake(v!.frame.width/2-32/2,20,32,32))
                imageView.image = UIImage(named:imageList[i+4])
                let label = UILabel(frame: CGRectMake(0,32+22,v!.frame.width,30))
                label.font = UIFont.systemFontOfSize(10)
                label.textAlignment = .Center
                label.text = cellData[i+4].title
                //点击payment手势
                v!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tapPayment:"))
                v!.tag = i+4
                v!.addSubview(label)
                v!.addSubview(imageView)
            }
            footerView.addSubview(v!)
        }
        
        
        
        
        
        
        
        
        //        var vTop:CGFloat = 0
        //        var vLeft:CGFloat = 0
        //        for i in 0...11{
        //            if i == 4 || i == 8{
        //                vTop = vTop + 1
        //                vLeft = 0
        //            }
        //            let v = UIView(frame: CGRectMake(CGFloat(vLeft) * (vWidth+1),vTop * (vWidth+1),vWidth,vWidth))
        //            v.backgroundColor = UIColor.whiteColor()
        //            if i < (cellData.count - 4) + gatherData.count + otherData.count{
        //                let width:CGFloat = 32
        //                let imageView = UIImageView(frame: CGRectMake(v.frame.width/2-width/2,20,width,width))
        //                imageView.image = UIImage(named:imageList[i])
        //                let label = UILabel(frame: CGRectMake(0,width+22,v.frame.width,30))
        //                label.font = UIFont.systemFontOfSize(10)
        //                label.textAlignment = .Center
        //                var index = -1
        //                if i < cellData.count - 4{
        //                    index = i+4
        //                    label.text = cellData[index].title
        //                    //点击payment手势
        //                    let tapGesture = UITapGestureRecognizer(target: self, action: "tapPayment:")
        //                    v.addGestureRecognizer(tapGesture)
        //                }
        //                else{
        //                    index = i - (cellData.count - 4)
        //                    if index < gatherData.count{
        //                        label.text = gatherData[index].title
        //                        //点击gather手势
        //                        let tapGesture = UITapGestureRecognizer(target: self, action: "tapGather:")
        //                        v.addGestureRecognizer(tapGesture)
        //                    }
        //                    else{
        //                        index = i - (cellData.count - 4) - gatherData.count
        //                        if index < otherData.count{
        //                            label.text = otherData[index].title
        //                            //点击other手势
        //                            let tapGesture = UITapGestureRecognizer(target: self, action: "tapOther:")
        //                            v.addGestureRecognizer(tapGesture)
        //                        }
        //                    }
        //                }
        //                v.tag = index
        //                v.addSubview(label)
        //                v.addSubview(imageView)
        //            }
        //            footerView.addSubview(v)
        //            vLeft = vLeft + 1
        //        }
        tv.tableFooterView = footerView
        //初始化按钮标题和图片
        buttonList = [("\(Payment(rawValue: 0)!)","wait"),("\(Payment(rawValue: 1)!)","in"),("\(Payment(rawValue: 2)!)","finish")]
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
                controller.selectCell = Payment.卖出成交单
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
            self.result = json["data"]
            
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "我要买"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ScrollView", forIndexPath: indexPath)
        cell.selectionStyle = .None
        for v in cell.contentView.subviews{
            v.removeFromSuperview()
        }
        let tabbar = UITabBar(frame: CGRectMake(0,0,cell.frame.width,cell.frame.height))
        tabbar.translucent = false
        let tbi1 = UITabBarItem(title: buyData[0].title, image: UIImage(named: buyData[0].image), tag: 1)
        tbi1.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.blackColor()], forState:.Normal)
        let tbi2 = UITabBarItem(title: buyData[1].title, image: UIImage(named: buyData[1].image), tag: 2)
        tbi2.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.blackColor()], forState:.Normal)
        let tbi3 = UITabBarItem(title: buyData[2].title, image: UIImage(named: buyData[2].image), tag: 3)
        tbi3.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.blackColor()], forState:.Normal)
        let tbi4 = UITabBarItem(title: buyData[3].title, image: UIImage(named: buyData[3].image), tag: 4)
        tbi4.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.blackColor()], forState:.Normal)
        
        let tbiArray = [tbi1,tbi2,tbi3,tbi4]
        tabbar.setItems(tbiArray, animated: true)
        cell.contentView.addSubview(tabbar)
        tabbar.delegate = self
        return cell
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        //        if cellData[item.tag].segue != ""{
        //            self.performSegueWithIdentifier(cellData[item.tag].segue, sender: item.tag)
        //        }
        switch item.tag{
        case 1:self.tabBarController?.selectedIndex = 2
            break
        case 2:self.tabBarController?.selectedIndex = 3
            break
        case 3:self.performSegueWithIdentifier(gatherData[0].segue, sender: 1)
            break
        case 4:self.performSegueWithIdentifier(gatherData[1].segue, sender: 0)
            break
        default:
            break
        }
        tabBar.selectedItem = nil
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let trade = segue.destinationViewController as? MyTradeViewController{
            trade.navigationItem.title = cellData[Int(sender! as! NSNumber)].title
            trade.selectCell = cellData[Int(sender! as! NSNumber)].type!
        }
        else if let gather = segue.destinationViewController as? GatherTableViewController{
            gather.navigationItem.title = gatherData[Int(sender! as! NSNumber)].title
            gather.selectCell = gatherData[Int(sender! as! NSNumber)].type
        }
        else if let totalView = segue.destinationViewController as? TotalViewTableViewController{
            totalView.navigationItem.title = cellData[Int(sender! as! NSNumber)].title
            totalView.result = self.result
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

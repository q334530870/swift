//
//  UserCenterViewController.swift
//  IDAI360
//
//  Created by YaoJ on 15/12/16.
//  Copyright © 2015年 YaoJ. All rights reserved.
//

import UIKit

class UserCenterViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MWPhotoBrowserDelegate{
    
    var cellData = [(title:String,detail:String,segue:String,type:Payment)]()
    var user:JSON?
    var imagePick:UIImagePickerController?
    var imageView:UIImageView!
    var lastScaleFactor:CGFloat = 1.0
    var netTranslation:CGPoint = CGPoint(x: 0, y: 0)
    
    @IBOutlet weak var avatorButton: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phone: UILabel!
    var navBarHairlineImageView:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //获得导航下面的实现
        navBarHairlineImageView = Common.findHairlineImageViewUnder((self.navigationController?.navigationBar)!)
        //设置头像圆角
        avatorButton.layer.cornerRadius = avatorButton.frame.width/2
        avatorButton.clipsToBounds = true
        //绑定用户信息
        let user = Common.getCurrentUser()
        name.text = user.username
        phone.text = user.cellphone
        //设置头像
        if let avt = user.avatar{
            avatorButton.setImage(avt,forState: UIControlState.Normal)
        }
        //模拟数据
        for i in 3...8{
            cellData.append(("\(Payment(rawValue: i)!)","","myTrade",Payment(rawValue: i)!))
        }
        
        
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        //隐藏导航下面的实现
        navBarHairlineImageView.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        //显示导航下面的实现（其他页面）
        navBarHairlineImageView.hidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //解决cell分割线左边短的问题
        if cell.respondsToSelector(Selector("setSeparatorInset:")){
            cell.separatorInset = UIEdgeInsetsZero
        }
        if cell.respondsToSelector(Selector("setLayoutMargins:")){
            cell.layoutMargins = UIEdgeInsetsZero
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return cellData.count
        }
        else{
            return 1
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ScrollCell", forIndexPath: indexPath)
        let val = cellData[indexPath.row]
        if indexPath.section == 0{
            cell.textLabel?.text = val.title
            cell.detailTextLabel?.text = val.detail
        }
        else if indexPath.section == (tableView.numberOfSections - 1){
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
            label.text = "退出登录"
            label.textAlignment = .Center
            
            cell.accessoryType = .None
            cell.addSubview(label)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //退出登录
        if indexPath.section == tableView.numberOfSections - 1{
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            let alertController = UIAlertController(title: "", message: "退出后不会删除任何历史数据，下次登录依然可以使用本账号。", preferredStyle: UIAlertControllerStyle.ActionSheet)
            let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
            let logoutAction = UIAlertAction(title: "退出登录", style: UIAlertActionStyle.Destructive,handler:{ (alertSheet) -> Void in
                Common.removeDefault("user")
                Common.removeDefault("token")
                self.presentViewController((self.storyboard?.instantiateViewControllerWithIdentifier("HomeTabBar"))!, animated: true, completion: nil)
            } )
            alertController.addAction(cancelAction)
            alertController.addAction(logoutAction)
            
            if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {
                let popPresenter = alertController.popoverPresentationController
                popPresenter!.sourceView = cell
                popPresenter!.sourceRect = (cell?.bounds)!
            }
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else{
            //跳转不同的页面
            if cellData[indexPath.row].segue != ""{
                self.performSegueWithIdentifier(cellData[indexPath.row].segue, sender: indexPath.row)
            }
        }
        //取消选中效果
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let trade = segue.destinationViewController as? MyTradeViewController{
            trade.navigationItem.title = cellData[Int(sender! as! NSNumber)].title
            trade.selectCell = cellData[Int(sender! as! NSNumber)].type
        }
    }
    
    func photoBrowserDidFinishModalPresentation(photoBrowser: MWPhotoBrowser!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func numberOfPhotosInPhotoBrowser(photoBrowser: MWPhotoBrowser!) -> UInt {
        return 1
    }
    
    func photoBrowser(photoBrowser: MWPhotoBrowser!, photoAtIndex index: UInt) -> MWPhotoProtocol! {
        return MWPhoto(image: self.avatorButton.imageView?.image)
    }
    
    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

import UIKit
import LocalAuthentication

class Common{
    //遮罩层
    static let grayView:UIView = UIView()
    //加载菊花
    static let act:UIActivityIndicatorView = UIActivityIndicatorView()
    
    //获得当前用户
    static func getCurrentUser() -> User{
        let user = User(json: JSON(Common.loadDefault("user")!))
        let defaultAtr = Common.loadDefault("\(user.cellphone)-avatar")
        if defaultAtr != nil{
            if let image = UIImage(contentsOfFile: String(defaultAtr!)){
                user.avatar = image
            }
        }
        return user
    }
    
    //获取token 
    static func getToken() ->String{
        var token = ""
        if let tk = Common.loadDefault("token"){
            token = String(tk)
        }
        return token
    }
    
    //获取timeInterval
    func DateInterval(date:String)->NSTimeInterval{
        let formatter = NSDateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd HH:mm:ss")
        formatter.timeZone = NSTimeZone.systemTimeZone()
        let currentDateString = formatter.stringFromDate(NSDate())
        let currentDate = formatter.dateFromString(currentDateString)
        let setDate = formatter.dateFromString(date)
        let interval = setDate!.timeIntervalSinceDate(currentDate!)
        return interval
    }
    
    //显示提示框
    static func showAlert(view:UIViewController,title:String?,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(ok)
        view.presentViewController(alert, animated: true, completion: nil)
    }
    
    //显示带确定函数的提示框
    static func showAlert(view:UIViewController,title:String?,message:String,cancel:Bool = false,okTitle:String="确定",cancelTitle:String="取消",ok:(action:UIAlertAction) -> Void){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: okTitle, style: UIAlertActionStyle.Default, handler:ok)
        alert.addAction(ok)
        if cancel{
            let cl = UIAlertAction(title: cancelTitle, style: UIAlertActionStyle.Cancel, handler:nil)
            alert.addAction(cl)
        }
        view.presentViewController(alert, animated: true, completion: nil)
    }
    
    //保存用户数据
    static func saveDefault(obj:AnyObject,key:String){
        let dft:NSUserDefaults  = NSUserDefaults.standardUserDefaults()
        dft.setObject(obj, forKey: key)
        dft.synchronize()
    }
    
    //读取用户数据
    static func loadDefault(key:String) ->AnyObject?{
        let dft:NSUserDefaults  = NSUserDefaults.standardUserDefaults()
        return dft.objectForKey(key)
    }
    
    //删除用户数据
    static func removeDefault(key:String){
        let dft:NSUserDefaults  = NSUserDefaults.standardUserDefaults()
        dft.removeObjectForKey(key)
    }
    
    //初始化遮罩层
    static func initLoading(currentView:UIViewController){
        //去除nav的高度
        var otherHeight:CGFloat = 0
        if(currentView.navigationController != nil){
            otherHeight += 60
        }
        let y:CGFloat = 0 - otherHeight
        //创建遮罩层
        grayView.frame = CGRectMake(0, y, currentView.view.bounds.width, currentView.view.bounds.height)
        grayView.backgroundColor = UIColor.grayColor()
        grayView.alpha = 0.4
        grayView.hidden = true
        //创建加载菊花
        act.frame = CGRectMake(currentView.view.bounds.width/2-20, currentView.view.bounds.height/2-5, 30, 30)
        grayView.addSubview(act)
        act.stopAnimating()
        //添加描述label
        let label = UILabel(frame: CGRectMake(currentView.view.bounds.width/2-30, currentView.view.bounds.height/2+20, 60, 20))
        label.text = "努力加载中..."
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.boldSystemFontOfSize(10)
        label.textColor = UIColor.whiteColor()
        grayView.addSubview(label)
        //遮罩层添加到试图中
        currentView.view.addSubview(grayView)
    }
    
    static func makeMask(currentView:UIView){
        //去除nav的高度
        //        var otherHeight:CGFloat = 0
        //        if(currentView!.navigationController != nil){
        //            otherHeight += 60
        //        }
        //        let y:CGFloat = 0 - otherHeight
        //创建遮罩层
        var height:CGFloat = 0
        if let tempView = currentView as? UITableView{
            height += tempView.contentOffset.y
        }
        grayView.frame = CGRectMake(0, 0,currentView.bounds.width, currentView.bounds.height + height)
        grayView.backgroundColor = UIColor.grayColor()
        grayView.alpha = 0.2
        //遮罩层添加到试图中
        currentView.addSubview(grayView)
    }
    
    static func hideMask(){
        grayView.removeFromSuperview()
    }
    
    
    //显示loading菊花
    static func showLoading(currentView:UIViewController){
        act.startAnimating()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        grayView.hidden = false
    }
    
    //隐藏loading菊花
    static func hideLoading(currentView:UIViewController){
        act.stopAnimating()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        grayView.hidden = true
    }
    
    //查找导航栏下面的实线
    static func findHairlineImageViewUnder(view:UIView) -> UIImageView?{
        if (view.isKindOfClass(UIImageView) && view.bounds.size.height<=1.0) {
            return view as? UIImageView
        }
        for subview in view.subviews{
            if let imageView = self.findHairlineImageViewUnder(subview){
                return imageView
            }
        }
        return nil
    }
    
    //初始化搜索条
    static func initSearchController(target:UISearchResultsUpdating) -> UISearchController?{
        var searchController:UISearchController?
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = target
        searchController?.dimsBackgroundDuringPresentation = false
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.searchBar.frame = CGRectMake((searchController?.searchBar.frame.origin.x)!, (searchController?.searchBar.frame.origin.y)!, (searchController?.searchBar.frame.size.width)!, 44.0)
        searchController?.searchBar.searchBarStyle = .Minimal
        searchController?.searchBar.tintColor = MAIN_COLOR
        searchController?.searchBar.returnKeyType = .Done
        searchController?.searchBar.placeholder = "关键词，多个用空格隔开，输入‘-’排除关键字"
        return searchController
    }
    
    //初始化pickView
    static func initPickView(target:UIViewController,frame:CGRect) ->UIPickerView{
        //遮罩层
        let taskView = UIView(frame: target.view.frame)
        taskView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        taskView.hidden = true
        //总视图
        let pv = UIView(frame: CGRectMake(frame.origin.x,frame.origin.y,frame.width,frame.height - 50))
        //选择视图
        let pickView = UIPickerView(frame: CGRectMake(0,30,pv.frame.width,pv.frame.height - 30))
        pickView.backgroundColor = UIColor.whiteColor()
        pickView.showsSelectionIndicator = true
        pv.addSubview(pickView)
        //工具条
        let toolbar = UIToolbar(frame: CGRectMake(0,0,pickView.frame.width,30))
        //确定按钮
        let pickButton = UIButton(frame: CGRectMake(toolbar.frame.width - 45,0,40,30))
        pickButton.setTitle("确定", forState: .Normal)
        pickButton.setTitleColor(MAIN_COLOR, forState: .Normal)
        pickButton.addTarget(target, action:Selector("selectSeg"), forControlEvents:.TouchUpInside)
        toolbar.addSubview(pickButton)
        pv.addSubview(toolbar)
        taskView.addSubview(pv)
        target.view.addSubview(taskView)
        return pickView
    }
    
    //数字格式化
    static func numberFormat(number:AnyObject, style:String = "#,##0.00") ->String{
        let formater = NSNumberFormatter()
        formater.positiveFormat = style
        let result = formater.stringFromNumber(number as! NSNumber)
        return result!
    }
    
    static func getCurrentDate(fmt:String = "yyyy-MM-dd HH:mm:ss") -> String{
        //初始化时间段
        let date = NSDate()
        //获取当前时区
        let zone = NSTimeZone.systemTimeZone()
        //以秒为单位返回当前应用程序与世界标准时间（格林威尼时间）的时差
        let interval = zone.secondsFromGMTForDate(date)
        //补充时差后为当前时间
        let localDate = date.dateByAddingTimeInterval(NSTimeInterval(interval))
        //日期格式化
        let formatter = NSDateFormatter()
        formatter.dateFormat = fmt
        return formatter.stringFromDate(localDate)
    }
    
    static func dateFromString(date:String,fmt:String = "yyyy-MM-dd HH:mm:ss")->NSDate{
        //日期格式化
        let formatter = NSDateFormatter()
        formatter.dateFormat = fmt
        return formatter.dateFromString(date)!
    }
    
    static func stringDateFromString(date:String,fmt:String = "yyyy-MM-dd HH:mm:ss")->String{
        if date == ""{
            return ""
        }
        //日期格式化
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let newDate = formatter.dateFromString(date)!
        formatter.dateFormat = fmt
        return formatter.stringFromDate(newDate)
    }
    
    //获取当前controller
    static func currentController(view:UIView) ->UIViewController?{
        var result:UIViewController? = nil
        var window = UIApplication.sharedApplication().keyWindow
        if window?.windowLevel != UIWindowLevelNormal{
            let windows = UIApplication.sharedApplication().windows
            for tmpWindow in windows{
                if tmpWindow.windowLevel == UIWindowLevelNormal
                {
                    window = tmpWindow
                    break
                }
            }
        }
        let frontView = window?.subviews[0]
        let nextResponder = frontView?.nextResponder()
        if let res = nextResponder as? UIViewController{
            result = res
        }
        else{
            result = (window?.rootViewController)!
        }
        return result
    }
    
    //调用接口
    static func doRepuest(controller:UIViewController, url:String,method:Method = .GET, param:[String: AnyObject]?=nil,failed:(()->Void)? = nil,complete:(Response<AnyObject, NSError>,JSON) -> Void){
        request(method, url,parameters: param).responseJSON(options: NSJSONReadingOptions.MutableLeaves) { (response) -> Void in
            controller.view.hideToastActivity()
            if response.result.error != nil{
                Common.showAlert(controller, title: "", message: "连接错误，请稍后再试！")
                if failed != nil{
                    failed!()
                }
            }
            else{
                var json = JSON(response.result.value!)
                if json["code"].string == "success"{
                    complete(response,json)
                }
                else{
                    var message = "连接失败"
                    if let mes = json["message"].string{
                        message = mes
                    }
                    else if let mes = json["ExceptionMessage"].string{
                        message = mes
                    }
                    else if let mes = json["Message"].string{
                        message = mes
                    }
                    Common.showAlert(controller, title: "", message: message)
                    if failed != nil{
                        failed!()
                    }
                }
            }
        }
    }
    
    //验证手机号
    static func isMobile(mobileNum:String?) -> Bool{
        if mobileNum == ""{
            return false
        }
        let mobile = "^1(3[0-9]|4[0-9]|5[0-35-9]|7[0-9]|8[0-9])\\d{8}$"
        /**
         * 中国移动：China Mobile
         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
         */
        let cm = "^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$"
        /**
         * 中国联通：China Unicom
         * 130,131,132,152,155,156,185,186
         */
        let cu = "^1(3[0-2]|5[256]|8[56])\\d{8}$"
        /**
         * 中国电信：China Telecom
         * 133,1349,153,180,189
         */
        let ct = "^1((33|53|8[09])[0-9]|349)\\d{7}$"
        /**
         25         * 大陆地区固话及小灵通
         26         * 区号：010,020,021,022,023,024,025,027,028,029
         27         * 号码：七位或八位
         28         */
        // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
        
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@", mobile)
        let regextestcm = NSPredicate(format: "SELF MATCHES %@", cm)
        let regextestcu = NSPredicate(format: "SELF MATCHES %@", cu)
        let regextestct = NSPredicate(format: "SELF MATCHES %@", ct)
        
        if (regextestmobile.evaluateWithObject(mobileNum)
            || regextestcm.evaluateWithObject(mobileNum)
            || regextestcu.evaluateWithObject(mobileNum)
            || regextestct.evaluateWithObject(mobileNum))
        {
            return true
        }
        else{
            return false
        }
    }
    
    //验证固话
    static func isTel(tel:String?) -> Bool{
        if tel == ""{
            return false
        }
        let regex = "^(\\d{3,4}-)\\d{7,8}$"
        let telText = NSPredicate(format: "SELF MATCHES %@", regex)
        return telText.evaluateWithObject(tel)
    }
    
    //验证邮箱
    static func isEmail(email:String?) -> Bool{
        if email == ""{
            return false
        }
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailText = NSPredicate(format: "SELF MATCHES %@", regex)
        return emailText.evaluateWithObject(email)
    }
    
    //验证身份证号
    static func isIdCard(idCard:String?) -> Bool{
        if idCard == ""{
            return false
        }
        let regex = "^(\\d{14}|\\d{17})(\\d|[xX])$"
        let idCardText = NSPredicate(format: "SELF MATCHES %@", regex)
        return idCardText.evaluateWithObject(idCard)
    }
    
    //验证银行卡
    static func isBankCard(bankCard:String?) -> Bool{
        if bankCard == ""{
            return false
        }
        let regex = "^(\\d{16}|\\d{19})$"
        let bankCardText = NSPredicate(format: "SELF MATCHES %@", regex)
        return bankCardText.evaluateWithObject(bankCard)
    }
    
    //调用指纹识别函数
    static func loginWithTouchID(target:UIViewController,str:String,callback:(()->Void)? = nil)
    {
        //        if NSProcessInfo().isOperatingSystemAtLeastVersion(NSOperatingSystemVersion(majorVersion:
        //            8, minorVersion: 0, patchVersion: 0)){
        //ios8以后才能使用touch id
        if NSProcessInfo().operatingSystemVersion.majorVersion >= 8{
            var result = ""
            // Get the local authentication context.
            let context = LAContext()
            // Declare a NSError variable.
            var error: NSError?
            // Set the reason string that will appear on the authentication alert.
            let reasonString = str
            // Check if the device can evaluate the policy.
            if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error)
            {
                context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { (stat, error) in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in //放到主线程执行，这里特别重要
                        if stat
                        {
                            //成功后执行的方法
                            callback
                        }
                        else
                        {
                            // If authentication failed then show a message to the console with a short description.
                            // In case that the error is a user fallback, then show the password alert view.
                            //result = error!.localizedDescription
                            //showAlert(target, title: "", message: result)
                        }
                    })
                })
            }
            else
            {
                // If the security policy cannot be evaluated then show a short message depending on the error.
                switch error!.code
                {
                case LAError.TouchIDNotEnrolled.rawValue:
                    result = "您还没有保存Touch ID指纹"
                    break
                case LAError.PasscodeNotSet.rawValue:
                    result = "您还没有设置密码"
                    break
                default:
                    // The LAError.TouchIDNotAvailable case.
                    result = "Touch ID不可用"
                    break
                }
                // Optionally the error description can be displayed on the console.
                //result = (error?.localizedDescription)!
                // Show the custom alert view to allow users to enter the password.
                showAlert(target, title: "", message: result)
            }
        }
        else{
            showAlert(target, title: "", message: "系统版本低于8.0，无法使用TOUCH ID")
        }
    }
    
}

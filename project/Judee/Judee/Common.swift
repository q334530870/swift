import UIKit

class Common{
    //遮罩层
    static let grayView:UIView = UIView()
    //加载菊花
    static let act:UIActivityIndicatorView = UIActivityIndicatorView()
    
    //获得当前用户
    static func getCurrentUser() -> User{
        let user = User(json: JSON(Common.loadDefault("user")!))
        //        let defaultAtr = Common.loadDefault("\(user.cellphone)-avatar")
        //        if defaultAtr != nil{
        //            if let image = UIImage(contentsOfFile: String(defaultAtr!)){
        //                user.avatar = image
        //            }
        //        }
        return user
    }
    
    //获取token 
    static func getToken() ->String{
        var token = ""
        if let tk = Common.loadDefault("token"){
            token = String(describing: tk)
        }
        return token
    }
    
    //获取timeInterval
    static func DateInterval(_ date:String)->TimeInterval{
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd HH:mm:ss")
        formatter.timeZone = TimeZone.current
        let currentDateString = formatter.string(from: Date())
        let currentDate = formatter.date(from: currentDateString)
        let setDate = formatter.date(from: date)
        let interval = setDate!.timeIntervalSince(currentDate!)
        return interval
    }
    
    static func dateFromString(_ date:String,fmt:String = "yyyy-MM-dd HH:mm:ss")->Date{
        //日期格式化
        let formatter = DateFormatter()
        formatter.dateFormat = fmt
        return formatter.date(from: date)!
    }
    
    //显示提示框
    static func showAlert(_ view:UIViewController,title:String?,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(ok)
        view.present(alert, animated: true, completion: nil)
    }
    
    //显示带确定函数的提示框
    static func showAlert(_ view:UIViewController,title:String?,message:String,cancel:Bool = false,okTitle:String="确定",cancelTitle:String="取消",ok:@escaping (_ action:UIAlertAction) -> Void){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: okTitle, style: UIAlertActionStyle.default, handler:ok)
        alert.addAction(ok)
        if cancel{
            let cl = UIAlertAction(title: cancelTitle, style: UIAlertActionStyle.cancel, handler:nil)
            alert.addAction(cl)
        }
        view.present(alert, animated: true, completion: nil)
    }
    
    //保存用户数据
    static func saveDefault(_ obj:AnyObject,key:String){
        let dft:UserDefaults  = UserDefaults.standard
        dft.set(obj, forKey: key)
        dft.synchronize()
    }
    
    //读取用户数据
    static func loadDefault(_ key:String) ->AnyObject?{
        let dft:UserDefaults  = UserDefaults.standard
        return dft.object(forKey: key) as AnyObject?
    }
    
    //删除用户数据
    static func removeDefault(_ key:String){
        let dft:UserDefaults  = UserDefaults.standard
        dft.removeObject(forKey: key)
    }
    
    //初始化遮罩层
    static func initLoading(_ currentView:UIViewController){
        //去除nav的高度
        var otherHeight:CGFloat = 0
        if(currentView.navigationController != nil){
            otherHeight += 60
        }
        let y:CGFloat = 0 - otherHeight
        //创建遮罩层
        grayView.frame = CGRect(x: 0, y: y, width: currentView.view.bounds.width, height: currentView.view.bounds.height)
        grayView.backgroundColor = UIColor.gray
        grayView.alpha = 0.4
        grayView.isHidden = true
        //创建加载菊花
        act.frame = CGRect(x: currentView.view.bounds.width/2-20, y: currentView.view.bounds.height/2-5, width: 30, height: 30)
        grayView.addSubview(act)
        act.stopAnimating()
        //添加描述label
        let label = UILabel(frame: CGRect(x: currentView.view.bounds.width/2-30, y: currentView.view.bounds.height/2+20, width: 60, height: 20))
        label.text = "努力加载中..."
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textColor = UIColor.white
        grayView.addSubview(label)
        //遮罩层添加到试图中
        currentView.view.addSubview(grayView)
    }
    
    static func makeMask(_ currentView:UIView){
        //去除nav的高度
        //        var otherHeight:CGFloat = 0
        //        if(currentView!.navigationController != nil){
        //            otherHeight += 60
        //        }
        //        let y:CGFloat = 0 - otherHeight
        //创建遮罩层
        grayView.frame = CGRect(x: 0, y: 0,width: currentView.bounds.width, height: currentView.bounds.height)
        grayView.backgroundColor = UIColor.gray
        grayView.alpha = 0.2
        //遮罩层添加到试图中
        currentView.addSubview(grayView)
    }
    
    static func hideMask(){
        grayView.removeFromSuperview()
    }
    
    
    //显示loading菊花
    static func showLoading(_ currentView:UIViewController){
        act.startAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        grayView.isHidden = false
    }
    
    //隐藏loading菊花
    static func hideLoading(_ currentView:UIViewController){
        act.stopAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        grayView.isHidden = true
    }
    
    //查找导航栏下面的实线
    static func findHairlineImageViewUnder(_ view:UIView) -> UIImageView?{
        if (view.isKind(of: UIImageView.self) && view.bounds.size.height<=1.0) {
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
    static func initSearchController(_ target:UISearchResultsUpdating) -> UISearchController?{
        var searchController:UISearchController?
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = target
        searchController?.dimsBackgroundDuringPresentation = false
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.searchBar.frame = CGRect(x: (searchController?.searchBar.frame.origin.x)!, y: (searchController?.searchBar.frame.origin.y)!, width: (searchController?.searchBar.frame.size.width)!, height: 44.0)
        searchController?.searchBar.searchBarStyle = .minimal
        searchController?.searchBar.tintColor = MAIN_COLOR
        searchController?.searchBar.returnKeyType = .done
        searchController?.searchBar.placeholder = "关键词，多个用空格隔开，输入‘-’排除关键字"
        return searchController
    }
    
    //初始化pickView
    static func initPickView(_ target:UIViewController,frame:CGRect) ->UIPickerView{
        //遮罩层
        let taskView = UIView(frame: target.view.frame)
        taskView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        taskView.isHidden = true
        //总视图
        let pv = UIView(frame: CGRect(x: frame.origin.x,y: frame.origin.y,width: frame.width,height: frame.height - 60))
        //选择视图
        let pickView = UIPickerView(frame: CGRect(x: 0,y: 30,width: pv.frame.width,height: pv.frame.height - 30))
        pickView.backgroundColor = UIColor.white
        pickView.showsSelectionIndicator = true
        pv.addSubview(pickView)
        //工具条
        let toolbar = UIToolbar(frame: CGRect(x: 0,y: 0,width: pickView.frame.width,height: 30))
        //确定按钮
        let pickButton = UIButton(frame: CGRect(x: toolbar.frame.width - 45,y: 0,width: 40,height: 30))
        pickButton.setTitle("确定", for: UIControlState())
        pickButton.setTitleColor(MAIN_COLOR, for: UIControlState())
        pickButton.addTarget(target, action: Selector("selectSeg"), for:.touchUpInside)
        toolbar.addSubview(pickButton)
        pv.addSubview(toolbar)
        taskView.addSubview(pv)
        target.view.addSubview(taskView)
        return pickView
    }
    
    //数字格式化
    static func numberFormat(_ number:AnyObject, style:String = "#,##0.00") ->String{
        let formater = NumberFormatter()
        formater.positiveFormat = style
        let result = formater.string(from: number as! NSNumber)
        return result!
    }
    
    static func dateFormateUTCDate(_ utcDate:String,fmt:String="yyyy-MM-dd HH:mm:ss") -> String{
        let dateFmt = DateFormatter()
        let timeZone = TimeZone.autoupdatingCurrent
        dateFmt.timeZone = timeZone
        dateFmt.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFmt.date(from: utcDate)
        dateFmt.dateFormat = fmt
        let dateString = dateFmt.string(from: date!)
        return dateString
    }
    
    static func getCurrentDate(_ fmt:String = "yyyy-MM-dd HH:mm:ss") -> String{
        //初始化时间段
        let date = Date()
        //获取当前时区
        let zone = TimeZone.current
        //以秒为单位返回当前应用程序与世界标准时间（格林威尼时间）的时差
        let interval = zone.secondsFromGMT(for: date)
        //补充时差后为当前时间
        let localDate = date.addingTimeInterval(TimeInterval(interval))
        //日期格式化
        let formatter = DateFormatter()
        formatter.dateFormat = fmt
        return formatter.string(from: localDate)
    }
    
    //获取当前controller
    static func currentController(_ view:UIView) ->UIViewController?{
        var result:UIViewController? = nil
        var window = UIApplication.shared.keyWindow
        if window?.windowLevel != UIWindowLevelNormal{
            let windows = UIApplication.shared.windows
            for tmpWindow in windows{
                if tmpWindow.windowLevel == UIWindowLevelNormal
                {
                    window = tmpWindow
                    break
                }
            }
        }
        let frontView = window?.subviews[0]
        let nextResponder = frontView?.next
        if let res = nextResponder as? UIViewController{
            result = res
        }
        else{
            result = (window?.rootViewController)!
        }
        return result
    }
    
    //调用接口
    static func doRepuest(_ controller:UIViewController, url:String,method:Method = .GET, param:[String: AnyObject]?=nil,headers:[String: String]?=nil,encoding:ParameterEncoding = .url, failed:(()->Void)? = nil,complete:@escaping (Response<AnyObject, NSError>,JSON) -> Void){
        request(method, url,parameters: param,encoding: encoding,headers:headers).responseJSON(options: JSONSerialization.ReadingOptions.mutableContainers) { (response) -> Void in
            controller.view.hideToastActivity()
            if response.result.error != nil{
                print(response.response?.statusCode)
                if response.response?.statusCode == 401{
                    Common.showAlert(controller, title: "", message: "授权失败",ok: { (action) -> Void in
                        if failed != nil{
                            failed!()
                        }
                    })
                }
                else{
                    Common.showAlert(controller, title: "", message: "连接错误，请稍后再试",ok: { (action) -> Void in
                        if failed != nil{
                            failed!()
                        }
                    })
                }
            }
            else{
                var json = JSON(response.result.value!)
                if json["error"] == nil || json["error"]==""{
                    complete(response,json)
                }
                else{
                    if json["error"].string == "authentication failed"{
                        showAlert(controller, title: "", message: "登录超时，请重新登录", ok: { (action) -> Void in
                            controller.present((controller.storyboard?.instantiateViewController(withIdentifier: "Login"))!, animated: true, completion: nil)
                        })
                    }
                    var message = "连接失败"
                    if let mes = json["error"].string{
                        message = mes
                    }
                    else if let mes = json["ExceptionMessage"].string{
                        message = mes
                    }
                    else if let mes = json["Message"].string{
                        message = mes
                    }
                    Common.showAlert(controller, title: "", message: message,ok: { (action) -> Void in
                        if failed != nil{
                            failed!()
                        }
                    })
                }
            }
        }
    }
    
    //验证手机号
    static func isMobile(_ mobileNum:String?) -> Bool{
        if mobileNum == ""{
            return false
        }
        let mobile = "^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$"
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
        
        if (regextestmobile.evaluate(with: mobileNum)
            || regextestcm.evaluate(with: mobileNum)
            || regextestcu.evaluate(with: mobileNum)
            || regextestct.evaluate(with: mobileNum))
        {
            return true
        }
        else{
            return false
        }
    }
    
    //验证固话
    static func isTel(_ tel:String?) -> Bool{
        if tel == ""{
            return false
        }
        let regex = "^(\\d{3,4}-)\\d{7,8}$"
        let telText = NSPredicate(format: "SELF MATCHES %@", regex)
        return telText.evaluate(with: tel)
    }
    
    //验证邮箱
    static func isEmail(_ email:String?) -> Bool{
        if email == ""{
            return false
        }
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailText = NSPredicate(format: "SELF MATCHES %@", regex)
        return emailText.evaluate(with: email)
    }
    
    //验证身份证号
    static func isIdCard(_ idCard:String?) -> Bool{
        if idCard == ""{
            return false
        }
        let regex = "^(\\d{14}|\\d{17})(\\d|[xX])$"
        let idCardText = NSPredicate(format: "SELF MATCHES %@", regex)
        return idCardText.evaluate(with: idCard)
    }
    
    //验证银行卡
    static func isBankCard(_ bankCard:String?) -> Bool{
        if bankCard == ""{
            return false
        }
        let regex = "^(\\d{16}|\\d{19})$"
        let bankCardText = NSPredicate(format: "SELF MATCHES %@", regex)
        return bankCardText.evaluate(with: bankCard)
    }
    
}

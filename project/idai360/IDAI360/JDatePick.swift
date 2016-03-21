
class JDatePick:NSObject,UITextFieldDelegate{
    
    var pickView:UIDatePicker?
    var textField:UITextField?
    var target:UIView?
    var dateFmt:String?
    var controller:UIViewController?
    var height:CGFloat?
    var type:UIDatePickerMode?
    
    var pickValue = ""
    var taskView:UIView?
    var pickButton:UIButton?
    var pv:UIView!
    
    init(controller:UIViewController? = nil,target:UIView,textField:UITextField,type:UIDatePickerMode = UIDatePickerMode.Date,dateFmt:String="yyyy-MM-dd",height:CGFloat = 200){
        super.init()
        //        //添加键盘隐藏通知
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardShouldHide:", name: UIKeyboardDidHideNotification, object: nil)
        //        
        self.target = target
        self.textField = textField
        self.pickView = UIDatePicker()
        self.textField!.delegate = self
        self.controller = controller
        self.height = height
        self.dateFmt = dateFmt
        self.type = type
    }
    
    
    func initTextField(textField:UITextField){
        self.textField = textField
        self.textField!.delegate = self
    }
    
    //    //键盘隐藏
    //    func keyboardShouldHide(notification:NSNotification){
    //        if taskView?.subviews.count > 0{
    //            var offset = (target?.frame.height)!
    //            if let tb = target as? UITableView{
    //                offset += tb.contentOffset.y
    //            }
    //            if offset < taskView?.frame.height{
    //                taskView?.removeFromSuperview()
    //                initFrame(controller, type: type!, dateFmt: dateFmt!, height: height!)
    //            }
    //        }
    //    }
    
    //页面滚动时调整taskview位置
    func setOffset(y:CGFloat){
        pv?.frame.origin.y = (target?.frame.height)! - height! + y
    }
    
    func initFrame(controller:UIViewController?,type:UIDatePickerMode ,dateFmt:String,height:CGFloat){
        var offset:CGFloat = 0
        var taskHeight = (target?.frame.height)!
        if let tb = target as? UITableView{
            offset += tb.contentOffset.y
            if tb.contentSize.height > tb.frame.height{
                taskHeight = tb.contentSize.height
            }
        }
        //遮罩层
        taskView = UIView(frame:CGRectMake(0,0,(target?.frame.width)!,taskHeight))
        taskView?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        //总视图
        pv = UIView(frame: CGRectMake(0,(target?.frame.height)! - height + offset,(taskView?.width)!,height))
        pv.backgroundColor = UIColor.whiteColor()
        //选择视图
        pickView!.frame = CGRectMake(0,30,pv.frame.width,pv.frame.height - 30 - 50)
        pickView!.backgroundColor = UIColor.whiteColor()
        pickView?.datePickerMode = type
        let locale = NSLocale(localeIdentifier: "zh_CN")
        pickView?.locale = locale
        pv.addSubview(pickView!)
        //工具条
        let toolbar = UIToolbar(frame: CGRectMake(0,0,pickView!.frame.width,30))
        //确定按钮
        pickButton = UIButton(frame: CGRectMake(toolbar.frame.width - 45,0,40,30))
        pickButton?.setTitle("确定", forState: .Normal)
        pickButton?.titleLabel?.font = UIFont.systemFontOfSize(18)
        pickButton?.setTitleColor(MAIN_COLOR, forState: .Normal)
        pickButton?.addTarget(controller == nil ? self : controller!, action: Selector("selectSeg:"), forControlEvents:.TouchUpInside)
        toolbar.addSubview(pickButton!)
        pv.addSubview(toolbar)
        taskView?.addSubview(pv)
        target!.addSubview(taskView!)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.textField!.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField == self.textField{
            self.target!.endEditing(true)
            selectReceive()
            return false
        }
        else{
            pickView!.superview!.superview!.removeFromSuperview()
            return true
        }
    }
    
    //显示收入选择控件
    func selectReceive() {
        //重置位置
        initFrame(controller, type: type!, dateFmt: dateFmt!, height: height!)
    }
    
    func selectSeg(button:UIButton) ->String{
        let textField = self.textField
        let formatter = NSDateFormatter()
        formatter.dateFormat = self.dateFmt
        let strDate = formatter.stringFromDate((self.pickView?.date)!)
        textField!.text = strDate
        self.pickView!.superview!.superview!.removeFromSuperview()
        return strDate
    }
    
}
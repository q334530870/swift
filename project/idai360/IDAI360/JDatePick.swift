
class JDatePick:NSObject,UITextFieldDelegate{
    
    var pickView:UIDatePicker?
    var textField:UITextField?
    var target:UIView?
    var fmt:String?
    
    var pickValue = ""
    var ViewFrame:CGRect?
    var pickFrame:CGRect?
    var taskView:UIView?
    
    init(controller:UIViewController? = nil,target:UIView,textField:UITextField,frame:CGRect,type:UIDatePickerMode = UIDatePickerMode.Date,dateFmt:String="yyyy-MM-dd"){
        super.init()
        
        self.target = target
        self.textField = textField
        self.pickView = UIDatePicker()
        
        self.textField!.delegate = self
        initFrame(controller,frame: frame,type:type,dateFmt: dateFmt)
    }
    
    func initFrame(controller:UIViewController?,frame:CGRect,type:UIDatePickerMode = UIDatePickerMode.Date,dateFmt:String="yyyy-MM-dd"){
        //遮罩层
        taskView = UIView(frame: CGRectMake(0,0,(target?.frame.width)!,(target?.frame.height)!))
        taskView?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        taskView?.hidden = true
        //总视图
        let pv = UIView(frame: CGRectMake(frame.origin.x,frame.origin.y,frame.width,frame.height - 50))
        if ViewFrame != nil{
            pv.frame = ViewFrame!
        }
        //选择视图
        pickView!.frame = CGRectMake(0,30,pv.frame.width,pv.frame.height - 30)
        if pickFrame != nil{
            pickView!.frame = pickFrame!
        }
        self.fmt = dateFmt
        pickView!.backgroundColor = UIColor.whiteColor()
        pickView?.datePickerMode = type
        let locale = NSLocale(localeIdentifier: "zh_CN")
        pickView?.locale = locale
        pv.addSubview(pickView!)
        //工具条
        let toolbar = UIToolbar(frame: CGRectMake(0,0,pickView!.frame.width,30))
        //确定按钮
        let pickButton = UIButton(frame: CGRectMake(toolbar.frame.width - 45,0,40,30))
        pickButton.setTitle("确定", forState: .Normal)
        pickButton.titleLabel?.font = UIFont.systemFontOfSize(16)
        pickButton.setTitleColor(MAIN_COLOR, forState: .Normal)
        pickButton.addTarget(controller == nil ? self : controller!, action: Selector("selectSeg"), forControlEvents:.TouchUpInside)
        toolbar.addSubview(pickButton)
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
            pickView!.superview!.superview!.hidden = true
            return true
        }
    }
    
    //显示收入选择控件
    func selectReceive() {
        self.pickView!.superview!.superview!.hidden = false
        self.taskView?.frame = CGRectMake(0,0,(target?.frame.width)!,(target?.frame.height)!)
    }
    
    func selectSeg(){
        let textField = self.textField
        let formatter = NSDateFormatter()
        formatter.dateFormat = self.fmt
        textField!.text = formatter.stringFromDate((self.pickView?.date)!)
        self.pickView!.superview!.superview!.hidden = true
    }
    
}
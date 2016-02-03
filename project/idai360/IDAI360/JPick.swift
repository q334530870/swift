
class JPick:NSObject, UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate{
    
    var pickView:UIPickerView?
    var textField:UITextField?
    var target:UIView?
    
    var pickList = [(title:String,value:String)]()
    var pickValue = ""
    var ViewFrame:CGRect?
    var pickFrame:CGRect?
    
    init(controller:UIViewController? = nil,target:UIView,textField:UITextField,frame:CGRect){
        super.init()
        
        self.target = target
        self.textField = textField
        self.pickView = UIPickerView()
        self.pickView?.delegate = self
        self.pickView?.dataSource = self
        self.textField!.delegate = self
        initFrame(controller,frame: frame)
    }
    
    func initFrame(controller:UIViewController?,frame:CGRect){
        //遮罩层
        let taskView = UIView(frame: target!.frame)
        taskView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        taskView.hidden = true
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
        pickView!.backgroundColor = UIColor.whiteColor()
        pickView!.showsSelectionIndicator = true
        pv.addSubview(pickView!)
        //工具条
        let toolbar = UIToolbar(frame: CGRectMake(0,0,pickView!.frame.width,30))
        //确定按钮
        let pickButton = UIButton(frame: CGRectMake(toolbar.frame.width - 45,0,40,30))
        pickButton.setTitle("确定", forState: .Normal)
        pickButton.setTitleColor(MAIN_COLOR, forState: .Normal)
        pickButton.addTarget(controller == nil ? self : controller!, action: Selector("selectSeg"), forControlEvents:.TouchUpInside)
        toolbar.addSubview(pickButton)
        pv.addSubview(toolbar)
        taskView.addSubview(pv)
        target!.addSubview(taskView)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.textField!.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField.restorationIdentifier == "sr"{
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
        self.pickView!.reloadAllComponents()
        self.pickView!.superview!.superview!.hidden = false
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickList[row].title
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickList.count
    }
    
    func selectSeg(){
        let textField = self.textField
        let row = pickView?.selectedRowInComponent(0)
        if row>0{
            textField!.text = self.pickList[row!].title
            self.pickValue = self.pickList[row!].value
        }
        else{
            textField!.text = ""
        }
        self.pickView!.superview!.superview!.hidden = true
    }
    
}
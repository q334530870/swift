
class JPick:NSObject, UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate{
    
    var pickView:UIPickerView?
    var textField:UITextField?
    var target:UIView?
    var controller:UIViewController?
    var height:CGFloat?
    
    var pickList = [(title:String,value:String)]()
    var pickValue = ""
    var taskView:UIView?
    var pickButton:UIButton?
    var cancelButton:UIButton?
    var pv:UIView!
    
    init(controller:UIViewController? = nil,target:UIView,textField:UITextField,height:CGFloat = 200){
        super.init()
        self.target = target
        self.textField = textField
        self.pickView = UIPickerView()
        self.pickView?.delegate = self
        self.pickView?.dataSource = self
        self.textField!.delegate = self
        self.controller = controller
        self.height = height
    }
    
    func initTextField(textField:UITextField){
        self.textField = textField
        self.textField!.delegate = self
    }
    
    //页面滚动时调整taskview位置
    func setOffset(y:CGFloat){
        pv?.frame.origin.y = (target?.frame.height)! - height! + y
    }
    
    func initFrame(controller:UIViewController?,height:CGFloat){
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
        pickView!.showsSelectionIndicator = true
        pv.addSubview(pickView!)
        //工具条
        let toolbar = UIToolbar(frame: CGRectMake(0,0,pickView!.frame.width,30))
        //确定按钮
        pickButton = UIButton(frame: CGRectMake(toolbar.frame.width - 45,0,40,30))
        pickButton?.setTitle("确定", forState: .Normal)
        pickButton?.titleLabel?.font = UIFont.systemFontOfSize(18)
        pickButton?.setTitleColor(MAIN_COLOR, forState: .Normal)
        pickButton?.addTarget(controller == nil ? self : controller!, action: #selector(JPick.selectSeg(_:)), forControlEvents:.TouchUpInside)
        //取消按钮
        cancelButton = UIButton(frame: CGRectMake(toolbar.frame.width - 100,0,40,30))
        cancelButton?.setTitle("取消", forState: .Normal)
        cancelButton?.titleLabel?.font = UIFont.systemFontOfSize(18)
        cancelButton?.setTitleColor(MAIN_COLOR, forState: .Normal)
        cancelButton?.addTarget(self, action: #selector(JPick.cancelSeg), forControlEvents:.TouchUpInside)
        
        toolbar.addSubview(pickButton!)
        toolbar.addSubview(cancelButton!)
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
        self.pickView!.reloadAllComponents()
        //重置位置
        initFrame(controller,height: height!)
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
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.font = UIFont.boldSystemFontOfSize(18)
        pickerLabel.adjustsFontSizeToFitWidth = true
        pickerLabel.textAlignment = .Center
        pickerLabel.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        return pickerLabel
    }
    
    func selectSeg(button:UIButton) ->String{
        let textField = self.textField
        let row = pickView?.selectedRowInComponent(0)
        if row>0{
            textField!.text = self.pickList[row!].title
            self.pickValue = self.pickList[row!].value
        }
        else{
            textField!.text = ""
        }
        self.pickView!.superview!.superview!.removeFromSuperview()
        return self.pickList[row!].value
    }
    
    func cancelSeg(){
        self.pickView!.superview!.superview!.removeFromSuperview()
    }
    
}
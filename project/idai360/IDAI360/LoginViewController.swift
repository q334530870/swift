import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var code: UITextField!
    @IBOutlet weak var sendCode: UIButton!
    @IBOutlet weak var login: UIButton!
    var navBarHairlineImageView:UIImageView!
    var size:CGFloat = 0
    @IBOutlet weak var titleLabelTop: NSLayoutConstraint!
    @IBOutlet weak var LoginBottom: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //获得导航下面的实线
        navBarHairlineImageView = Common.findHairlineImageViewUnder((self.navigationController?.navigationBar)!)
        //添加键盘隐藏通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.hideKeyboard(_:)), name: UIKeyboardWillHideNotification, object: nil)
        //添加键盘显示通知，获得键盘高度
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardShouldShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
    }
    
    //键盘出现时获得键盘高度，并让view向上移动
    func keyboardShouldShow(notification:NSNotification){
        var info:Dictionary = notification.userInfo!
        size = (info[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size.height)!
        UIView.animateWithDuration(0.3) { () -> Void in
            self.LoginBottom.constant = self.size + 10
            self.titleLabelTop.constant = 10
            if (self.phone.frame.origin.y - 10) < (self.logo.frame.height + 10){
                self.titleLabelTop.constant = -self.logo.frame.height
            }
            self.view.layoutIfNeeded()
            
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        //隐藏导航下面的实线
        navBarHairlineImageView.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        //显示导航下面的实线
        navBarHairlineImageView.hidden = false
    }
    
    //输入框内容变更监听：设置“发送验证码”和“登陆”按钮的状态（切换enable和alpha）
    @IBAction func checkPhone(sender: UITextField) {
        //        if self.phone.text!.characters.count == 11{
        //            self.sendCode.enabled = true
        //            self.sendCode.alpha = 0.9
        //            if(self.code.text!.characters.count == 6){
        //                self.login.enabled = true
        //                self.login.alpha = 0.9
        //            }
        //            else{
        //                self.login.enabled = false
        //                self.login.alpha = 0.6
        //            }
        //        }else{
        //            self.sendCode.enabled = false
        //            self.sendCode.alpha = 0.6
        //            self.login.enabled = false
        //            self.login.alpha = 0.6
        //        }
        
    }
    
    @IBAction func hideKeyboard(sender: AnyObject) {
        if let _ = sender as? UIView{
            sender.endEditing(true)
        }
        UIView.animateWithDuration(0.3) { () -> Void in
            self.LoginBottom.constant = 30
            self.titleLabelTop.constant = 90
            self.view.layoutIfNeeded()
        }
    }
    
    //登录
    @IBAction func login(sender: AnyObject) {
    
        if(phone.text == ""){
            Common.showAlert(self, title: "", message: "请输入用户名！")
        }
        else if(code.text == ""){
            Common.showAlert(self, title: "", message: "请输入短信验证码！")
        }
        else{
            //13761318778
            let url = API_URL + "/api/users"
            let param = ["username":phone.text!,"password":code.text!]
            self.view.makeToastActivity(position: HRToastPositionCenter, message: "数据加载中")
            Common.doRepuest(self, url: url, method: .GET, param: param, complete: { (Response, json) -> Void in
                
                Common.saveDefault(json["token"].string!, key: "token")
                var user = json["data"]
                //sjh判断realname是否为空
                user["realname"].string = ""
                Common.saveDefault(user.object, key: "user")
                self.performSegueWithIdentifier("loginUnwind", sender: nil)
                
                //                Common.loginWithTouchID(self, str: "请验证指纹后登录", callback: {
                //                    
                //                })
            })
        }
    }
    
    //返回首页
    @IBAction func goHome(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

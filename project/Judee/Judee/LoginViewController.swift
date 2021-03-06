import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var password: FloatLabelTextField!
    @IBOutlet weak var phone: FloatLabelTextField!
    
    var navBarHairlineImageView:UIImageView!
    var size:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //获得导航下面的实线
        navBarHairlineImageView = Common.findHairlineImageViewUnder((self.navigationController?.navigationBar)!)
        //设置登录按钮圆角
        loginButton.layer.cornerRadius = 5
        loginButton.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //隐藏导航下面的实线
        navBarHairlineImageView.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        //显示导航下面的实线
        navBarHairlineImageView.isHidden = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func checkLogin(_ sender: AnyObject) {
        if phone.text != "" && password.text != ""{
            loginButton.alpha = 1
        }
        else{
            loginButton.alpha = 0.6
        }
    }
    
    //登录
    @IBAction func login(_ sender: AnyObject) {
        if !Common.isMobile(phone.text!){
            Common.showAlert(self, title: "", message: "请输入正确的手机号码")
        }
        else{
            let url = API_URL + "/users/auth/"
            let param = ["mobile":phone.text!,"password":password.text!]
            self.view.makeToastActivity(position: HRToastPositionCenter as AnyObject, message: "数据加载中")
            Common.doRepuest(self, url: url, method: .POST, param: param,encoding:.json, complete: { (Response, json) -> Void in
                Common.saveDefault(json["token"].string!, key: "token")
                Common.saveDefault(json["user"].object, key: "user")
                self.goHome()
            })
        }
    }
    
    func goHome(){
        self.performSegue(withIdentifier: "Home", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

import UIKit

class RegisterViewController: UIViewController {
    
    var agree:Bool = false
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var ok: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //添加图片点击手势
        
        ok.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(BuyViewController.okClick)))
        ok.userInteractionEnabled = true
    }
    
    //判断手机号位数
    @IBAction func checkPhone(sender: AnyObject) {
        checkNext()
    }
    
    //检查是否可以进入下一步
    func checkNext(){
        if(agree == true && phone.text?.characters.count == 11){
            nextButton.enabled = true
            nextButton.alpha = 1
        }
        else{
            nextButton.enabled = false
            nextButton.alpha = 0.7
        }
    }
    
    func okClick(){
        agree = true
        ok.image = UIImage(named: "ok")
        checkNext()
    }
    
    @IBAction func unwindToRegiser(segue: UIStoryboardSegue){
        okClick()
    }
    
    @IBAction func closeLogin(sender: AnyObject) {
        //关闭当前界面
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //下一步
    @IBAction func next(sender: AnyObject) {
        self.performSegueWithIdentifier("Register2", sender: nil)
        //        let url = API_URL + "/api/sms"
        //        let param = ["mobile":phone.text!]
        //        self.view.makeToastActivity(position: HRToastPositionCenter, message: "数据加载中")
        //        Common.doRepuest(self, url: url, method: Method.GET, param: param){ (response,json) -> Void in
        //            //let code = json["data"].string
        //            
        //        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let registerPassword = segue.destinationViewController as? RegisterPasswordViewController
        if registerPassword != nil{
            let user = User()
            //user.code = String(sender!)
            user.cellphone = self.phone.text!
            registerPassword?.user = user
        }
        let destination = segue.destinationViewController as? InfoViewController
        if destination == nil{
            for child in (segue.destinationViewController.childViewControllers){
                if let info = child as? InfoViewController{
                    info.segue = "regiserSegue"
                    info.content = "尊敬的各位用户，首先感谢大家对爱贷360的关注和支持！\r爱贷360团队是一支优秀的、年轻的、充满热情的一支队伍。经过3年的沉淀和积累，1年的精心策划，6个月的研发。爱贷360在P2P网络借贷平台迅速发展的今天正式成立并面向大家了！\r爱贷360是基于目前中国民间资本发展现状应运而生的，它是一个新的阳光化产业，同时借助于网络高新技术的支持，爱贷360专注网络金融服务领域，力求为民间资本创造一个安全、高效、公正的流通互动平台，并引入多家第三方担保机构和第三方支付平台，为投资人做好正确的引导和投资保障。\r爱贷360为资金需求者提供了一条新的融资渠道，为投资者拓宽了投资渠道。激活了民间处于低使用率状态的资金，让它们更好的服务于广大需求者。爱贷360平台完善的审核制度、监管制度、保障制度将为我们未来的公信度建设打下坚实的基础，为未来的整体发展做好准备。\r我们坚信，在我国社会信用体系、网络技术、服务水平不断完善和提高的过程中，爱贷360团队将不惜一切努力做到最好，用服务赢得口碑，用态度实现承诺，用实力证明能力，打造出中国最诚信最可靠的P2P网络借贷平台。"
                }
            }
        }
    }
    
}

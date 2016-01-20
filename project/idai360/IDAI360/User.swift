
class User:NSObject{
    var id = 0
    var cellphone = "" 
    var username = ""
    var code = ""
    var password = ""
    var name = ""
    var idNumber = ""
    var email = ""
    var homePhone = ""
    var gender = 0
    var invoiceTypeId = 2
    var monthlyIncome = ""
    var avatar:UIImage?
    
    override init(){}
    
    init(json:JSON) {
        self.id = json["id"].intValue
        self.cellphone = json["mobile"].stringValue
        self.username = json["username"].stringValue
    }
    
    
}

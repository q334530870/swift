
class User:NSObject{
    var Id = ""
    var Mobile = ""
    var Name = ""
    var Gender = ""
    var Birthday = ""
    var Number = ""
    var Role = ""
    var Weixin = ""
    var avatar:UIImage?
    
    override init(){}
    
    init(json:JSON) {
        Id = json["Id"].stringValue
        Mobile = json["Mobile"].stringValue
        Name = json["Name"].stringValue
        Gender = json["Gender"].stringValue
        Birthday = json["Birthday"].stringValue
        Number = json["Number"].stringValue
        Role = json["Role"].stringValue
        Weixin = json["Weixin"].stringValue
    }
    
    
}

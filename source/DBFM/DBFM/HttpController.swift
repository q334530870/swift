import UIKit
import Alamofire

class HttpController : NSObject{
    var delegate:HttpProtocol?
    //数据检索
    func onSearch(url:String){
        Alamofire.request(Method.GET, url).responseJSON(options: NSJSONReadingOptions.MutableContainers) { (response) -> Void in
            self.delegate?.didRecieveResults(response.result.value!)
        }
    }
    
}

protocol HttpProtocol{
    func didRecieveResults(results:AnyObject)
}

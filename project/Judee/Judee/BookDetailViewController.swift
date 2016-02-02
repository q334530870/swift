//
//  BookDetailViewController.swift
//  Judee
//
//  Created by YaoJ on 16/1/25.
//  Copyright © 2016年 YaoJ. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tv: UITableView!
    var result:[JSON]?
    var imageList = [UIImage]()
    var homeworkId:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        //解决导航栏引起的顶部内容往下bug
        self.automaticallyAdjustsScrollViewInsets = false
        tv.delegate = self
        tv.dataSource = self
        
        //模拟数据
        result = ["1：语文书抄一遍","2：倒过来在抄一遍","3：用英语翻译一遍"]
        let footView = AvatarListView()
        footView.bookDetail = self
        tv.tableFooterView = footView
    }
    
    func getData(){
        let url = API_URL + "/homeworks/\(homeworkId!)/details/"
        let token = Common.getToken()
        let headers = ["Authorization": "bearer \(token)"]
        Common.doRepuest(self, url: url, method: .GET,headers: headers,failed: { () -> Void in
            self.navigationController?.popViewControllerAnimated(true)
            }){ (response, json) -> Void in
                if json["data"].count > 0{
                    self.result = json["data"].array!
                    self.tv.reloadData()
                }
                else{
                    self.navigationController?.popViewControllerAnimated(true)
                }
                
        }
    }
    
    
    func clickAvatar(button:UIButton){
        self.performSegueWithIdentifier("userBook", sender: button.tag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (result?.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tv.dequeueReusableCellWithIdentifier("ScrollCell", forIndexPath: indexPath)
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        cell.textLabel?.font = UIFont.systemFontOfSize(14)
        cell.textLabel?.text = result![indexPath.row]["content"].stringValue
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? UserBookViewController{
            destination.navigationItem.title = "judy\(sender!)"
        }
    }
    
}

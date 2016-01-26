//
//  BookViewController.swift
//  Judee
//
//  Created by YaoJ on 16/1/22.
//  Copyright © 2016年 YaoJ. All rights reserved.
//

import UIKit

class BookViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tv: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //解决导航栏引起的顶部内容往下bug
        self.automaticallyAdjustsScrollViewInsets = false
        tv.delegate = self
        tv.dataSource = self
        tv.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tv.dequeueReusableCellWithIdentifier("ScrollCell", forIndexPath: indexPath)
        
        cell.imageView?.image = UIImage(named: "judy.jpg")
        cell.imageView!.layer.cornerRadius = 20
        cell.imageView?.layer.masksToBounds = true
        
        cell.textLabel?.text = "家庭作业"
        cell.detailTextLabel?.text = "2016-01-25"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tv.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier("bookDetail", sender: tv.cellForRowAtIndexPath(indexPath)?.detailTextLabel?.text)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let detail = segue.destinationViewController as? BookDetailViewController{
            detail.navigationItem.title = sender as? String
        }
    }
    
}

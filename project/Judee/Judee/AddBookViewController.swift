//
//  AddBookViewController.swift
//  Judee
//
//  Created by YaoJ on 16/1/28.
//  Copyright © 2016年 YaoJ. All rights reserved.
//

import UIKit

class AddBookViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    @IBOutlet weak var cls: FloatLabelTextField!
    @IBOutlet weak var name: FloatLabelTextField!
    @IBOutlet weak var tv: UITableView!
    var result:[JSON]?
    var detailResult = [(content:String,time:String)]()
    //班级选择视图
    var classBackgroundView:UIView?
    var selectClassList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        result = [JSON]()
        
        tv.delegate = self
        tv.dataSource = self
        name.delegate = self
        cls.delegate = self
        let footView = UIView(frame: CGRectMake(0,self.view.frame.height - 30,self.view.frame.width,40))
        let button = UIButton(frame: CGRectMake(self.view.frame.width/2 - 60,10,120,30))
        button.setTitle("新增作业明细", forState: .Normal)
        button.backgroundColor = MAIN_COLOR
        button.titleLabel?.font = UIFont.systemFontOfSize(14)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: "addBook:", forControlEvents: .TouchUpInside)
        footView.addSubview(button)
        tv.tableFooterView = footView
        tv.estimatedRowHeight = 100
        //初始化班级选择试图
        classBackgroundView = UIView(frame: CGRectMake(0,63,self.view.frame.width,self.view.frame.height))
        classBackgroundView?.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.3)
        classBackgroundView?.hidden = true
        //添加点击事件
        classBackgroundView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "closeClassBackgroundView"))
        self.view.addSubview(classBackgroundView!)
    }
    
    func addBook(btn:UIButton){
        self.performSegueWithIdentifier("AddBook", sender: nil)
        //        tv.beginUpdates()
        //        tv.insertRowsAtIndexPaths([NSIndexPath(forRow: (result?.count)!, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Bottom)
        //        tv.endUpdates()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField == cls{
            self.selectClass()
            return false
        }
        else{
            return true
        }
    }
    
    func selectClass() {
        for view in (classBackgroundView?.subviews)!{
            view.removeFromSuperview()
        }
        let classView = UIView()
        classView.backgroundColor = UIColor(red:251/255, green:251/255, blue:251/255, alpha: 1)
        let allClsView = UIView()
        classView.addSubview(allClsView)
        let classList = ["二（1）班","二（2）班","二（3）班","二（4）班","二（5）班"]
        let leftMargin:CGFloat = 15
        let topMargin:CGFloat = 15
        var top:CGFloat = topMargin
        var i:CGFloat = 0
        let clsWidth:CGFloat = 90
        let clsHeight:CGFloat = 25
        var rightMargin:CGFloat = 0
        for cls in classList{
            if((i*(clsWidth+leftMargin) + clsWidth + leftMargin) > self.view.frame.width){
                top += clsHeight + topMargin
                rightMargin = self.view.frame.width - (i*(clsWidth+leftMargin)+leftMargin)
                i = 0
            }
            let clsLabel = UIButton(frame: CGRectMake(i*(clsWidth + leftMargin) + leftMargin,top,clsWidth,clsHeight))
            clsLabel.layer.borderColor = UIColor(red:222/255, green:222/255, blue:222/255, alpha: 1).CGColor
            if selectClassList.contains(cls) == true{
                clsLabel.backgroundColor = UIColor(red:211/255, green:211/255, blue:211/255, alpha: 1)
            }
            else{
                clsLabel.backgroundColor = UIColor.whiteColor()
            }
            clsLabel.layer.borderWidth = 0.8
            clsLabel.titleLabel?.font = UIFont.systemFontOfSize(12)
            clsLabel.setTitleColor(UIColor.blackColor(), forState: .Normal)
            clsLabel.setTitle(cls, forState: .Normal)
            clsLabel.addTarget(self, action: "checkClass:", forControlEvents: .TouchUpInside)
            allClsView.addSubview(clsLabel)
            i++
        }
        allClsView.frame = CGRectMake(rightMargin/2,0,self.view.frame.width,top + topMargin + clsHeight)
        classView.frame = CGRectMake(0,0,self.view.frame.width,top + topMargin + clsHeight)
        classBackgroundView?.addSubview(classView)
        classBackgroundView?.hidden = false
        
    }
    
    func checkClass(btn:UIButton){
        let text = (btn.titleLabel?.text)!
        if selectClassList.contains(text) == true{
            selectClassList.removeAtIndex((selectClassList.indexOf(text))!)
            btn.backgroundColor = UIColor.whiteColor()
        }
        else{
            selectClassList.append(text)
            btn.backgroundColor = UIColor(red:200/255, green:200/255, blue:200/255, alpha: 1)
        }
        cls.text = selectClassList.joinWithSeparator("，")
    }
    
    func closeClassBackgroundView(){
        classBackgroundView?.hidden = true
    }
    
    @IBAction func bookDetailUnwind(segue:UIStoryboardSegue){
        if let detail = segue.sourceViewController as? AddBookDetailViewController{
            detailResult.append((detail.textView.text,detail.needTime.text!))
            //表格中新增一行cell
            self.tv.beginUpdates()
            self.tv.insertRowsAtIndexPaths([NSIndexPath(forRow: self.detailResult.count - 1, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Bottom)
            self.tv.endUpdates()
        }
    }
    
    @IBAction func submit(sender: AnyObject) {
        _ = ["offset":"","limit":""]
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //解决cell分割线左边短的问题
        if cell.respondsToSelector(Selector("setSeparatorInset:")){
            cell.separatorInset = UIEdgeInsetsZero
        }
        if cell.respondsToSelector(Selector("setLayoutMargins:")){
            cell.layoutMargins = UIEdgeInsetsZero
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (detailResult.count)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ScrollCell", forIndexPath: indexPath)
        let rowData = detailResult[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = rowData.content
        if rowData.time != ""{
            cell.detailTextLabel?.text = "完成所需时间：" + rowData.time + "分钟"
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tv.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}

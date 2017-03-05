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
        let footView = UIView(frame: CGRect(x: 0,y: self.view.frame.height - 30,width: self.view.frame.width,height: 40))
        let button = UIButton(frame: CGRect(x: self.view.frame.width/2 - 60,y: 10,width: 120,height: 30))
        button.setTitle("新增作业明细", for: UIControlState())
        button.backgroundColor = MAIN_COLOR
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(AddBookViewController.addBook(_:)), for: .touchUpInside)
        footView.addSubview(button)
        tv.tableFooterView = footView
        tv.estimatedRowHeight = 100
        //初始化班级选择试图
        classBackgroundView = UIView(frame: CGRect(x: 0,y: 63,width: self.view.frame.width,height: self.view.frame.height))
        classBackgroundView?.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        classBackgroundView?.isHidden = true
        //添加点击事件
        classBackgroundView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(AddBookViewController.closeClassBackgroundView)))
        self.view.addSubview(classBackgroundView!)
    }
    
    func addBook(_ btn:UIButton){
        self.performSegue(withIdentifier: "AddBook", sender: nil)
        //        tv.beginUpdates()
        //        tv.insertRowsAtIndexPaths([NSIndexPath(forRow: (result?.count)!, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Bottom)
        //        tv.endUpdates()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
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
            let clsLabel = UIButton(frame: CGRect(x: i*(clsWidth + leftMargin) + leftMargin,y: top,width: clsWidth,height: clsHeight))
            clsLabel.layer.borderColor = UIColor(red:222/255, green:222/255, blue:222/255, alpha: 1).cgColor
            if selectClassList.contains(cls) == true{
                clsLabel.backgroundColor = UIColor(red:211/255, green:211/255, blue:211/255, alpha: 1)
            }
            else{
                clsLabel.backgroundColor = UIColor.white
            }
            clsLabel.layer.borderWidth = 0.8
            clsLabel.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            clsLabel.setTitleColor(UIColor.black, for: UIControlState())
            clsLabel.setTitle(cls, for: UIControlState())
            clsLabel.addTarget(self, action: #selector(AddBookViewController.checkClass(_:)), for: .touchUpInside)
            allClsView.addSubview(clsLabel)
            i += 1
        }
        allClsView.frame = CGRect(x: rightMargin/2,y: 0,width: self.view.frame.width,height: top + topMargin + clsHeight)
        classView.frame = CGRect(x: 0,y: 0,width: self.view.frame.width,height: top + topMargin + clsHeight)
        classBackgroundView?.addSubview(classView)
        classBackgroundView?.isHidden = false
        
    }
    
    func checkClass(_ btn:UIButton){
        let text = (btn.titleLabel?.text)!
        if selectClassList.contains(text) == true{
            selectClassList.remove(at: (selectClassList.index(of: text))!)
            btn.backgroundColor = UIColor.white
        }
        else{
            selectClassList.append(text)
            btn.backgroundColor = UIColor(red:200/255, green:200/255, blue:200/255, alpha: 1)
        }
        cls.text = selectClassList.joined(separator: "，")
    }
    
    func closeClassBackgroundView(){
        classBackgroundView?.isHidden = true
    }
    
    @IBAction func bookDetailUnwind(_ segue:UIStoryboardSegue){
        if let detail = segue.source as? AddBookDetailViewController{
            detailResult.append((detail.textView.text,detail.needTime.text!))
            //表格中新增一行cell
            self.tv.beginUpdates()
            self.tv.insertRows(at: [IndexPath(row: self.detailResult.count - 1, section: 0)], with: UITableViewRowAnimation.bottom)
            self.tv.endUpdates()
        }
    }
    
    @IBAction func submit(_ sender: AnyObject) {
        _ = ["offset":"","limit":""]
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //解决cell分割线左边短的问题
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)){
            cell.separatorInset = UIEdgeInsets.zero
        }
        if cell.responds(to: #selector(setter: UIView.layoutMargins)){
            cell.layoutMargins = UIEdgeInsets.zero
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (detailResult.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScrollCell", for: indexPath)
        let rowData = detailResult[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = rowData.content
        if rowData.time != ""{
            cell.detailTextLabel?.text = "完成所需时间：" + rowData.time + "分钟"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tv.deselectRow(at: indexPath, animated: true)
    }
    
}

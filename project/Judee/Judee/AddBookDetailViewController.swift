//
//  AddBookDetailViewController.swift
//  Judee
//
//  Created by YaoJ on 16/1/28.
//  Copyright © 2016年 YaoJ. All rights reserved.
//

import UIKit

class AddBookDetailViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var needTime: FloatLabelTextField!
    @IBOutlet weak var textView: FloatLabelTextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //解决导航栏引起的顶部内容往下bug
        self.automaticallyAdjustsScrollViewInsets = false
        textView.layer.borderColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1).cgColor
        textView.layer.borderWidth = 0.8
        textView.textContainerInset = UIEdgeInsetsMake(0,3,3,3)
        //datePicker.countDownDuration = 60
        //设置初始化日期，解决时间改变两次才能机会valueChanged事件
        datePicker.setDate(Common.dateFromString("1992-05-22",fmt: "yyyy-MM-dd"), animated: true)
        needTime.delegate = self
        textView.delegate = self
    }
    
    
    @IBAction func submit(_ sender: AnyObject) {
        if textView.text != ""{
            self.performSegue(withIdentifier: "BookDetailUnwind", sender: nil)
        }
        else{
            Common.showAlert(self, title: "", message: "请填写作业内容")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        datePicker.isHidden = true
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == needTime{
            self.textView.resignFirstResponder()
            showDatePicker()
            return false
        }
        else{
            return true
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView == self.textView{
            datePicker.isHidden = true
        }
        return true
    }
    
    func showDatePicker(){
        datePicker.isHidden = false
        if needTime.text == ""{
            needTime.text = "\(Int(datePicker.countDownDuration/60))"
        }
    }
    
    @IBAction func changeDate(_ sender: AnyObject) {
        needTime.text = "\(Int(datePicker.countDownDuration/60))"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}

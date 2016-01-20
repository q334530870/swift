//
//  ViewController.swift
//  QrCode
//
//  Created by YaoJ on 15/9/26.
//  Copyright © 2015年 YaoJ. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var TitleLabel: UILabel!
    
    var session:AVCaptureSession?
    
    var aesKey = "woaitutu"
    //视频画面预览层
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    //自动锁定小方框
    var autolockView:UIView?
    
    @IBAction func click(sender: UIButton) {
        session?.startRunning()
        button.hidden = true
    }
    
    override func viewDidLoad() {
        print(AESCrypt.encrypt("兔兔，x哥哥永远爱你~", password: aesKey))
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //初始化视频捕捉的会话
        session = AVCaptureSession()
        //指定设备是摄像头
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        //输入
        let input:AVCaptureDeviceInput?
        do {
            input = try AVCaptureDeviceInput(device: device)
            session?.addInput(input)
        } catch {
            print("摄像头无法使用")
            return
        }
        //输出
        let output = AVCaptureMetadataOutput()
        session?.addOutput(output)
        //添加元数据对象输出代理
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        //设置输出的类型
        output.metadataObjectTypes = [AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeFace]
        
        //视频预览层
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        session?.startRunning()
        //设置title标签为最前面
        view.bringSubviewToFront(TitleLabel)
        autolockView = UIView()
        autolockView?.layer.borderColor = UIColor.greenColor().CGColor
        autolockView?.layer.borderWidth = 2
        view.addSubview(autolockView!)
        view.bringSubviewToFront(autolockView!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func stop(){
        session?.stopRunning()
        button.hidden = false
        view.bringSubviewToFront(button)
    }
    
    
    func readApp(var str:String){
        let url = NSURL(string: str)
        if(url == nil || str.hasPrefix("yj:")){
            if str.hasPrefix("yj:"){
                str = (str as NSString).substringFromIndex(3)
                str = AESCrypt.decrypt(str, password: aesKey)
            }
            let alert = UIAlertController(title: "", message: "\(str)", preferredStyle: UIAlertControllerStyle.Alert)
            let okButton = UIAlertAction(title: "同意", style: UIAlertActionStyle.Default,handler: nil)
            let cancelButton = UIAlertAction(title: "不同意", style: UIAlertActionStyle.Destructive,handler: { (_) -> Void in
                exit(0)
            })
            alert.addAction(okButton)
            alert.addAction(cancelButton)
            self.popoverPresentationController?.sourceView = view
            self.popoverPresentationController?.sourceRect = TitleLabel.frame
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else{
            let alert = UIAlertController(title: "二维码", message: "确定要打开\(str)？", preferredStyle: UIAlertControllerStyle.ActionSheet)
            let okButton = UIAlertAction(title: "打开", style: UIAlertActionStyle.Destructive) { (_) -> Void in
                if url != nil{
                    if UIApplication.sharedApplication().canOpenURL(url!){
                        UIApplication.sharedApplication().openURL(url!)
                    }
                }
            }
            let cancelButton = UIAlertAction(title: "不同意", style: UIAlertActionStyle.Destructive,handler: nil)
            alert.addAction(okButton)
            alert.addAction(cancelButton)
            self.popoverPresentationController?.sourceView = view
            self.popoverPresentationController?.sourceRect = TitleLabel.frame
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    //一旦视频捕捉有输出
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        if metadataObjects == nil || metadataObjects.count == 0{
            autolockView?.frame = CGRect.zero
            TitleLabel.text = "扫描中..."
            return
        }
        if let obj = metadataObjects.first as? AVMetadataFaceObject{
            if obj.type == AVMetadataObjectTypeFace{
                let face = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(obj)
                autolockView?.frame = face!.bounds
                stop()
                TitleLabel.text = "发现人脸！"
            }
        }
        if let obj = metadataObjects.first as? AVMetadataMachineReadableCodeObject{
            let code = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(obj)
            autolockView?.frame = code!.bounds
            switch obj.type{
                case AVMetadataObjectTypeQRCode:
                    if let str = obj.stringValue{
                        stop()
                        TitleLabel.text = "二维码："+str
                        readApp(str)
                }
                case AVMetadataObjectTypeFace:
                    if let str = obj.stringValue{
                        stop()
                        TitleLabel.text = "商品吗："+str
                }
                default:return
            }
        }
    }


}


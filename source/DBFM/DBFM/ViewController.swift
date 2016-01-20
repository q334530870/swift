//
//  ViewController.swift
//  DBFM
//
//  Created by YaoJ on 15/11/3.
//  Copyright © 2015年 YaoJ. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AVFoundation
//import MediaPlayer

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,HttpProtocol,ChannelProtocol {

    @IBOutlet weak var iv: EkoImage!
    @IBOutlet weak var tv: UITableView!
    @IBOutlet weak var bg: UIImageView!
    //网络操作类
    var http:HttpController = HttpController()
    //歌曲数据
    var musicList:[JSON] = []
    //频道数据
    var channelList:[JSON] = []
    //图片缓存
    var imageCache = Dictionary<String,UIImage>()
    //播放器实例
    var audioPlayer:AVPlayer = AVPlayer()
    //计时器
    var timer:NSTimer?
    //时间
    @IBOutlet weak var playTime: UILabel!
    //进度
    @IBOutlet weak var progress: UIImageView!
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnPlay: EkoButton!
    @IBOutlet weak var btnPrev: UIButton!
    //当前播放
    var currentIndex:Int = 0
    //播放顺序按钮
    @IBOutlet weak var btnOrder:OrderButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //执行动画
        iv.onRotation()
        //添加模糊层
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
        bg.addSubview(blurView)
        //设置表格代理
        tv.delegate = self
        tv.dataSource = self
        http.delegate = self
        //检索数据
        http.onSearch("https://www.douban.com/j/app/radio/channels")
        http.onSearch("https://douban.fm/j/mine/playlist?type=n&channel=0&from=mainsite")
        tv.backgroundColor = UIColor.clearColor()
        //播放结束通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playFinish", name: AVPlayerItemDidPlayToEndTimeNotification, object: audioPlayer.currentItem)
    }
    
    func playFinish(){
        switch(btnOrder.order){
        case 1:
            currentIndex++
            if currentIndex >= musicList.count{
                currentIndex = 0
            }
            onSelectRow(currentIndex)
        case 2:
            currentIndex = random() % musicList.count
            onSelectRow(currentIndex)
        case 3:
            onSelectRow(currentIndex)
        default: break
        }
    }
    
    //暂停、播放
    @IBAction func onPlay(sender: EkoButton) {
        if sender.isPlay{
            audioPlayer.play()
        }
        else{
            audioPlayer.pause()
        }
    }
    
    //下一首、上一首
    @IBAction func onClick(sender:UIButton){
        if btnOrder.order == 1 || btnOrder.order == 3{
            if sender == btnNext{
                currentIndex++
                if  currentIndex >= self.musicList.count{
                    currentIndex = 0
                }
            }
            else{
                currentIndex--
                if currentIndex < 0{
                    currentIndex = self.musicList.count-1
                }
            }
        }
        //随机播放的下一首和上一首也随机
        else{
            currentIndex = random() % musicList.count
        }
        onSelectRow(currentIndex)
    }
    
    
    
    //播放顺序
    @IBAction func onOrder(sender:OrderButton){
        var message:String = ""
        switch(sender.order){
        case 1:
            message = "顺序播放"
        case 2:
            message = "随机播放"
        case 3:
            message = "单曲循环"
        default:
            message = "默认"
        }
        self.view.makeToast(message: message, duration: 1, position: "center")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tv.dequeueReusableCellWithIdentifier("musicCell")! as UITableViewCell
        cell.backgroundColor = UIColor.clearColor()
        //获取每一行数据
        let rowData:JSON = musicList[indexPath.row]
        //封面路径
        let imgUrl = rowData["picture"].string
        //获取封面
        cell.textLabel?.text = rowData["title"].string
        cell.detailTextLabel?.text = rowData["artist"].string
        cell.imageView?.image = UIImage(named: "order1")
        onGetCacheImage(imgUrl!, imgView: (cell.imageView)!)
        return cell
    }
    
    func didRecieveResults(results:AnyObject){
        //print(results)
        //转换为JSON类型
        let json = JSON(results)
        //判断数据
        if let channels = json["channels"].array{
            self.channelList = channels
        }else if let song = json["song"].array{
            musicList = song
            //刷新表格数据
            self.tv.reloadData()
            //默认选中第一行
            onSelectRow(0)
        }
    }
    
    //点击歌曲
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        onSelectRow(indexPath.row)
    }
    
    //选中行
    func onSelectRow(index:Int){
        if self.tv.numberOfRowsInSection(0)>0{
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            //选中行的效果
            tv.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.Bottom)
            //取得行数据
            var rowData:JSON = self.musicList[indexPath.row]
            //图片地址
            let imgUrl = rowData["picture"].string
            //设置图片
            onSetImage(imgUrl!)
            //音乐地址
            let url:String = rowData["url"].string!
            //播放音乐
            onSetAudio(url)
        }
    }
    
    //设置歌曲封面和背景
    func onSetImage(url:String){
        onGetCacheImage(url, imgView: self.iv)
        onGetCacheImage(url, imgView: self.bg)
    }
    
    //播放音乐
    func onSetAudio(url:String){
        //当前需要播放的音乐文件
        let item:AVPlayerItem = AVPlayerItem(URL: NSURL(string: url)!)
        self.audioPlayer.replaceCurrentItemWithPlayerItem(item)
        self.audioPlayer.play()
        btnPlay.onPlay()
//        self.audioPlayer.stop()
//        self.audioPlayer.contentURL = NSURL(string:url)
//        self.audioPlayer.play()
        //重置定时器
        timer?.invalidate()
        playTime.text = "00:00"
        //重置进度条
        progress.frame.size.width = 0
        //启动定时器
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "onUpdate", userInfo: nil, repeats: true)
        
    }
    
    //计时器更新调用方法
    func onUpdate(){
        //当前播放时间
        let currentTime = CMTimeGetSeconds(audioPlayer.currentTime())
        if currentTime > 0.0{
            //音乐总时间
            let t = CMTimeGetSeconds((audioPlayer.currentItem?.duration)!)
            //进度百分比
            let pro:CGFloat = CGFloat(currentTime/t)
            //进度条宽度
            progress.frame.size.width = self.view.frame.size.width*pro
            //时间转换算法
            let all:Int = Int(currentTime)
            let m:Int = all % 60
            let f:Int = Int(all/60)
            
            var time:String = ""
            if f < 10{
                time = "0\(f):"
            }
            else{
                time = "\(f):"
            }
            if m<10{
                time += "0\(m)"
            }
            else{
                time += "\(m)"
            }
            //更新播放时间
            playTime.text = time
        }
//        if audioPlayer.rate == 0.0{
//            playFinish()
//        }
    }
    
    //图片缓存
    func onGetCacheImage(url:String,imgView:UIImageView){
        //通过图片地址从缓存中取图片
        let image = self.imageCache[url] as UIImage?
        
        if image == nil{
            Alamofire.request(.GET, url).response{(_, _, data, error) -> Void in
                //获取的数据给UIImage
                let img = UIImage(data:data! as NSData)
                imgView.image = img
                self.imageCache[url] = img
            }
        }
        else{
            imgView.image = image
        }
    }
    
    //频道列表协议回调
    func onChangeChannel(channelId: String) {
        let url = "https://douban.fm/j/mine/playlist?type=n&channel=\(channelId)&from=mainsite"
        http.onSearch(url)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //获取跳转目标
        let channel = segue.destinationViewController as! ChannelController
        //设置代理
        channel.delegate = self
        //传输数据
        channel.channelData = self.channelList
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}


//
//  ViewController.swift
//  OrderFood
//
//  Created by YaoJ on 15/11/3.
//  Copyright © 2015年 YaoJ. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {

    let items = [
        ["name":"大盘鸡","pic":"1.jpeg"],
        ["name":"茶香排骨","pic":"2.jpeg"],
        ["name":"茄酱鲜虾炒意粉","pic":"3.jpeg"],
        ["name":"鱼香虾仁","pic":"4.jpeg"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.backgroundColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    // 获取单元格
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) ->UICollectionViewCell {
            // 获取设计的单元格，不需要再动态添加界面元素
            let cell = (self.collectionView?.dequeueReusableCellWithReuseIdentifier(
                "cell", forIndexPath: indexPath))! as UICollectionViewCell
            // 从界面查找到控件元素并设置属性
            (cell.contentView.viewWithTag(1) as! UIImageView).image = UIImage(named: items[indexPath.row]["pic"]!)
            (cell.contentView.viewWithTag(2) as! UILabel).text = items[indexPath.row]["name"]
            return cell
    }


}


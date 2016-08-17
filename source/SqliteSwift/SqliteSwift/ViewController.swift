//
//  ViewController.swift
//  SqliteSwift
//
//  Created by YaoJ on 16/5/22.
//  Copyright © 2016年 瑶瑾瑾. All rights reserved.
//

import UIKit
import SQLite

class ViewController: UIViewController {
    
    var db:Connection! = nil
    let users = Table("users")
    let id = Expression<Int64>("id")
    let name = Expression<String>("name")
    let email = Expression<String>("email")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //放入沙盒根目录的Documents文件夹(创建或更新)
        do{
            db = try Connection(NSHomeDirectory()+"/Documents/db.sqlite3")
            try db.run(users.create{ t in
                t.column(id, primaryKey: true)
                t.column(name)
                t.column(email)
                })
        }catch{
            print(error)
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func insertAction(sender: AnyObject) {
        do{
            let insert = users.insert(name<-"YaoJ",email<-"yaojie11222@126.com")
            try db.run(insert)
        }catch{
            print(error)
        }
    }
    
    @IBAction func deleteAction(sender: AnyObject) {
        let yaoJ = users.filter(id == 2)
        do{
            try db.run(yaoJ.delete())
        }catch{
            print(error)
        }
    }
    
    @IBAction func editAction(sender: AnyObject) {
        let yaoJ = users.filter(id == 2)
        do{
            try db.run(yaoJ.update(name <- name.replace("YaoJ", with: "YaoJie")))
        }catch{
            print(error)
        }
    }
    
    @IBAction func selectAction(sender: AnyObject) {
        do{
            for user in try db.prepare(users){
                print("id:\(user[id]),name:\(user[name])")
            }
        }catch{
            print(error)
        }
    }
    
}


//
//  ConversationViewController.swift
//  CloudIMTest
//
//  Created by YaoJ on 15/11/24.
//  Copyright © 2015年 YaoJ. All rights reserved.
//

import UIKit

class ConversationViewController: RCConversationViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置聊天对象
        let user = RCIMClient.sharedRCIMClient().currentUserInfo
        self.targetId = RCIMClient.sharedRCIMClient().currentUserInfo.userId
        self.userName = user.name
        self.conversationType = .ConversationType_PRIVATE
        self.title = "与" + self.userName + "对话中"
        //设置头像
        self.setMessageAvatarStyle(.USER_AVATAR_CYCLE)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

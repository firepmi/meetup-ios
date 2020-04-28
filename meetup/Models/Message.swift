//
//  Message.swift
//  Rilyo
//
//  Created by Developer on 14/05/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit

class Message: NSObject {
    var text : String?
    var messageType : String?
    var userId: String?
    var userImage: String?
    var userName: String?
    var videoLink: String?
    var imageLink: String?
    var time: Int64
    var messageId: String?
    var insertDate: NSDate?
    var date: Date?
    var messageCount: String?
    var name: String?
    
    override init() {
        self.text = nil
        self.messageType = nil
        self.userId = nil
        self.userImage = nil
        self.userName = nil
        self.videoLink = nil
        self.imageLink = nil
        self.messageId = nil
        self.time = 0
        self.insertDate = nil
        self.date = nil
        self.messageCount = nil
        self.messageCount = nil
        self.name = nil
    }
}

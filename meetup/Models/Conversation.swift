//  MIT License

//  Copyright (c) 2017 Haik Aslanyan

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation
import UIKit
import Firebase

class Conversation {
    
    //MARK: Properties
    var UserID = String()
    var lastMessage: Messagenew
    
    //MARK: Methods
    class func showConversations(completion: @escaping ([Conversation]) -> Swift.Void) {
        let currentUserID = standard.string(forKey: "userId") ?? ""
        var conversations = [Conversation]()
        Database.database().reference().child("users").child(currentUserID).child("conversations").observe(.childAdded, with: { (snapshot) in
            if snapshot.exists() {
                let fromID = snapshot.key
                let values = snapshot.value as! [String: String]
                let location = values["location"]!
                let emptyMessage = Messagenew.init(type: .text, content: "loading", owner: .sender, timestamp: 0, isRead: true, name: "", from_id: "")
                let conversation = Conversation.init(user: fromID as NSString, lastMessage: emptyMessage )
                conversations.append(conversation)
                conversation.lastMessage.downloadLastMessage(forLocation: location, completion: {
                    completion(conversations)
                })
            }
        })
        
    }
    
    //MARK: Inits
    init(user: NSString, lastMessage: Messagenew ) {
        self.UserID = user as String
        self.lastMessage = lastMessage
    }
}

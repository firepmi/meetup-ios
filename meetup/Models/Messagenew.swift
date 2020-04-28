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
import FirebaseStorage
class Messagenew {
    
    //MARK: Properties
    var owner: MessageOwner
    var type: MessageType
    var content: Any
    var timestamp: Int
    var isRead: Bool
    var UserName: String?
    var image: UIImage?
    var toID: String?
    var fromID = String()
   
    
    //MARK: Methods
    class func downloadAllMessages(forUserID: String, completion: @escaping (Messagenew) -> Swift.Void) {
       let currentUserID = standard.string(forKey: "userId") ?? ""
            Database.database().reference().child("users").child(currentUserID).child("conversations").child(forUserID).observe(.value, with: { (snapshot) in
                if snapshot.exists() {
                    let data = snapshot.value as! [String: String]
                    let location = data["location"]!
                    Database.database().reference().child("conversations").child(location).observe(.childAdded, with: { (snap) in
                        if snap.exists() {
                            let receivedMessage = snap.value as! [String: Any]
                            let messageType = receivedMessage["type"] as! String
                            var type = MessageType.text
                            switch messageType {
                                case "photo":
                                type = .photo
                                case "location":
                                type = .location
                            default: break
                            }
                            let content = receivedMessage["content"] as! String
                            let fromID = receivedMessage["fromID"] as! String
                            let toID = receivedMessage["toID"] as! String
                            let timestamp = receivedMessage["timestamp"] as! Int
                             let ToName = receivedMessage["toName"] as! String
                             let FromName = receivedMessage["fromName"] as! String
                            if fromID == currentUserID {
                                let message = Messagenew.init(type: type, content: content, owner: .receiver, timestamp: timestamp, isRead: true , name: ToName, from_id: toID)
                                completion(message)
                            } else {
                                let message = Messagenew.init(type: type, content: content, owner: .sender, timestamp: timestamp, isRead: true,name: FromName, from_id: fromID)
                                completion(message)
                            }
                        }
                    })
                }
            })
        
    }
    
    func downloadImage(indexpathRow: Int, completion: @escaping (Bool, Int) -> Swift.Void)  {
        if self.type == .photo {
            let imageLink = self.content as! String
            let imageURL = URL.init(string: imageLink)
            URLSession.shared.dataTask(with: imageURL!, completionHandler: { (data, response, error) in
                if error == nil {
                    self.image = UIImage.init(data: data!)
                    completion(true, indexpathRow)
                }
            }).resume()
        }
    }
    
    class func markMessagesRead(forUserID: String)  {
         let currentUserID = standard.string(forKey: "userId") ?? ""
            Database.database().reference().child("users").child(currentUserID).child("conversations").child(forUserID).observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                    let data = snapshot.value as! [String: String]
                    let location = data["location"]!
                    Database.database().reference().child("conversations").child(location).observeSingleEvent(of: .value, with: { (snap) in
                        if snap.exists() {
                            for item in snap.children {
                                let receivedMessage = (item as! DataSnapshot).value as! [String: Any]
                                let fromID = receivedMessage["fromID"] as! String
                                if fromID != currentUserID {
                                    Database.database().reference().child("conversations").child(location).child((item as! DataSnapshot).key).child("isRead").setValue(true)
                                }
                            }
                        }
                    })
                }
            })
       
    }
   
    func downloadLastMessage(forLocation: String, completion: @escaping () -> Swift.Void) {
         let currentUserID = standard.string(forKey: "userId") ?? ""
            Database.database().reference().child("conversations").child(forLocation).observe(.value, with: { (snapshot) in
                if snapshot.exists() {
                    for snap in snapshot.children {
                        let receivedMessage = (snap as! DataSnapshot).value as! [String: Any]
                        self.content = receivedMessage["content"]!
                        self.timestamp = receivedMessage["timestamp"] as! Int
                        let messageType = receivedMessage["type"] as! String
                        self.fromID = receivedMessage["fromID"] as! String
                        self.isRead = receivedMessage["isRead"] as! Bool
                        self.UserName = receivedMessage["ToName"] as? String
                        var type = MessageType.text
                        switch messageType {
                        case "text":
                            type = .text
                        case "photo":
                            type = .photo
                        case "location":
                            type = .location
                        default: break
                        }
                        self.type = type
                        if currentUserID == self.fromID {
                            self.owner = .receiver
                            self.fromID = receivedMessage["toID"] as! String
                             self.UserName = receivedMessage["toName"] as? String
                        } else {
                            self.owner = .sender
                            self.fromID = receivedMessage["fromID"] as! String
                             self.UserName = receivedMessage["fromName"] as? String
                        }
                        completion()
                    }
                }
            })
//
    }

    class func send(message: Messagenew, toID: String, toName: String, fromName:String, completion: @escaping (Bool) -> Swift.Void)  {
      let currentUserID = standard.string(forKey: "userId") ?? ""
            switch message.type {
            case .location:
                let values = ["type": "location", "content": message.content, "fromID": currentUserID, "toID": toID, "timestamp": message.timestamp, "isRead": false,"toName":toName , "fromName":fromName]
                Messagenew.uploadMessage(withValues: values, toID: toID, completion: { (status) in
                    completion(status)
                })
            case .photo:
                let image = message.content as! UIImage                    //UIImageJPEGRepresentation((message.content as! UIImage), 0.5)
                print(message.content)
                let child = UUID().uuidString
                print(child)
                if let data = image.compressImageToData(){
                    Storage.storage().reference().child("messagePics").child(child).putData(data, metadata: nil) { (metadata, error) in
                        
                        if error == nil {
                            
                            var  path:String = ""
                            let starsRef = Storage.storage().reference().child("messagePics").child(child)
                            // Fetch the download URL
                            starsRef.downloadURL { url, error in
                                if error != nil {
                                    // Handle any errors
                                } else {
                                    // Get the download URL for 'images/stars.jpg'
                                    print(url?.absoluteString ?? "")
                                    path = url!.absoluteString
                                    print(path)
                                }
                                if (path != "")
                                {
                                    let values = ["type": "photo", "content": path, "fromID": currentUserID, "toID": toID, "timestamp": message.timestamp, "isRead": false,"toName":toName , "fromName":fromName] as [String : Any]
                                    Messagenew.uploadMessage(withValues: values, toID: toID, completion: { (status) in
                                        completion(status)
                                        
                                    })
                                }
                                
                            }
                        }
                    }
                }
            case .text:
                let values = ["type": "text", "content": message.content, "fromID": currentUserID, "toID": toID, "timestamp": message.timestamp, "isRead": false,"toName":toName , "fromName":fromName]
                Messagenew.uploadMessage(withValues: values, toID: toID, completion: { (status) in
                    completion(status)
                })
            }
        
    }
    
    class func uploadMessage(withValues: [String: Any], toID: String, completion: @escaping (Bool) -> Swift.Void) {
         let currentUserID = standard.string(forKey: "userId") ?? ""
            Database.database().reference().child("users").child(currentUserID).child("conversations").child(toID).observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                    let data = snapshot.value as! [String: String]
                    let location = data["location"]!
                    Database.database().reference().child("conversations").child(location).childByAutoId().setValue(withValues, withCompletionBlock: { (error, _) in
                        if error == nil {
                            completion(true)
                        } else {
                            completion(false)
                        }
                    })
                } else {
                    Database.database().reference().child("conversations").childByAutoId().childByAutoId().setValue(withValues, withCompletionBlock: { (error, reference) in
                        let data = ["location": reference.parent!.key]
                        Database.database().reference().child("users").child(currentUserID).child("conversations").child(toID).updateChildValues(data as [AnyHashable : Any])
                        Database.database().reference().child("users").child(toID).child("conversations").child(currentUserID).updateChildValues(data as [AnyHashable : Any])
                        completion(true)
                    })
                }
            })
        
    }
    
    //MARK: Inits
    init(type: MessageType, content: Any, owner: MessageOwner, timestamp: Int, isRead: Bool ,name:String, from_id: String ) {
        self.type = type
        self.content = content
        self.owner = owner
        self.timestamp = timestamp
        self.isRead = isRead
        self.UserName = name
        self.fromID = from_id
    }
}

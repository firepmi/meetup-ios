//
//  Constant.swift
//  meetup
//
//  Created by An Phan on 3/23/19.
//  Copyright © 2019 MDSoft. All rights reserved.
//

import UIKit
import Firebase

var Is_Iphone6: Bool {
    get {
        return UIScreen.main.bounds.height <= 667
    }
}

var Is_Iphone6Plus: Bool {
    get {
        return UIScreen.main.bounds.height == 736
    }
}

let usernameRegex = "[A-Za-z0-9]{1,30}"
let passwordRegex = "^.{6,20}$"
let emailRegx = "[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"

/// Url's using in app
let mainURL = ""
let baseURL = "http://looklistenandfeel.online/"
//let baseURL = "http://192.168.1.238/api/"
//let baseURL = "http://3.8.95.229/"
let apiURL = "\(baseURL)api/"
let imageURL = "\(baseURL)app/webroot/img/user_profile_pics/"
let SocialUrl = ""
let standard = UserDefaults.standard

var user_name : String?
var email : String?
var social_id : String?
var social_type: String?
var image : String?
var deviceToken:String?



enum PhotoSource {
    case library
    case camera
}

enum ShowExtraView {
    case contacts
    case profile
    case preview
    case map
}

enum MessageType {
    case photo
    case text
    case location
}

enum MessageOwner {
    case sender
    case receiver
}

struct Constant
{
    struct refs
    {
        static let databaseRoot = Database.database().reference()
        static let databaseChats = databaseRoot.child("chats")
    }
}
public extension UIDevice {

    class var isPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }

    class var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }

    class var isTV: Bool {
        return UIDevice.current.userInterfaceIdiom == .tv
    }

    class var isCarPlay: Bool {
        return UIDevice.current.userInterfaceIdiom == .carPlay
    }

}

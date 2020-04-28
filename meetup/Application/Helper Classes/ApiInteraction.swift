//
//  ApiInteraction.swift
//  meetup
//
//  Created by developer on 23/04/19.
//  Copyright © 2019 MDSoft. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class ApiInteraction : NSObject{
    
    static let sharedInstance = ApiInteraction()
    
    func funcToHitApi(url: String, param: [String: Any]?, header: [String: Any], success: @escaping (JSON)-> Void, failure: @escaping (String)-> Void){
        ApiManager.sharedInstance.requestPOSTURL(url, params: param as [String: AnyObject]?, headers: header as? [String : String], success: { (json) in
            success(json)
        }) { (error) in
            failure(error)
        }
    }
    
    func funcToHitMultipartApi(url: String, param: [String: Any]?,header: [String: Any], imageArray: [UIImage], imageName: [String], success: @escaping (JSON)-> Void, failure: @escaping (String)-> Void){
        ApiManager.sharedInstance.requestMultiPartURL(url, params: param as [String : AnyObject]?, headers: header as? [String : String] , imagesArray: imageArray, imageName: imageName, success: { (json) in
            success(json)
        }) { (error) in
            failure(error)
        }
    }
    
    func funcToHitVideoMultipartApi(url: String, param: [String: Any]?,header: [String: Any], videoPath: URL?, videoName: String, success: @escaping (JSON)-> Void, failure: @escaping (String)-> Void){
        ApiManager.sharedInstance.requestMultiPartURLVideo(url, params: param as [String : AnyObject]?, headers: header as? [String : String], VideoURL: videoPath, videoName: videoName, success: { (json) in
            success(json)
        }) { (error) in
            failure(error)
        }
    }
    
    func onlineApi(status: Bool){
        let param = ["userID":standard.string(forKey: "userId") ?? "",
                     "avail_status": (status) ? "1" : "0",
                     "Date": "\(Date())"]
        print(param)
        ApiManager.sharedInstance.requestPOSTURL(apiURL + "setAvailabilityStatus", params: param as [String : AnyObject], headers: [:], success: { (json) in
            print(json)
        }) { (error) in
            print(error)
        }
    }
    
    //function to hit two Image together
    func funcToHitTwoMultipartApi(url: String, param: [String: Any]?,header: [String: Any], imageArray: [UIImage], imageName: [String],videoImage: UIImage, videoImageName: String, success: @escaping (JSON)-> Void, failure: @escaping (String)-> Void){
        ApiManager.sharedInstance.requestTwoMultiPartURL(url, params: param as? [String : String], headers: header as? [String : String] , imagesArray: imageArray, imageName: imageName,videoImage: videoImage, videoImageName: videoImageName, success: { (json) in
            success(json)
        }) { (error) in
            failure(error)
        }
    }
    
    func funcToGetApi(url: String, param: [String: Any]?, header: [String: Any], success: @escaping (JSON)-> Void, failure: @escaping (String)-> Void){
        ApiManager.sharedInstance.requestGetURL(url, params: param as [String : AnyObject]?, headers: header as? [String : String], success: { (json) in
            success(json)
        }) { (error) in
            failure(error)
        }
    }

}

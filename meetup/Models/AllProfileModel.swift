//
//  AllProfileModel.swift
//
//  Created by developer on 01/05/19
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class AllProfileModel: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kAllProfileModelSetFavouriteKey: String = "setFavourite"
  private let kAllProfileModelUnlikeKey: String = "Unlike"
  private let kAllProfileModelDistanceKey: String = "Distance"
  private let kAllProfileModelVideoUrlKey: String = "videoUrl"
  private let kAllProfileModelOnlineStatusKey: String = "OnlineStatus"
  private let kAllProfileModelUserIDKey: String = "userID"
  private let kAllProfileModelLikedKey: String = "Liked"
  private let kAllProfileModelUserNameKey: String = "userName"
  private let kAllProfileModelReportKey: String = "Report"
  private let kAllProfileModellast_activeKey: String = "last_active"
  private let kAllProfileModelvideoImageKey: String = "videoImage"
    
  // MARK: Properties
  public var setFavourite: String?
  public var unlike: String?
  public var distance: String?
  public var videoUrl: String?
  public var onlineStatus: String?
  public var userID: String?
  public var liked: String?
  public var userName: String?
  public var report: String?
  public var last_active : String?
  public var videoImage: String?
  // MARK: SwiftyJSON Initalizers
  /**
   Initates the instance based on the object
   - parameter object: The object of either Dictionary or Array kind that was passed.
   - returns: An initalized instance of the class.
  */
  convenience public init(object: Any) {
    self.init(json: JSON(object))
  }

  /**
   Initates the instance based on the JSON that was passed.
   - parameter json: JSON object from SwiftyJSON.
   - returns: An initalized instance of the class.
  */
  public init(json: JSON) {
    setFavourite = json[kAllProfileModelSetFavouriteKey].string
    unlike = json[kAllProfileModelUnlikeKey].string
    distance = json[kAllProfileModelDistanceKey].string
    videoUrl = json[kAllProfileModelVideoUrlKey].string
    onlineStatus = json[kAllProfileModelOnlineStatusKey].string
    userID = json[kAllProfileModelUserIDKey].string
    liked = json[kAllProfileModelLikedKey].string
    userName = json[kAllProfileModelUserNameKey].string
    report = json[kAllProfileModelReportKey].string
    last_active = json[kAllProfileModellast_activeKey].string
    videoImage = json[kAllProfileModelvideoImageKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = setFavourite { dictionary[kAllProfileModelSetFavouriteKey] = value }
    if let value = unlike { dictionary[kAllProfileModelUnlikeKey] = value }
    if let value = distance { dictionary[kAllProfileModelDistanceKey] = value }
    if let value = videoUrl { dictionary[kAllProfileModelVideoUrlKey] = value }
    if let value = onlineStatus { dictionary[kAllProfileModelOnlineStatusKey] = value }
    if let value = userID { dictionary[kAllProfileModelUserIDKey] = value }
    if let value = liked { dictionary[kAllProfileModelLikedKey] = value }
    if let value = userName { dictionary[kAllProfileModelUserNameKey] = value }
    if let value = report { dictionary[kAllProfileModelReportKey] = value }
    if let value = last_active { dictionary[kAllProfileModellast_activeKey] = value }
    if let value = videoImage { dictionary[kAllProfileModelvideoImageKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.setFavourite = aDecoder.decodeObject(forKey: kAllProfileModelSetFavouriteKey) as? String
    self.unlike = aDecoder.decodeObject(forKey: kAllProfileModelUnlikeKey) as? String
    self.distance = aDecoder.decodeObject(forKey: kAllProfileModelDistanceKey) as? String
    self.videoUrl = aDecoder.decodeObject(forKey: kAllProfileModelVideoUrlKey) as? String
    self.onlineStatus = aDecoder.decodeObject(forKey: kAllProfileModelOnlineStatusKey) as? String
    self.userID = aDecoder.decodeObject(forKey: kAllProfileModelUserIDKey) as? String
    self.liked = aDecoder.decodeObject(forKey: kAllProfileModelLikedKey) as? String
    self.userName = aDecoder.decodeObject(forKey: kAllProfileModelUserNameKey) as? String
    self.report = aDecoder.decodeObject(forKey: kAllProfileModelReportKey) as? String
    self.last_active = aDecoder.decodeObject(forKey: kAllProfileModellast_activeKey) as? String
    self.videoImage = aDecoder.decodeObject(forKey: kAllProfileModelvideoImageKey) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(setFavourite, forKey: kAllProfileModelSetFavouriteKey)
    aCoder.encode(unlike, forKey: kAllProfileModelUnlikeKey)
    aCoder.encode(distance, forKey: kAllProfileModelDistanceKey)
    aCoder.encode(videoUrl, forKey: kAllProfileModelVideoUrlKey)
    aCoder.encode(onlineStatus, forKey: kAllProfileModelOnlineStatusKey)
    aCoder.encode(userID, forKey: kAllProfileModelUserIDKey)
    aCoder.encode(liked, forKey: kAllProfileModelLikedKey)
    aCoder.encode(userName, forKey: kAllProfileModelUserNameKey)
    aCoder.encode(report, forKey: kAllProfileModelReportKey)
    aCoder.encode(last_active, forKey: kAllProfileModellast_activeKey)
    aCoder.encode(videoImage, forKey: kAllProfileModelvideoImageKey)
  }
}

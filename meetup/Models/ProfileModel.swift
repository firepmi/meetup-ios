//
//  ProfileModel.swift
//
//  Created by developer on 30/04/19
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class ProfileModel: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kProfileModelGoogleplusUrlKey: String = "googleplus url"
  private let kProfileModelBodyTypeKey: String = "Body Type"
  private let kProfileModelYoutubeUrlKey: String = "youtube url"
  private let kProfileModelUserNameKey: String = "user name"
  private let kProfileModelHobbiesKey: String = "Hobbies"
  private let kProfileModelAddressKey: String = "address"
  private let kProfileModelLikePercentageKey: String = "Like Percentage"
  private let kProfileModelFacebookUrlKey: String = "facebook url"
  private let kProfileModelFavouritePercentageKey: String = "Favourite"
  private let kProfileModelHeight: String = "height"
  private let kProfileModelVedioUrlKey: String = "Vedio url"
  private let kProfileModelLongestRelationshipKey: String = "Longest Relationship"
  private let kProfileModelKidsKey: String = "kids"
  private let kProfileModelUserImageKey: String = "user image"
  private let kProfileModelUnlikePercentageKey: String = "Unlike Percentage"
  private let kProfileModelInstagramUrlKey: String = "instagram url"
  private let kProfileModelOnlineStatusKey: String = "online status"
  private let kProfileModelUserAgeKey: String = "user age"
  private let kProfileModelAboutmeKey: String = "Aboutme"
  private let kProfileModelDateOfBirthKey: String = "date of birth"
  private let kProfileModelvideoImageKey: String = "videoImage"
    
  // MARK: Properties
  public var googleplusUrl: String?
  public var bodyType: String?
  public var youtubeUrl: String?
  public var userName: String?
  public var hobbies: String?
  public var address: String?
  public var likePercentage: String?
  public var facebookUrl: String?
  public var favouritePercentage: String?
  public var height: String?
  public var vedioUrl: String?
  public var longestRelationship: String?
  public var kids: String?
  public var userImage: String?
  public var unlikePercentage: String?
  public var instagramUrl: String?
  public var onlineStatus: String?
  public var userAge: Int?
  public var Aboutme: String?
  public var DateOfBirth: Int?
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
    googleplusUrl = json[kProfileModelGoogleplusUrlKey].string
    bodyType = json[kProfileModelBodyTypeKey].string
    youtubeUrl = json[kProfileModelYoutubeUrlKey].string
    userName = json[kProfileModelUserNameKey].string
    hobbies = json[kProfileModelHobbiesKey].string
    address = json[kProfileModelAddressKey].string
    likePercentage = json[kProfileModelLikePercentageKey].string
    facebookUrl = json[kProfileModelFacebookUrlKey].string
    favouritePercentage = json[kProfileModelFavouritePercentageKey].string
    height = json[kProfileModelHeight].string
    vedioUrl = json[kProfileModelVedioUrlKey].string
    longestRelationship = json[kProfileModelLongestRelationshipKey].string
    kids = json[kProfileModelKidsKey].string
    userImage = json[kProfileModelUserImageKey].string
    unlikePercentage = json[kProfileModelUnlikePercentageKey].string
    instagramUrl = json[kProfileModelInstagramUrlKey].string
    onlineStatus = json[kProfileModelOnlineStatusKey].string
    userAge = json[kProfileModelUserAgeKey].int
    Aboutme = json[kProfileModelAboutmeKey].string
    DateOfBirth = json[kProfileModelDateOfBirthKey].int
    videoImage = json[kProfileModelvideoImageKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = googleplusUrl { dictionary[kProfileModelGoogleplusUrlKey] = value }
    if let value = bodyType { dictionary[kProfileModelBodyTypeKey] = value }
    if let value = youtubeUrl { dictionary[kProfileModelYoutubeUrlKey] = value }
    if let value = userName { dictionary[kProfileModelUserNameKey] = value }
    if let value = hobbies { dictionary[kProfileModelHobbiesKey] = value }
    if let value = address { dictionary[kProfileModelAddressKey] = value }
    if let value = likePercentage { dictionary[kProfileModelLikePercentageKey] = value }
    if let value = facebookUrl { dictionary[kProfileModelFacebookUrlKey] = value }
    if let value = favouritePercentage { dictionary[kProfileModelFavouritePercentageKey] = value }
    if let value = height { dictionary[kProfileModelHeight] = value }
    if let value = vedioUrl { dictionary[kProfileModelVedioUrlKey] = value }
    if let value = longestRelationship { dictionary[kProfileModelLongestRelationshipKey] = value }
    if let value = kids { dictionary[kProfileModelKidsKey] = value }
    if let value = userImage { dictionary[kProfileModelUserImageKey] = value }
    if let value = unlikePercentage { dictionary[kProfileModelUnlikePercentageKey] = value }
    if let value = instagramUrl { dictionary[kProfileModelInstagramUrlKey] = value }
    if let value = onlineStatus { dictionary[kProfileModelOnlineStatusKey] = value }
    if let value = userAge { dictionary[kProfileModelUserAgeKey] = value }
    if let value = Aboutme { dictionary[kProfileModelAboutmeKey] = value }
    if let value = DateOfBirth { dictionary[kProfileModelDateOfBirthKey] = value }
    if let value = videoImage { dictionary[kProfileModelvideoImageKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.googleplusUrl = aDecoder.decodeObject(forKey: kProfileModelGoogleplusUrlKey) as? String
    self.bodyType = aDecoder.decodeObject(forKey: kProfileModelBodyTypeKey) as? String
    self.youtubeUrl = aDecoder.decodeObject(forKey: kProfileModelYoutubeUrlKey) as? String
    self.userName = aDecoder.decodeObject(forKey: kProfileModelUserNameKey) as? String
    self.hobbies = aDecoder.decodeObject(forKey: kProfileModelHobbiesKey) as? String
    self.address = aDecoder.decodeObject(forKey: kProfileModelAddressKey) as? String
    self.likePercentage = aDecoder.decodeObject(forKey: kProfileModelLikePercentageKey) as? String
    self.facebookUrl = aDecoder.decodeObject(forKey: kProfileModelFacebookUrlKey) as? String
    self.favouritePercentage = aDecoder.decodeObject(forKey: kProfileModelFavouritePercentageKey) as? String
    self.height = aDecoder.decodeObject(forKey: kProfileModelHeight) as? String
    self.vedioUrl = aDecoder.decodeObject(forKey: kProfileModelVedioUrlKey) as? String
    self.longestRelationship = aDecoder.decodeObject(forKey: kProfileModelLongestRelationshipKey) as? String
    self.kids = aDecoder.decodeObject(forKey: kProfileModelKidsKey) as? String
    self.userImage = aDecoder.decodeObject(forKey: kProfileModelUserImageKey) as? String
    self.unlikePercentage = aDecoder.decodeObject(forKey: kProfileModelUnlikePercentageKey) as? String
    self.instagramUrl = aDecoder.decodeObject(forKey: kProfileModelInstagramUrlKey) as? String
    self.onlineStatus = aDecoder.decodeObject(forKey: kProfileModelOnlineStatusKey) as? String
    self.userAge = aDecoder.decodeObject(forKey: kProfileModelUserAgeKey) as? Int
    self.Aboutme = aDecoder.decodeObject(forKey: kProfileModelAboutmeKey) as? String
    self.DateOfBirth = aDecoder.decodeObject(forKey: kProfileModelDateOfBirthKey) as? Int
    self.videoImage = aDecoder.decodeObject(forKey: kProfileModelvideoImageKey) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(googleplusUrl, forKey: kProfileModelGoogleplusUrlKey)
    aCoder.encode(bodyType, forKey: kProfileModelBodyTypeKey)
    aCoder.encode(youtubeUrl, forKey: kProfileModelYoutubeUrlKey)
    aCoder.encode(userName, forKey: kProfileModelUserNameKey)
    aCoder.encode(hobbies, forKey: kProfileModelHobbiesKey)
    aCoder.encode(address, forKey: kProfileModelAddressKey)
    aCoder.encode(likePercentage, forKey: kProfileModelLikePercentageKey)
    aCoder.encode(facebookUrl, forKey: kProfileModelFacebookUrlKey)
    aCoder.encode(favouritePercentage, forKey: kProfileModelFavouritePercentageKey)
    aCoder.encode(height, forKey: kProfileModelHeight)
    aCoder.encode(vedioUrl, forKey: kProfileModelVedioUrlKey)
    aCoder.encode(longestRelationship, forKey: kProfileModelLongestRelationshipKey)
    aCoder.encode(kids, forKey: kProfileModelKidsKey)
    aCoder.encode(userImage, forKey: kProfileModelUserImageKey)
    aCoder.encode(unlikePercentage, forKey: kProfileModelUnlikePercentageKey)
    aCoder.encode(instagramUrl, forKey: kProfileModelInstagramUrlKey)
    aCoder.encode(onlineStatus, forKey: kProfileModelOnlineStatusKey)
    aCoder.encode(userAge, forKey: kProfileModelUserAgeKey)
    aCoder.encode(Aboutme, forKey: kProfileModelAboutmeKey)
    aCoder.encode(DateOfBirth, forKey: kProfileModelDateOfBirthKey)
    aCoder.encode(videoImage, forKey: kProfileModelvideoImageKey)
  }
}

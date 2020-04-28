//
//  MatchesModel.swift
//
//  Created by developer on 03/05/19
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class MatchesModel: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kMatchesModelUserNameKey: String = "userName"
  private let kMatchesModelAboutmeKey: String = "Aboutme"
  private let kMatchesModelProfilePicKey: String = "profilePic"
  private let kMatchesModelUserIDKey: String = "userID"

  // MARK: Properties
  public var userName: String?
  public var aboutme: String?
  public var profilePic: String?
  public var userID: String?

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
    userName = json[kMatchesModelUserNameKey].string
    aboutme = json[kMatchesModelAboutmeKey].string
    profilePic = json[kMatchesModelProfilePicKey].string
    userID = json[kMatchesModelUserIDKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = userName { dictionary[kMatchesModelUserNameKey] = value }
    if let value = aboutme { dictionary[kMatchesModelAboutmeKey] = value }
    if let value = profilePic { dictionary[kMatchesModelProfilePicKey] = value }
    if let value = userID { dictionary[kMatchesModelUserIDKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.userName = aDecoder.decodeObject(forKey: kMatchesModelUserNameKey) as? String
    self.aboutme = aDecoder.decodeObject(forKey: kMatchesModelAboutmeKey) as? String
    self.profilePic = aDecoder.decodeObject(forKey: kMatchesModelProfilePicKey) as? String
    self.userID = aDecoder.decodeObject(forKey: kMatchesModelUserIDKey) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(userName, forKey: kMatchesModelUserNameKey)
    aCoder.encode(aboutme, forKey: kMatchesModelAboutmeKey)
    aCoder.encode(profilePic, forKey: kMatchesModelProfilePicKey)
    aCoder.encode(userID, forKey: kMatchesModelUserIDKey)
  }

}

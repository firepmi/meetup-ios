//
//  CommentsModel.swift
//
//  Created by developer on 10/05/19
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class CommentsModel: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kCommentsModelCreateDateKey: String = "CreateDate"
  private let kCommentsModelUserNameKey: String = "userName"
  private let kCommentsModelProfilePicKey: String = "ProfilePic"
  private let kCommentsModelCommentKey: String = "Comment"
  private let kCommentsModelRatingKey: String = "Rating"
  private let kCommentsModelcomment_idKey: String = "comment_id"
  private let kCommentsModellikesKey: String = "likes"
  private let kCommentsModelcomment_user_idKey: String = "comment_user_id"
  private let kCommentsModellikedKey: String = "liked"
    
  // MARK: Properties
  public var createDate: String?
  public var userName: String?
  public var profilePic: String?
  public var comment: String?
  public var rating: Int?
  public var comment_id: String?
  public var likes: Int?
  public var comment_user_id: String?
  public var liked: String?
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
    createDate = json[kCommentsModelCreateDateKey].string
    userName = json[kCommentsModelUserNameKey].string
    profilePic = json[kCommentsModelProfilePicKey].string
    comment = json[kCommentsModelCommentKey].string
    rating = json[kCommentsModelRatingKey].intValue
    comment_id = json[kCommentsModelcomment_idKey].string
    likes = json[kCommentsModellikesKey].intValue
    comment_user_id = json[kCommentsModelcomment_user_idKey].string
    liked = json[kCommentsModellikedKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = createDate { dictionary[kCommentsModelCreateDateKey] = value }
    if let value = userName { dictionary[kCommentsModelUserNameKey] = value }
    if let value = profilePic { dictionary[kCommentsModelProfilePicKey] = value }
    if let value = comment { dictionary[kCommentsModelCommentKey] = value }
    if let value = rating { dictionary[kCommentsModelRatingKey] = value }
    if let value = comment_id { dictionary[kCommentsModelcomment_idKey] = value }
    if let value = likes { dictionary[kCommentsModellikesKey] = value }
    if let value = comment_user_id { dictionary[kCommentsModelcomment_user_idKey] = value }
    if let value = liked { dictionary[kCommentsModellikedKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.createDate = aDecoder.decodeObject(forKey: kCommentsModelCreateDateKey) as? String
    self.userName = aDecoder.decodeObject(forKey: kCommentsModelUserNameKey) as? String
    self.profilePic = aDecoder.decodeObject(forKey: kCommentsModelProfilePicKey) as? String
    self.comment = aDecoder.decodeObject(forKey: kCommentsModelCommentKey) as? String
    self.rating = aDecoder.decodeObject(forKey: kCommentsModelRatingKey) as? Int
    self.comment_id = aDecoder.decodeObject(forKey: kCommentsModelcomment_idKey) as? String
    self.likes = aDecoder.decodeObject(forKey: kCommentsModellikesKey) as? Int
    self.comment_user_id = aDecoder.decodeObject(forKey: kCommentsModelcomment_user_idKey) as? String
    self.liked = aDecoder.decodeObject(forKey: kCommentsModellikedKey) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(createDate, forKey: kCommentsModelCreateDateKey)
    aCoder.encode(userName, forKey: kCommentsModelUserNameKey)
    aCoder.encode(profilePic, forKey: kCommentsModelProfilePicKey)
    aCoder.encode(comment, forKey: kCommentsModelCommentKey)
    aCoder.encode(rating, forKey: kCommentsModelRatingKey)
    aCoder.encode(comment_id, forKey: kCommentsModelcomment_idKey)
    aCoder.encode(likes, forKey: kCommentsModellikesKey)
    aCoder.encode(comment_user_id, forKey: kCommentsModelcomment_user_idKey)
    aCoder.encode(liked, forKey: kCommentsModellikedKey)
  }

}

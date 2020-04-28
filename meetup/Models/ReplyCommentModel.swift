//
//  ReplyCommentModel.swift
//
//  Created by developer on 15/05/19
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class ReplyCommentModel: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kReplyCommentModelInternalIdentifierKey: String = "id"
  private let kReplyCommentModelCommentUserNameKey: String = "comment_user_name"
  private let kReplyCommentModelLikesKey: String = "likes"
  private let kReplyCommentModelCommentReplyKey: String = "comment_reply"
  private let kReplyCommentModelCreateDateKey: String = "CreateDate"
  private let kReplyCommentModelCommentIdKey: String = "comment_id"
  private let kReplyCommentModelProfilePicKey: String = "ProfilePic"
  private let kReplyCommentModelCommentUserIdKey: String = "comment_user_id"
  private let kReplyCommentModelLikedKey: String = "liked"
  // MARK: Properties
  public var internalIdentifier: String? 
  public var commentUserName: String?
  public var likes: String?
  public var commentReply: String?
  public var createDate: String?
  public var commentId: String?
  public var profilePic: String?
  public var commentUserId: String?
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
    internalIdentifier = json[kReplyCommentModelInternalIdentifierKey].string
    commentUserName = json[kReplyCommentModelCommentUserNameKey].string
    likes = json[kReplyCommentModelLikesKey].string
    commentReply = json[kReplyCommentModelCommentReplyKey].string
    createDate = json[kReplyCommentModelCreateDateKey].string
    commentId = json[kReplyCommentModelCommentIdKey].string
    profilePic = json[kReplyCommentModelProfilePicKey].string
    commentUserId = json[kReplyCommentModelCommentUserIdKey].string
    liked = json[kReplyCommentModelLikedKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = internalIdentifier { dictionary[kReplyCommentModelInternalIdentifierKey] = value }
    if let value = commentUserName { dictionary[kReplyCommentModelCommentUserNameKey] = value }
    if let value = likes { dictionary[kReplyCommentModelLikesKey] = value }
    if let value = commentReply { dictionary[kReplyCommentModelCommentReplyKey] = value }
    if let value = createDate { dictionary[kReplyCommentModelCreateDateKey] = value }
    if let value = commentId { dictionary[kReplyCommentModelCommentIdKey] = value }
    if let value = profilePic { dictionary[kReplyCommentModelProfilePicKey] = value }
    if let value = commentUserId { dictionary[kReplyCommentModelCommentUserIdKey] = value }
    if let value = liked { dictionary[kReplyCommentModelLikedKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.internalIdentifier = aDecoder.decodeObject(forKey: kReplyCommentModelInternalIdentifierKey) as? String
    self.commentUserName = aDecoder.decodeObject(forKey: kReplyCommentModelCommentUserNameKey) as? String
    self.likes = aDecoder.decodeObject(forKey: kReplyCommentModelLikesKey) as? String
    self.commentReply = aDecoder.decodeObject(forKey: kReplyCommentModelCommentReplyKey) as? String
    self.createDate = aDecoder.decodeObject(forKey: kReplyCommentModelCreateDateKey) as? String
    self.commentId = aDecoder.decodeObject(forKey: kReplyCommentModelCommentIdKey) as? String
    self.profilePic = aDecoder.decodeObject(forKey: kReplyCommentModelProfilePicKey) as? String
    self.commentUserId = aDecoder.decodeObject(forKey: kReplyCommentModelCommentUserIdKey) as? String
    self.liked = aDecoder.decodeObject(forKey: kReplyCommentModelLikedKey) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(internalIdentifier, forKey: kReplyCommentModelInternalIdentifierKey)
    aCoder.encode(commentUserName, forKey: kReplyCommentModelCommentUserNameKey)
    aCoder.encode(likes, forKey: kReplyCommentModelLikesKey)
    aCoder.encode(commentReply, forKey: kReplyCommentModelCommentReplyKey)
    aCoder.encode(createDate, forKey: kReplyCommentModelCreateDateKey)
    aCoder.encode(commentId, forKey: kReplyCommentModelCommentIdKey)
    aCoder.encode(profilePic, forKey: kReplyCommentModelProfilePicKey)
    aCoder.encode(commentUserId, forKey: kReplyCommentModelCommentUserIdKey)
    aCoder.encode(liked, forKey: kReplyCommentModelLikedKey)
  }

}

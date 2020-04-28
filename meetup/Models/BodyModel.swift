//
//  BodyModel.swift
//
//  Created by developer on 04/06/19
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class BodyModel: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kBodyModelInternalIdentifierKey: String = "id"
  private let kBodyModelBodyTypeStatusKey: String = "body_type_status"
  private let kBodyModelBodyTypeNamesKey: String = "body_type_names"

  // MARK: Properties
  public var internalIdentifier: String?
  public var bodyTypeStatus: String?
  public var bodyTypeNames: String?

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
    internalIdentifier = json[kBodyModelInternalIdentifierKey].string
    bodyTypeStatus = json[kBodyModelBodyTypeStatusKey].string
    bodyTypeNames = json[kBodyModelBodyTypeNamesKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = internalIdentifier { dictionary[kBodyModelInternalIdentifierKey] = value }
    if let value = bodyTypeStatus { dictionary[kBodyModelBodyTypeStatusKey] = value }
    if let value = bodyTypeNames { dictionary[kBodyModelBodyTypeNamesKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.internalIdentifier = aDecoder.decodeObject(forKey: kBodyModelInternalIdentifierKey) as? String
    self.bodyTypeStatus = aDecoder.decodeObject(forKey: kBodyModelBodyTypeStatusKey) as? String
    self.bodyTypeNames = aDecoder.decodeObject(forKey: kBodyModelBodyTypeNamesKey) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(internalIdentifier, forKey: kBodyModelInternalIdentifierKey)
    aCoder.encode(bodyTypeStatus, forKey: kBodyModelBodyTypeStatusKey)
    aCoder.encode(bodyTypeNames, forKey: kBodyModelBodyTypeNamesKey)
  }

}

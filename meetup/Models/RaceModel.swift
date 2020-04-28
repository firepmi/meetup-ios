//
//  RaceModel.swift
//
//  Created by developer on 04/06/19
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class RaceModel: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kRaceModelInternalIdentifierKey: String = "id"
  private let kRaceModelRaceStatusKey: String = "race_status"
  private let kRaceModelRaceNameKey: String = "race_name"

  // MARK: Properties
  public var internalIdentifier: String?
  public var raceStatus: String?
  public var raceName: String?

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
    internalIdentifier = json[kRaceModelInternalIdentifierKey].string
    raceStatus = json[kRaceModelRaceStatusKey].string
    raceName = json[kRaceModelRaceNameKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = internalIdentifier { dictionary[kRaceModelInternalIdentifierKey] = value }
    if let value = raceStatus { dictionary[kRaceModelRaceStatusKey] = value }
    if let value = raceName { dictionary[kRaceModelRaceNameKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.internalIdentifier = aDecoder.decodeObject(forKey: kRaceModelInternalIdentifierKey) as? String
    self.raceStatus = aDecoder.decodeObject(forKey: kRaceModelRaceStatusKey) as? String
    self.raceName = aDecoder.decodeObject(forKey: kRaceModelRaceNameKey) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(internalIdentifier, forKey: kRaceModelInternalIdentifierKey)
    aCoder.encode(raceStatus, forKey: kRaceModelRaceStatusKey)
    aCoder.encode(raceName, forKey: kRaceModelRaceNameKey)
  }

}

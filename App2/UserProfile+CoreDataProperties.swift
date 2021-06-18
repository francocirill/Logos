//
//  UserProfile+CoreDataProperties.swift
//  App2
//
//  Created by Marco Venere on 20/02/21.
//
//

import Foundation
import CoreData


extension UserProfile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserProfile> {
        return NSFetchRequest<UserProfile>(entityName: "UserProfile")
    }

    @NSManaged public var avatar: String?
    @NSManaged public var name: String?
    @NSManaged public var outLoud: Bool
    @NSManaged public var showPics: Bool
    @NSManaged public var lastLevel: Int16
    @NSManaged public var points: Int64

}

extension UserProfile : Identifiable {

}

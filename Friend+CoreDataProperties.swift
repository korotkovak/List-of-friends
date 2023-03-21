//
//  Friend+CoreDataProperties.swift
//  List of friends
//
//  Created by Kristina Korotkova on 21/03/23.
//
//

import Foundation
import CoreData

extension Friend {
    @NSManaged public var dateOfBirth: String?
    @NSManaged public var gender: String?
    @NSManaged public var name: String?
    @NSManaged public var avatar: Data?

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Friend> {
        return NSFetchRequest<Friend>(entityName: "Friend")
    }
}

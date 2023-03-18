//
//  Friend+CoreDataProperties.swift
//  List of friends
//
//  Created by Kristina Korotkova on 17/03/23.
//
//

import Foundation
import CoreData

extension Friend {
    @NSManaged public var name: String?
    @NSManaged public var date: String?
    @NSManaged public var gender: String?

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Friend> {
        return NSFetchRequest<Friend>(entityName: "Friend")
    }
}

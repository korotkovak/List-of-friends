//
//  Friend+CoreDataClass.swift
//  List of friends
//
//  Created by Kristina Korotkova on 17/03/23.
//
//

import Foundation
import CoreData

@objc(Friend)
public class Friend: NSManagedObject {
    convenience init() {
        self.init(entity: CoreDataManager.shared.entityForName("Friend"),
                  insertInto: CoreDataManager.shared.context)
    }
}

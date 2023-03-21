//
//  CoreDataManager.swift
//  List of friends
//
//  Created by Kristina Korotkova on 17/03/23.
//

import Foundation
import CoreData

class CoreDataManager {

    static let shared = CoreDataManager()
    var friends: [Friend]?

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "List_of_friends")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    private lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()

    private func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func fetchFriends() {
        let fetchRequest: NSFetchRequest<Friend> = Friend.fetchRequest()
        do {
            friends = try context.fetch(fetchRequest)
        } catch {
            print(error)
        }
    }

    func addNewFriend(name: String, gender: String,  dateOfBirth: String) {
        let friend = Friend(context: context)
        friend.name = name
        friend.gender = gender
        friend.dateOfBirth = dateOfBirth
        updateFriend()
    }

    func deleteFriend(_ index: Int) {
        guard let friend = friends?[index] else { return }
        context.delete(friend)
        updateFriend()
    }

    func updateFriend() {
        saveContext()
        fetchFriends()
    }
}

//
//  CoreDataManager.swift
//  List of friends
//
//  Created by Kristina Korotkova on 17/03/23.
//

import Foundation
import CoreData

protocol ServiceCoreData {
    func fetchFriends()
    func addFriend(name: String)
    func getFriendsCount() -> Int
    func getFriend(_ index: Int) -> Friend?
    func deleteFriend(_ index: Int)
    func updateFriend()
}

class CoreDataManager: ServiceCoreData {

    static let shared = CoreDataManager()
    private var friends: [Friend]?

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
        do {
            friends = try context.fetch(Friend.fetchRequest())
        } catch {
            print(error)
        }
    }

    func addFriend(name: String) {
        let friend = Friend(context: context)
        friend.name = name
        friend.gender = "Male"
        friend.date = "01.01.2023"

        do {
            try context.save()
            fetchFriends()
        } catch {
            print(error)
        }
    }

    func getFriendsCount() -> Int {
        friends?.count ?? 0
    }

    func getFriend(_ index: Int) -> Friend? {
        friends?[index]
    }

    func deleteFriend(_ index: Int) {
        guard let friend = friends?[index] else { return }
        context.delete(friend)
        do {
            try context.save()
            fetchFriends()
        } catch {
            print(error.localizedDescription)
        }
    }

    func updateFriend() {
        do {
            if context.hasChanges {
                try context.save()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

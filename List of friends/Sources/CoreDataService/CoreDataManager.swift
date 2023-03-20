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
    func addFriend(name: String, gender: String, date: String)
    func getFriendsCount() -> Int
    func getFriend(_ index: Int) -> Friend?
    func deleteFriend(_ index: Int)
    func updateFriend(friend: Friend, name: String?, date: String?, gender: String?)
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

     func saveContext () {
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

    func addFriend(name: String, gender: String, date: String) {
        let friend = Friend(context: context)
        friend.name = name
        friend.gender = gender
        friend.date = date

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

//    func updateFriend() {
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//    }

    func updateFriend(friend: Friend, name: String?, date: String?, gender: String?) {
        friend.name = name
        friend.date = date
        friend.gender = gender
        print(name, gender, date)
        // тут я эти данные
        do {
            try context.save()
//            fetchFriends()
        } catch {
            print(error.localizedDescription)
        }
    }
}

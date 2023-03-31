//
//  CoreDataProtocol.swift
//  List of friends
//
//  Created by Kristina Korotkova on 31/03/23.
//

import Foundation

protocol CoreDataProtocol {
    var friends: [Friend]? { get set }
    func fetchFriends()
    func addNewFriend(name: String, gender: String,  dateOfBirth: String)
    func deleteFriend(_ index: Int)
    func updateFriend()
}

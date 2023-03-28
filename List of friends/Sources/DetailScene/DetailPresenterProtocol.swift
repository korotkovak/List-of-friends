//
//  DetailPresenterProtocol.swift
//  List of friends
//
//  Created by Kristina Korotkova on 28/03/23.
//

import Foundation

protocol DetailPresenterOutput: AnyObject {
    var friend: Friend? { get set }
    func updateFriendInformation()
}

protocol DetailPresenterInput {
    func setFriend()
    func updateFriend(avatar: Data,
                      name: String,
                      gender: String,
                      dateOfBirth: String)
}

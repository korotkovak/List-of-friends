//
//  PresenterProtocol.swift
//  List of friends
//
//  Created by Kristina Korotkova on 28/03/23.
//

import Foundation

protocol HomePresenterOutput: AnyObject {
    func showFriends()
}

protocol HomePresenterInput {
    func fetchFriends()
    func addNewFriend(name: String)
    func getFreindsCount() -> Int
    func getFriend(_ index: Int) -> Friend?
    func deleteFriend(_ index: Int)
}

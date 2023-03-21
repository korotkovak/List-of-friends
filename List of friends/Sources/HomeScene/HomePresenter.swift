//
//  HomePresenter.swift
//  List of friends
//
//  Created by Kristina Korotkova on 18/03/23.
//

import Foundation

protocol HomeViewPresenterProtocol {
    func fetchFriends()
    func addNewFriend(name: String)
    func getFreindsCount() -> Int
    func getFriend(_ index: Int) -> Friend?
    func deleteFriend(_ index: Int)
}

class HomePresenter: HomeViewPresenterProtocol {
    weak var view: HomeViewProtocol?

    init(view: HomeViewProtocol) {
        self.view = view
    }

    func fetchFriends() {
        CoreDataManager.shared.fetchFriends()
        view?.showFriends()
    }

    func addNewFriend(name: String) {
        CoreDataManager.shared.addNewFriend(name: name,
                                            gender: "Male",
                                            dateOfBirth: "01.01.1976")
        view?.showFriends()
    }

    func getFreindsCount() -> Int {
        CoreDataManager.shared.friends?.count ?? 0
    }

    func getFriend(_ index: Int) -> Friend? {
        CoreDataManager.shared.friends?[index]
    }

    func deleteFriend(_ index: Int) {
        CoreDataManager.shared.deleteFriend(index)
        view?.showFriends()
    }
}

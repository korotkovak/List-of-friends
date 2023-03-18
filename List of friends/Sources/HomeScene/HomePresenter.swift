//
//  HomePresenter.swift
//  List of friends
//
//  Created by Kristina Korotkova on 18/03/23.
//

import Foundation

protocol HomeViewPresenterProtocol {
    func addFriend(name: String)
    func fetchFriends()
    func getFreindsCount() -> Int
    func getFriend(_ index: Int) -> Friend?
    func deleteFriend(_ index: Int)
}

final class HomePresenter: HomeViewPresenterProtocol {
    weak var view: HomeViewProtocol?
    private var serviceCoreData: ServiceCoreData?

    init(view: HomeViewProtocol, serviceCoreData: ServiceCoreData) {
        self.view = view
        self.serviceCoreData = serviceCoreData
    }

    func addFriend(name: String) {
        serviceCoreData?.addFriend(name: name)
        view?.showFriends()
    }

    func fetchFriends() {
        serviceCoreData?.fetchFriends()
        view?.showFriends()
    }

    func getFreindsCount() -> Int {
        serviceCoreData?.getFriendsCount() ?? 0
    }

    func getFriend(_ index: Int) -> Friend? {
        serviceCoreData?.getFriend(index)
    }

    func deleteFriend(_ index: Int) {
        serviceCoreData?.deleteFriend(index)
        view?.showFriends()
    }
}

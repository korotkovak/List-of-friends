//
//  HomePresenter.swift
//  List of friends
//
//  Created by Kristina Korotkova on 18/03/23.
//

import Foundation

class HomePresenter: HomePresenterInput {
    
    private weak var view: HomePresenterOutput?
    private let dataManager: CoreDataProtocol?
    
    init(
        view: HomePresenterOutput,
        dataManager: CoreDataProtocol
    ) {
        self.view = view
        self.dataManager = dataManager
    }
    
    func fetchFriends() {
        dataManager?.fetchFriends()
        view?.showFriends()
    }
    
    func addNewFriend(name: String) {
        dataManager?.addNewFriend(
            name: name,
            gender: "Male",
            dateOfBirth: "01.01.1976")
        
        view?.showFriends()
    }
    
    func getFreindsCount() -> Int {
        dataManager?.friends?.count ?? 0
    }
    
    func getFriend(_ index: Int) -> Friend? {
        dataManager?.friends?[index]
    }
    
    func deleteFriend(_ index: Int) {
        dataManager?.deleteFriend(index)
        view?.showFriends()
    }
}

//
//  DetailPresenter.swift
//  List of friends
//
//  Created by Kristina Korotkova on 18/03/23.
//

import Foundation

protocol DetailViewPresenterProtocol {
    func setFriend()
    func updateFriend(avatar: Data,
                      name: String,
                      gender: String,
                      dateOfBirth: String)
}

final class DetailViewPresenter: DetailViewPresenterProtocol {
    weak var view: DetailViewProtocol?
    private var friend: Friend?

    init(view: DetailViewProtocol, friend: Friend) {
        self.view = view
        self.friend = friend
    }
    
    func setFriend() {
        view?.friend = friend
    }

    func updateFriend(avatar: Data,
                      name: String,
                      gender: String,
                      dateOfBirth: String) {
        friend?.avatar = avatar
        friend?.name = name
        friend?.gender = gender
        friend?.dateOfBirth = dateOfBirth
        CoreDataManager.shared.updateFriend()
    }
}

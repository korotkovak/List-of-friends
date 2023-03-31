//
//  DetailPresenter.swift
//  List of friends
//
//  Created by Kristina Korotkova on 18/03/23.
//

import Foundation

final class DetailPresenter: DetailPresenterInput {

    private weak var view: DetailPresenterOutput?
    private let dataManager: CoreDataProtocol?
    private var friend: Friend?

    init(
        view: DetailPresenterOutput,
        dataManager: CoreDataProtocol,
        friend: Friend
    ) {
        self.view = view
        self.dataManager = dataManager
        self.friend = friend
    }
    
    func setFriend() {
        view?.friend = friend
    }

    func updateFriend(
        avatar: Data,
        name: String,
        gender: String,
        dateOfBirth: String
    ) {
        friend?.avatar = avatar
        friend?.name = name
        friend?.gender = gender
        friend?.dateOfBirth = dateOfBirth
        dataManager?.updateFriend()
    }
}

//
//  DetailPresenter.swift
//  List of friends
//
//  Created by Kristina Korotkova on 18/03/23.
//

import Foundation

protocol DetailViewPresenterProtocol {
    func updateFriend()
    
}

final class DetailViewPresenter: DetailViewPresenterProtocol {
    weak var view: DetailViewProtocol?
    private var serviceCoreData: ServiceCoreData?
    private var friend: Friend?

    init(view: DetailViewProtocol, serviceCoreData: ServiceCoreData, friend: Friend) {
        self.view = view
        self.serviceCoreData = serviceCoreData
        self.friend = friend
    }

    func updateFriend() {
        serviceCoreData?.updateFriend()
    }


}

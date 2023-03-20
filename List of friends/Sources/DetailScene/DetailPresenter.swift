//
//  DetailPresenter.swift
//  List of friends
//
//  Created by Kristina Korotkova on 18/03/23.
//

import Foundation

protocol DetailViewPresenterProtocol {
    init(view: DetailViewProtocol, serviceCoreData: ServiceCoreData, friend: Friend)
    func setFriend()
    var friend: Friend? { get set }
//    func updateFriend()
    func updateFriend(friend: Friend, name: String, date: String, gender: String)
}

final class DetailViewPresenter: DetailViewPresenterProtocol {
    weak var view: DetailViewProtocol?
    private var serviceCoreData: ServiceCoreData?
     var friend: Friend?

    init(view: DetailViewProtocol, serviceCoreData: ServiceCoreData, friend: Friend) {
        self.view = view
        self.serviceCoreData = serviceCoreData
        self.friend = friend
    }

    func setFriend() {
        // добавляю моего пользователя на которого нажала на ячейке и передают данные
        view?.fillSettings(with: friend)
        CoreDataManager.shared.saveContext()
        serviceCoreData?.fetchFriends()

    }

//    func updateFriend() {
//        view?.updateFriend(for: friend)
//        serviceCoreData?.updateFriend()
//    }

    func updateFriend(friend: Friend, name: String, date: String, gender: String) {
        // когда я нажала на кнопку сохранить, я передаю данные из текст филдом обратно в моего пользовалея
        // тут уже актуальные данные
//        friend?.name = name
//        friend?.date = date
//        friend?.gender = gender
//        guard let friend = friend else { return }
        // дальше я передаю эти данные и моего пользователя в кор дату
        serviceCoreData?.updateFriend(friend: friend,
                                      name: name,
                                      date: date,
                                      gender: gender)
    }
}

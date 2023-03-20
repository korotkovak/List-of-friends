//
//  ModuleBuilder.swift
//  List of friends
//
//  Created by Kristina Korotkova on 20/03/23.
//

import UIKit

protocol BuilderProtocol {
    static func createHomeModule() -> UIViewController
    static func createDetailModule(with model: Friend) -> UIViewController
}

class ModuleBuilder: BuilderProtocol {
    static func createHomeModule() -> UIViewController {
        let view = HomeViewController()
        let serviceCoreData = CoreDataManager()
        let presenter = HomePresenter(view: view,
                                      serviceCoreData: serviceCoreData)
        view.presenter = presenter
        return view
    }

    static func createDetailModule(with model: Friend) -> UIViewController {
        let view = DetailViewController()
        let serviceCoreData = CoreDataManager()
        let presenter = DetailViewPresenter(view: view,
                                            serviceCoreData: serviceCoreData,
                                            friend: model)
        view.presenter = presenter
        return view
    }
}

//
//  ModuleBuilder.swift
//  List of friends
//
//  Created by Kristina Korotkova on 20/03/23.
//

import UIKit

class ModuleBuilder: BuilderProtocol {

    static var shared: ModuleBuilder = {
        ModuleBuilder()
    }()

    private lazy var dataManager: CoreDataManager = {
        CoreDataManager()
    }()

    lazy var homeModule: UIViewController = {
        let view = HomeViewController()
        let presenter = HomePresenter(
            view: view,
            dataManager: dataManager
        )

        view.presenter = presenter
        return view
    }()

    func createDetailModule(with model: Friend) -> UIViewController {
        let view = DetailViewController()
        let presenter = DetailPresenter(
            view: view,
            dataManager: dataManager,
            friend: model
        )

        view.presenter = presenter
        return view
    }
}

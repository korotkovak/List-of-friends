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
        let presenter = HomePresenter(view: view)
        view.presenter = presenter
        return view
    }

    static func createDetailModule(with model: Friend) -> UIViewController {
        let view = DetailViewController()
        let presenter = DetailViewPresenter(view: view, friend: model)
        view.presenter = presenter
        return view
    }
}

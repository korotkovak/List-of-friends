//
//  BuilderProtocol.swift
//  List of friends
//
//  Created by Kristina Korotkova on 31/03/23.
//

import UIKit

protocol BuilderProtocol {
    var homeModule: UIViewController { get set }
    func createDetailModule(with model: Friend) -> UIViewController
}

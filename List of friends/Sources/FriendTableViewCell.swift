//
//  FriendTableViewCell.swift
//  List of friends
//
//  Created by Kristina Korotkova on 17/03/23.
//

import UIKit

final class FriendTableViewCell: UITableViewCell {

    static let identifier = "FriendTableViewCell"

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: FriendTableViewCell.identifier)
        accessoryType = .disclosureIndicator
    }

    required init?(coder: NSCoder) {
        fatalError("Strings.fatalError")
    }
}

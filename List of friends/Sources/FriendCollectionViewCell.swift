//
//  FriendTableViewCell.swift
//  List of friends
//
//  Created by Kristina Korotkova on 17/03/23.
//

import UIKit

final class FriendCollectionViewCell: UICollectionViewCell {

    static let identifier = "FriendCollectionViewCell"

    // MARK: - Outlets

    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.isUserInteractionEnabled = false
        return textField
    }()

    private lazy var backgroung: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor().hexStringToUIColor(hex: "F8F8F8")
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHeirarchy()
        setupIcons()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("Strings.fatalError")
    }

    // MARK: - Setup

    private func setupHeirarchy() {
        contentView.addSubview(backgroung)
        contentView.addSubview(textField)
    }

    private func setupLayout() {
        backgroung.snp.makeConstraints { make in
            make.left.right.height.equalTo(self)
        }

        textField.snp.makeConstraints { make in
            make.right.height.equalTo(self)
            make.left.equalTo(backgroung.snp.left).offset(20)
        }
    }

    private func setupIcons() {
        if let image = UIImage(named: "arrow-right") {
            textField.setRightIcon(image)
        }
    }

}

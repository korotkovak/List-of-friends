//
//  ViewController.swift
//  List of friends
//
//  Created by Kristina Korotkova on 17/03/23.
//

import UIKit
import CoreData

final class HomeViewController: UIViewController {

    var fetchedResultsController = CoreDataManager.shared.fetchedResultsController(
        entityName: "Friend",
        keyForSort: "name"
    )

    // MARK: - Outlets

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.register(FriendCollectionViewCell.self,
                                forCellWithReuseIdentifier: FriendCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Write your friend's name here"
        textField.layer.cornerRadius = 10
        textField.backgroundColor = UIColor().hexStringToUIColor(hex: "F8F8F8")
        textField.returnKeyType = .done
        return textField
    }()

    private lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor().hexStringToUIColor(hex: "FF575C")
        button.layer.cornerRadius = 26
        button.layer.masksToBounds = true
        button.setTitle("Add a friend", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHeirarchy()
        setupKeyboard()
        setupIcons()
        setupLayout()

        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
    }

    // MARK: - Setup

    private func setupView() {
        view.backgroundColor = .white
        title = "List of friends"
    }

    private func setupHeirarchy() {
        view.addSubview(collectionView)
        view.addSubview(textField)
        view.addSubview(button)
    }

    private func setupLayout() {
        textField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.centerX.equalTo(view)
            make.left.equalTo(view).offset(20)
            make.height.equalTo(50)
        }

        button.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(20)
            make.centerX.equalTo(view)
            make.left.equalTo(view).offset(20)
            make.height.equalTo(55)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(button.snp.bottom).offset(30)
            make.right.bottom.left.equalTo(view)
        }
    }

    private func setupIcons() {
        if let image = UIImage(named: "user_gray") {
            textField.setLeftIcon(image)
        }
    }
}

// MARK: - UITableViewDataSource

extension HomeViewController: UICollectionViewDataSource,
                              UICollectionViewDelegateFlowLayout,
                              UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        3
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = collectionView.dequeueReusableCell(
            withReuseIdentifier: FriendCollectionViewCell.identifier,
            for: indexPath
        ) as? FriendCollectionViewCell else {
            return UICollectionViewCell()
        }

        item.textField.text = "Korotkova Kristina"
        return item
    }

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        let detailViewController = DetailViewController()

        navigationController?.pushViewController(detailViewController,
                                                 animated: true)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (view.frame.size.width / 1) - 40, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

// MARK: - UITextFieldDelegate

extension HomeViewController: UITextFieldDelegate {

    private func setupKeyboard() {
        textField.delegate = self
        self.hideKeyboardWhenTappedAround()
    }

    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }

    private func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

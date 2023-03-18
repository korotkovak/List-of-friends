//
//  ViewController.swift
//  List of friends
//
//  Created by Kristina Korotkova on 17/03/23.
//

import UIKit
import CoreData

final class HomeViewController: UIViewController {

    // MARK: - Outlets

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(FriendTableViewCell.self,
                           forCellReuseIdentifier: FriendTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

//    private lazy var collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        let collectionView = UICollectionView(frame: .zero,
//                                              collectionViewLayout: layout)
//        collectionView.register(FriendTableViewCell.self,
//                                forCellWithReuseIdentifier: FriendTableViewCell.identifier)
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        return collectionView
//    }()

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
        button.setTitle("Add a friend", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.addTarget(self, action: #selector(addFriendInTable), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHeirarchy()
        fetchFriends()
        setupKeyboard()
        setupIcons()

        setupLayout()
    }

    func fetchFriends() {
        do {
            CoreDataManager.shared.friends = try CoreDataManager.shared.context.fetch(Friend.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print(error)
        }
    }

    @objc private func addFriendInTable() {
        if let text = textField.text {
            let newFriend = Friend(context: CoreDataManager.shared.context)
            newFriend.name = text
            newFriend.gender = "Male"
            newFriend.date = "01.01.2023"

            do {
                try CoreDataManager.shared.context.save()
            } catch {
                print(error)
            }

            textField.text = ""
            fetchFriends()
        }
    }

    // MARK: - Setup

    private func setupView() {
        view.backgroundColor = .white
        title = "List of friends"
    }

    private func setupHeirarchy() {
        view.addSubview(tableView)
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

        tableView.snp.makeConstraints { make in
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

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoreDataManager.shared.friends?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: FriendTableViewCell.identifier,
            for: indexPath
        ) as? FriendTableViewCell else {
            return UITableViewCell()
        }

        let friend = CoreDataManager.shared.friends?[indexPath.row]
        cell.textLabel?.text = friend?.name
        return cell
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()

            if let friend = CoreDataManager.shared.friends?[indexPath.row] {
                CoreDataManager.shared.context.delete(friend)
                tableView.deleteRows(at: [indexPath], with: .fade)

                do {
                    try CoreDataManager.shared.context.save()
                } catch {
                    print(error)
                }

                fetchFriends()

            }
            tableView.endUpdates()
        }
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let detailViewController = DetailViewController()
        let friend = CoreDataManager.shared.friends?[indexPath.row]

        detailViewController.fillSettings(with: friend)

        navigationController?.pushViewController(detailViewController,
                                                 animated: true)

//        friend?.name = detailViewController.nameTextField.text
//
//        do {
//            try CoreDataManager.shared.context.save()
//
//        } catch {
//            print(error)
//        }
//
//        fetchFriends()



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

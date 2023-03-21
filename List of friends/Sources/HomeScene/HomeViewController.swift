//
//  ViewController.swift
//  List of friends
//
//  Created by Kristina Korotkova on 17/03/23.
//

import UIKit

protocol HomeViewProtocol: AnyObject {
    func showFriends()
}

final class HomeViewController: UIViewController, HomeViewProtocol {

    var presenter: HomeViewPresenterProtocol?

    // MARK: - Outlets

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(FriendTableViewCell.self,
                           forCellReuseIdentifier: FriendTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
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
        button.setTitle("Add a friend", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.addTarget(self, action: #selector(addFriendInTable), for: .touchUpInside)
        return button
    }()

    // MARK: - Init

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showFriends()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHeirarchy()
        setupKeyboard()
        setupIcons()
        setupLayout()
        presenter?.fetchFriends()
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

    // MARK: - Methods

    func showFriends() {
        tableView.reloadData()
    }

    @objc private func addFriendInTable() {
        guard let name = textField.text else { return }
        presenter?.addNewFriend(name: name)
        textField.text = ""
    }
}

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getFreindsCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: FriendTableViewCell.identifier,
            for: indexPath
        ) as? FriendTableViewCell else {
            return UITableViewCell()
        }
        let friend = presenter?.getFriend(indexPath.row)
        cell.textLabel?.text = friend?.name
        return cell
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter?.deleteFriend(indexPath.row)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let friend = presenter?.getFriend(indexPath.row) else { return }
        let detailViewController = ModuleBuilder.createDetailModule(with: friend)
        navigationController?.pushViewController(detailViewController,
                                                 animated: true)
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

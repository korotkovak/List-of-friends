//
//  ViewController.swift
//  List of friends
//
//  Created by Kristina Korotkova on 17/03/23.
//

import UIKit

final class HomeViewController: UIViewController, HomePresenterOutput {
    
    var presenter: HomePresenterInput?
    
    // MARK: - Outlets
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(
            FriendTableViewCell.self,
            forCellReuseIdentifier: FriendTableViewCell.identifier
        )
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Constants.textFieldPlaceholder
        textField.layer.cornerRadius = 10
        textField.backgroundColor = Colors.gray
        textField.returnKeyType = .done
        return textField
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = Colors.red
        button.layer.cornerRadius = 26
        button.setTitle(Constants.buttonSetTitle, for: .normal)
        button.setTitleColor(Colors.white, for: .normal)
        button.titleLabel?.font = Fonts.boldOfSize18
        button.addTarget(
            self,
            action: #selector(addFriendInTable),
            for: .touchUpInside
        )
        return button
    }()
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(
            UIAlertAction(
                title: Constants.alertActionTitle,
                style: .cancel
            )
        )
        
        self.present(alert, animated: true)
    }
    
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
        view.backgroundColor = Colors.white
        title = Constants.title
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
        guard let imageTextField = Images.textFieldLeftIcon
        else { return }
        textField.setLeftIcon(imageTextField)
    }
    
    // MARK: - Methods
    
    func showFriends() {
        tableView.reloadData()
    }
    
    @objc private func addFriendInTable() {
        guard let name = textField.text, !name.isEmpty
        else {
            return showAlert(
                title: Constants.showAlertTitle,
                message: Constants.showAlertMessage
            )
        }
        
        presenter?.addNewFriend(name: name)
        textField.text = ""
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        
        return presenter?.getFreindsCount() ?? 0
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

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
    
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        
        guard editingStyle == .delete else { return }
        presenter?.deleteFriend(indexPath.row)
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        guard let friend = presenter?.getFriend(indexPath.row) else { return }
        
        let detailViewController = ModuleBuilder.shared.createDetailModule(with: friend)
        navigationController?.pushViewController(detailViewController, animated: true)
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
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Constants

fileprivate enum Constants {
    static let textFieldPlaceholder = "Write your friend's name here"
    static let buttonSetTitle = "Add a friend"
    static let alertActionTitle = "Ok!"
    static let title = "List of friends"
    static let showAlertTitle = "The field is empty"
    static let showAlertMessage = "Enter your friend's name"
}

fileprivate enum Images {
    static let textFieldLeftIcon = UIImage(named: "user_gray")
}

//
//  DetailViewController.swift
//  List of friends
//
//  Created by Kristina Korotkova on 17/03/23.
//

import UIKit

final class DetailViewController: UIViewController, DetailPresenterOutput {
    
    var presenter: DetailPresenterInput?
    
    var friend: Friend? {
        didSet {
            nameTextField.text = friend?.name
            genderMenuTextField.text = friend?.gender
            dateTextField.text = friend?.dateOfBirth

            guard let date = friend?.dateOfBirth else { return }
            datePicker.date = String().convertStringToDate(string: date)

            guard let image = friend?.avatar else { return }
            avatar.image = UIImage(data: image)
        }
    }
    
    private var isEditingButton = false {
        willSet {
            isEditingButton ? editButton() : saveButton()
        }
    }
    
    private enum GenderType: String {
        case male = "Male"
        case female = "Female"
        case other = "Other"
    }
    
    // MARK: - Outlets
    
    private lazy var avatar: UIImageView = {
        var image = UIImageView()
        image.layer.cornerRadius = 200 / 2
        image.clipsToBounds = true
        image.image = Images.avatar
        return image
    }()
    
    private lazy var imagePickerController: UIImagePickerController = {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        return vc
    }()
    
    private lazy var editIcon: UIImageView = {
        var image = UIImageView()
        image.clipsToBounds = true
        image.image = Images.editIcon
        return image
    }()
    
    private lazy var photoEditingButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Colors.clear
        button.isHidden = true
        button.addTarget(
            self,
            action: #selector(photoEditingButtonPressed),
            for: .touchUpInside
        )
        return button
    }()
    
    private lazy var containerForAvatar: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.addSubview(avatar)
        view.addSubview(editIcon)
        return view
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.isUserInteractionEnabled = false
        textField.layer.cornerRadius = 10
        textField.backgroundColor = Colors.gray
        return textField
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.isHidden = true
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        return datePicker
    }()
    
    private lazy var dateTextField: UITextField = {
        let textField = UITextField()
        textField.isUserInteractionEnabled = false
        textField.layer.cornerRadius = 10
        textField.backgroundColor = Colors.gray
        return textField
    }()
    
    private lazy var genderTextField: UITextField = {
        let textField = UITextField()
        textField.isUserInteractionEnabled = false
        textField.text = Constants.genderTextFieldText
        textField.layer.cornerRadius = 10
        textField.backgroundColor = Colors.gray
        return textField
    }()
    
    private lazy var editAndSaveButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = Fonts.boldOfSize14
        button.layer.cornerRadius = 10
        button.addTarget(
            self,
            action: #selector(editAndSaveButtonPressed),
            for: .touchUpInside
        )
        return button
    }()
    
    private lazy var menu: UIMenu = {
        let male = UIAction(title: GenderType.male.rawValue) { [weak self]
            action in
            self?.genderMenuTextField.text = action.title
        }
        let female = UIAction(title: GenderType.female.rawValue) { [weak self]
            action in
            self?.genderMenuTextField.text = action.title
        }
        let other = UIAction(title: GenderType.other.rawValue) { [weak self]
            action in
            self?.genderMenuTextField.text = action.title
        }
        
        let elements: [UIAction] = [male, female, other]
        let menu = UIMenu(children: elements)
        return menu
    }()
    
    private lazy var genderMenuTextField: UITextField = {
        let textField = UITextField()
        textField.isUserInteractionEnabled = false
        textField.text = Constants.genderMenuTextFieldText
        textField.font = Fonts.regularOfSize16
        textField.textColor = Colors.black
        return textField
    }()
    
    private lazy var genderButton: UIButton = {
        let button = UIButton()
        button.isUserInteractionEnabled = false
        button.showsMenuAsPrimaryAction = true
        button.backgroundColor = Colors.clear
        button.menu = menu
        return button
    }()
    
    private lazy var genderImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.genderImage
        imageView.clipsToBounds = true
        imageView.isHidden = true
        imageView.tintColor = Colors.red
        return imageView
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .equalSpacing
        stack.addArrangedSubview(genderMenuTextField)
        stack.addArrangedSubview(genderImage)
        return stack
    }()
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(
            title: Constants.alertActionTitle,
            style: .cancel))
        self.present(alert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        editButton()
        setupIcons()
        setupHeirarchy()
        setupKeyboard()
        setupLayout()
        presenter?.setFriend()
    }
    
    // MARK: - Setup
    
    private func setupView() {
        view.backgroundColor = .white
        title = Constants.title
    }
    
    private func setupNavigationBar() {
        let leftBarButtonItem = UIBarButtonItem(
            image: Images.backArrow,
            style: .done,
            target: self,
            action: #selector(actionForBackButton)
        )
        
        let rightBarButtonItem = UIBarButtonItem(customView: editAndSaveButton)
        
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationController?.navigationBar.tintColor = Colors.red
    }
    
    private func setupHeirarchy() {
        view.addSubview(containerForAvatar)
        view.addSubview(nameTextField)
        view.addSubview(dateTextField)
        view.addSubview(genderTextField)
        view.addSubview(datePicker)
        view.addSubview(stack)
        view.addSubview(genderButton)
        view.addSubview(photoEditingButton)
    }
    
    private func setupLayout() {
        containerForAvatar.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.height.width.equalTo(200)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
        }
        
        avatar.snp.makeConstraints { make in
            make.center.equalTo(containerForAvatar.snp.center)
            make.height.width.equalTo(200)
        }
        
        editIcon.snp.makeConstraints { make in
            make.right.bottom.equalTo(containerForAvatar).offset(-10)
            make.height.width.equalTo(40)
        }
        
        photoEditingButton.snp.makeConstraints { make in
            make.right.bottom.equalTo(containerForAvatar).offset(-10)
            make.height.width.equalTo(40)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.height.equalTo(50)
            make.top.equalTo(avatar.snp.bottom).offset(40)
        }
        
        dateTextField.snp.makeConstraints { make in
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.height.equalTo(50)
            make.top.equalTo(nameTextField.snp.bottom).offset(20)
        }
        
        datePicker.snp.makeConstraints { make in
            make.right.equalTo(dateTextField.snp.right).offset(-20)
            make.centerY.equalTo(dateTextField.snp.centerY)
            make.height.equalTo(50)
        }
        
        genderTextField.snp.makeConstraints { make in
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.height.equalTo(50)
            make.top.equalTo(dateTextField.snp.bottom).offset(20)
        }
        
        genderImage.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        
        stack.snp.makeConstraints { make in
            make.right.equalTo(genderTextField.snp.right).offset(-20)
            make.centerY.equalTo(genderTextField.snp.centerY)
        }
        
        genderButton.snp.makeConstraints { make in
            make.right.equalTo(genderTextField.snp.right)
            make.centerY.equalTo(genderTextField.snp.centerY)
            make.height.equalTo(50)
            make.width.equalTo(100)
        }
        
        editAndSaveButton.snp.makeConstraints { make in
            make.height.equalTo(38)
            make.width.equalTo(86)
        }
    }
    
    private func setupIcons() {
        guard let imageNameTextField = Images.nameTextFieldLeftIcon
        else { return }
        nameTextField.setLeftIcon(imageNameTextField)

        guard let imageDateTextField = Images.dateTextFieldLeftIcon
        else { return }
        dateTextField.setLeftIcon(imageDateTextField)

        guard let imageGenderTextField = Images.genderTextFieldLeftIcon
        else { return }
        genderTextField.setLeftIcon(imageGenderTextField)
    }
    
    // MARK: - Methods
    
    private func saveButton() {
        editAndSaveButton.setTitle(Constants.saveButtonSetTitle, for: .normal)
        editAndSaveButton.setTitleColor(Colors.white, for: .normal)
        editAndSaveButton.backgroundColor = Colors.red
        editAndSaveButton.layer.borderWidth = 0
    }
    
    private func editButton() {
        editAndSaveButton.setTitle(Constants.editButtonSetTitle, for: .normal)
        editAndSaveButton.setTitleColor(Colors.black, for: .normal)
        editAndSaveButton.layer.borderWidth = 1
        editAndSaveButton.layer.borderColor = Colors.black.cgColor
        editAndSaveButton.backgroundColor = Colors.white
    }
    
    private func configurationToSave() {
        dateTextField.text = String().convertDateToString(date: datePicker.date)
        nameTextField.isUserInteractionEnabled = false
        datePicker.isHidden = true
        genderButton.isUserInteractionEnabled = false
        genderImage.isHidden = true
        photoEditingButton.isHidden = true
        editIcon.image = Images.editIconNoActiv
        isEditingButton = false
    }
    
    private func configurationToEdit() {
        nameTextField.isUserInteractionEnabled = true
        datePicker.isHidden = false
        genderImage.isHidden = false
        genderButton.isUserInteractionEnabled = true
        editIcon.image = Images.editIconActiv
        photoEditingButton.isHidden = false
        isEditingButton = true
    }
    
    func updateFriendInformation() {
        guard let avatar = avatar.image?.pngData(),
              let name = nameTextField.text, !name.isEmpty,
              let gender = genderMenuTextField.text,
              let dateOfBirth = dateTextField.text
        else { return }
        
        presenter?.updateFriend(
            avatar: avatar,
            name: name,
            gender: gender,
            dateOfBirth: dateOfBirth
        )
    }
    
    @objc private func editAndSaveButtonPressed() {
        guard let name = nameTextField.text, !name.isEmpty
        else {
            return showAlert(
                title: Constants.alertActionTitle,
                message: Constants.showAlertMessage
            )
        }
        
        guard isEditingButton else {
            return configurationToEdit()
        }
        
        configurationToSave()
        updateFriendInformation()
    }
    
    @objc private func actionForBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func photoEditingButtonPressed() {
        present(imagePickerController, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension DetailViewController: UIImagePickerControllerDelegate,
                                UINavigationControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        let infoKey = UIImagePickerController.InfoKey(
            rawValue: Constants.imagePickerControllerInfoKey)

        guard let image = info[infoKey] as? UIImage else { return }

        avatar.image = image
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension DetailViewController: UITextFieldDelegate {
    
    private func setupKeyboard() {
        nameTextField.delegate = self
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
    static let genderTextFieldText = "Gender"
    static let genderMenuTextFieldText = "Other"
    static let title = "Editing a user"
    static let saveButtonSetTitle = "Save"
    static let editButtonSetTitle = "Edit"
    static let alertActionTitle = "Ok!"
    static let showAlertTitle = "Changes not saved"
    static let showAlertMessage = "Enter your friend's name"
    static let imagePickerControllerInfoKey = "UIImagePickerControllerEditedImage"
}

fileprivate enum Images {
    static let avatar = UIImage(named: "user_noactiv")
    static let editIcon = UIImage(named: "edit-circle-noactiv")
    static let genderImage = UIImage(systemName: "chevron.up.chevron.down")
    static let backArrow = UIImage(named: "back-arrow")
    static let nameTextFieldLeftIcon = UIImage(named: "user")
    static let dateTextFieldLeftIcon = UIImage(named: "calendar")
    static let genderTextFieldLeftIcon = UIImage(named: "gender")
    static let editIconNoActiv = UIImage(named: "edit-circle-noactiv")
    static let editIconActiv = UIImage(named: "edit-circle")
}

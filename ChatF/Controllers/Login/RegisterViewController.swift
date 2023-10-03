//
//  RegisterViewController.swift
//  ChatF
//
//  Created by Kadir Hocaoğlu on 1.10.2023.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    // MARK: - UI Elements
    private let ScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    private let profilePicImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle")
        imageView.tintColor = .gray
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }()
    private let firstNameTextField: UITextField = {
        let textField =  UITextField()
        textField.autocapitalizationType = .sentences
        textField.autocorrectionType = .no
        textField.returnKeyType = .continue
        textField.layer.cornerRadius = 12
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.setLeftPaddingPoints(5)
        textField.placeholder = "First Name..."
        return textField
    }()
    private let lastNameTextField: UITextField = {
        let textField =  UITextField()
        textField.autocapitalizationType = .sentences
        textField.autocorrectionType = .no
        textField.returnKeyType = .continue
        textField.layer.cornerRadius = 12
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.setLeftPaddingPoints(5)
        textField.placeholder = "Last Name..."
        return textField
    }()
    private let emailTextField: UITextField = {
        let textField =  UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .continue
        textField.layer.cornerRadius = 12
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.setLeftPaddingPoints(5)
        textField.placeholder = "Email Address..."
        textField.keyboardType = .emailAddress
        return textField
    }()
    private let passwordTextField: UITextField = {
        let textField =  UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        textField.layer.cornerRadius = 12
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.setLeftPaddingPoints(5)
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        return textField
    }()
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .green
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    
    // MARK: - Properties
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        //MARK: - Delegate
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        //MARK: - AddAction
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        //MARK: - AddSubview
        view.addSubview(ScrollView)
        ScrollView.addSubview(profilePicImageView)
        ScrollView.addSubview(firstNameTextField)
        ScrollView.addSubview(lastNameTextField)
        ScrollView.addSubview(emailTextField)
        ScrollView.addSubview(passwordTextField)
        ScrollView.addSubview(registerButton)
        profilePicImageView.isUserInteractionEnabled = true
        ScrollView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfilePic))
        //gesture.numberOfTouchesRequired =
        profilePicImageView.addGestureRecognizer(gesture)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        ScrollView.frame = view.bounds
        let size = ScrollView.width/3
        profilePicImageView.frame = CGRect(x: (ScrollView.width - size)/2, y: 30, width: size, height: size)
        profilePicImageView.layer.cornerRadius = profilePicImageView.width/2.0
        firstNameTextField.frame = CGRect(x: 30, y: profilePicImageView.bottom + 10, width: ScrollView.width - 60, height: size/3)
        lastNameTextField.frame = CGRect(x: 30, y: firstNameTextField.bottom + 10, width: ScrollView.width - 60, height: size/3)
        emailTextField.frame = CGRect(x: 30, y: lastNameTextField.bottom + 10, width: ScrollView.width - 60, height: size/3)
        passwordTextField.frame = CGRect(x: 30, y: emailTextField.bottom + 10, width: ScrollView.width - 60, height: size/3)
        registerButton.frame = CGRect(x: 30, y: passwordTextField.bottom + 10, width: ScrollView.width - 60, height: size/3)
        
    }
    
    // MARK: - Functions
    @objc private func didTapChangeProfilePic() {
        presentPhotoActionSheet()
    }
    @objc private func registerButtonTapped() {
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        guard let firstName = firstNameTextField.text,
              let lastName = lastNameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text,
              !email.isEmpty,
              !password.isEmpty,
              !firstName.isEmpty,
              !lastName.isEmpty,
              password.count >= 6 else {
            alertUserRegisterError()
            return
        }
        //MARK: - Firebase Register
        DatabaseManager.shared.userExists(with: email, completion: { [weak self] exits in
            guard let strongSelf = self else { return }
            guard !exits else {
                // user alredy exits
                strongSelf.alertUserRegisterError(message: "Looks like a user account for that email address already exists")
                return
            }
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion:  { authResult, error in
                guard authResult != nil , error == nil else {
                    print("Error creating user")
                    return
                }
                DatabaseManager.shared.insertUser(with: ChatFUser(firstName: firstName, lastName: lastName, emailAddress: email))
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
                
            })
        })
    }
    private func alertUserRegisterError(message: String = "Please enter all information to register.") {
        let alert = UIAlertController(title: "Woops", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        present(alert, animated: true)
    }
    // MARK: - Actions
    
    
    
}
extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        switch textField {
        case firstNameTextField:
            lastNameTextField.becomeFirstResponder()
        case lastNameTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            registerButtonTapped()
        default:
            break
        }
        return true
    }
    
}
extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture", message: "How would you like to select a picture?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoPicker()
        }))
        present(actionSheet, animated: true)
        
    }
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        print(info)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        
        self.profilePicImageView.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

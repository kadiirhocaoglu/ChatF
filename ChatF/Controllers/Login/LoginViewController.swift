//
//  LoginViewController.swift
//  ChatF
//
//  Created by Kadir Hocaoğlu on 1.10.2023.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    // MARK: - UI Elements
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "message.circle")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let ScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    private let emailTextField: UITextField = {
        let textField =  UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .continue
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.setLeftPaddingPoints(5)
        textField.placeholder = "Email Address..."
        textField.keyboardType = .emailAddress
        textField.backgroundColor = .systemBackground
        return textField
    }()
    private let passwordTextField: UITextField = {
        let textField =  UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.setLeftPaddingPoints(5)
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.backgroundColor = .systemBackground
        return textField
    }()
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
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
        title = "Log In"
        //MARK: - AddAction
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapRegister))
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        //MARK: - Delegate
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        //MARK: - AddSubview
        view.addSubview(ScrollView)
        ScrollView.addSubview(logoImageView)
        ScrollView.addSubview(emailTextField)
        ScrollView.addSubview(passwordTextField)
        ScrollView.addSubview(loginButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        ScrollView.frame = view.bounds
        let size = ScrollView.width/3
        logoImageView.frame = CGRect(x: (ScrollView.width - size)/2, y: 20
                                     , width: size, height: size)
        emailTextField.frame = CGRect(x: 30 , y: logoImageView.bottom + 10
                                      , width: size*3-60, height: size / 3)
        passwordTextField.frame = CGRect(x: 30 , y: emailTextField.bottom + 10
                                         , width: size*3-60, height: size / 3)
        loginButton.frame = CGRect(x: 30 , y: passwordTextField.bottom + 10
                                         , width: size*3-60, height: size / 3)

    }
    // MARK: - Functions
    @objc private func loginButtonTapped() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              !email.isEmpty,
              !password.isEmpty,
              password.count >= 6 else {
            alertUserLoginError()
            return
        }
        //MARK: - Firebase Login
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            guard let result = authResult, error == nil else {
                return
            }
            let user = result.user
            print(user)
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    func alertUserLoginError() {
        let alert = UIAlertController(title: "Woops", message: "Please enter all information to log in.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    @objc private func didTapRegister() {
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            loginButtonTapped()
        }
        return true
    }
}

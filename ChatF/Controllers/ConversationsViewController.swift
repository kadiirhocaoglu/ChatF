//
//  ConversationsViewController.swift
//  ChatF
//
//  Created by Kadir Hocaoğlu on 1.10.2023.
//

import UIKit
import FirebaseAuth
class ConversationsViewController: UIViewController {
    private let leaveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Leave", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        view.addSubview(leaveButton)
        
        //MARK: - Add Action
        leaveButton.addTarget(self, action: #selector(leaveButtonTapped), for: .touchUpInside)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        leaveButton.frame = CGRect(x: 30 , y: 300
                                   , width: view.width-60, height: view.width / 9)
    }
    private func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
        }
    }
    @objc private func leaveButtonTapped(){
        do {
            try FirebaseAuth.Auth.auth().signOut()
            validateAuth()
        } catch {
            print("Unsucccess")
        }
    
    }

}


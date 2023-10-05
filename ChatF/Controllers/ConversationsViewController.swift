//
//  ConversationsViewController.swift
//  ChatF
//
//  Created by Kadir Hocaoğlu on 1.10.2023.
//

import UIKit
import FirebaseAuth
class ConversationsViewController: UIViewController {
    private let newConversationsBarButtonItem: UIBarButtonItem = {
        let tabbarItem = UIBarButtonItem(barButtonSystemItem: .compose, target: nil, action: #selector(didTapComposeButton))
        tabbarItem.tintColor = .link
        return tabbarItem
    }()
    private let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chats"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.backgroundColor = .systemBackground
        configureNavBar()
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    @objc private func didTapComposeButton(){
        
    }
    private func configureNavBar() {
        navigationController?.navigationItem.rightBarButtonItem = newConversationsBarButtonItem
    }
    private func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
        }
    }
    

}


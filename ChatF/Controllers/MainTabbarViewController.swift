//
//  MainTabbarViewController.swift
//  ChatF
//
//  Created by Kadir Hocaoğlu on 4.10.2023.
//

import UIKit

class MainTabbarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        let vc1 = UINavigationController(rootViewController: ConversationsViewController())
        let vc2 = UINavigationController(rootViewController: ProfileViewController())


        
        vc1.tabBarItem.image = UIImage(systemName: "ellipsis.message")
        vc2.tabBarItem.image = UIImage(systemName: "person.crop.circle.fill")
        
        vc1.title = "Chats"
        vc2.title = "Profile"
        
        tabBar.tintColor = .label
        setViewControllers([vc1, vc2], animated: true)

    }

}

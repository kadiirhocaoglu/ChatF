//
//  DatabaseManager.swift
//  ChatF
//
//  Created by Kadir Hocaoğlu on 2.10.2023.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    static let shared = DatabaseManager()
    private init(){}
    
    private let database = Database.database().reference()
}
//MARK: - Account Managment
extension DatabaseManager {
    public func userExists(with email: String, completion: @escaping ((Bool) -> Void)) {
        var safeEmail: String = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value) { snapshot in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            completion(true)
            
        }
    }
    
    public func insertUser(with user: ChatFUser) {
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName
        ])
    }

}
struct ChatFUser {
    let firstName: String
    let lastName: String
    let emailAddress: String
    
    var safeEmail: String {
        var safeEmail: String = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    // let profilePicture: URL
}

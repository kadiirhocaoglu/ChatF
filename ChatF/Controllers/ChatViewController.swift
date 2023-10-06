//
//  ChatViewController.swift
//  ChatF
//
//  Created by Kadir Hocaoğlu on 5.10.2023.
//

import UIKit
import MessageKit

struct Message: MessageType {
    var sender: MessageKit.SenderType
    
    var messageId: String
    
    var sentDate: Date
    
    var kind: MessageKit.MessageKind
    
}
struct Sender: SenderType {
    var photoURL: String
    
    var senderId: String
    
    var displayName: String
    
}

class ChatViewController: MessagesViewController {
    
    private var messages = [Message]()
    private let selfSender = Sender(photoURL: "", senderId: "1", displayName: "Emin Durmus")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messages.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("Merhaba ben kadir ")))
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
    }
}
extension ChatViewController: MessagesDataSource, MessagesDisplayDelegate, MessagesLayoutDelegate {
    var currentSender: MessageKit.SenderType {
        return selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        return messages[indexPath.section ]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        messages.count
    }
    
     
}

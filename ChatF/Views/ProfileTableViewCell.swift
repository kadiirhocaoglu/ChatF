//
//  ProfileTableViewCell.swift
//  ChatF
//
//  Created by Kadir Hocaoğlu on 4.10.2023.
// created by Kadriye hocakızı

import UIKit

class ProfileTableViewCell: UITableViewCell {


    static let identifier = "ProfileTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

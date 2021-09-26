//
//  CustomTableViewCell.swift
//  ShoppingList
//
//  Created by Andrey Sushkov on 14.09.21.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var greenMark: UIImageView!
    
    @IBAction func cartButtonTapped(_ sender: Any) {
        if greenMark.isHidden {
            greenMark.isHidden = false
        } else {
            greenMark.isHidden = true
        }
    }
    
}

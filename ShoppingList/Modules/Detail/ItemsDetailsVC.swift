//
//  ItemsDetailsVC.swift
//  ShoppingList
//
//  Created by Andrey Sushkov on 11.08.21.
//

import UIKit
import RealmSwift

final class ItemsDetailsVC: UIViewController {
    @IBOutlet weak var itemLabel: UILabel!
    
    var item: RealmManager?
    private let realm = try! Realm()
    
    var delete: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemLabel.text = item?.item
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(deleteButtonTapped))
        
        navigationItem.rightBarButtonItem?.tintColor = .systemRed
    }
    
    @objc func deleteButtonTapped() {
        guard let anotherItem = self.item else {
            return
        }
        realm.beginWrite()
        realm.delete(anotherItem)
        try! realm.commitWrite()
        
        delete?()
        navigationController?.popToRootViewController(animated: true)
    }
}


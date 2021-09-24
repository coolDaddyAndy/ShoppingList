//
//  AddNewItemVC.swift
//  ShoppingList
//
//  Created by Andrey Sushkov on 11.08.21.
//

import UIKit
import RealmSwift

final class AddNewItemVC: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var toolbar: UIToolbar!
    
    private var units: [String] = ["", "g.", "kg.", "ml.", "l.", "cm.", "m.", "oz.", "lb.", "pt.", "gal.", "in.", "bottle(s)", "package(s)"]
    
    private let realm = try! Realm()
    var completionHandler: (() -> ())?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.becomeFirstResponder()
        textField.text = ""
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add to the list",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(addButtonTapped))
    }
    @objc func addButtonTapped() {
        if let text = textField.text, !text.isEmpty {
            
            realm.beginWrite()
            let newItem = RealmManager()
            newItem.item = text
            realm.add(newItem)
            try! realm.commitWrite()
            
            completionHandler?()
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func okButtonTapped(_ sender: Any) {
        if textField.text != "" {
            textField.text! += " \(picker.selectedRow(inComponent: 0) + 1) " + units[picker.selectedRow(inComponent: 1)]
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func hideButtonTapped(_ sender: Any) {
        picker.isHidden = true
        toolbar.isHidden = true
    }
}

extension AddNewItemVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 1000
        case 1:
            return units.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(row + 1)"
        case 1:
            return units[row]
        default:
            return ""
        }
    }
}

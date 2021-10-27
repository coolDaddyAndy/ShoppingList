//
//  AboutAppVC.swift
//  ShoppingList
//
//  Created by Andrey Sushkov on 22.08.21.
//

import UIKit


final class AboutAppVC: UIViewController {
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureTitleLabel()
        configureDescriptionLabel()
    }
    
    private func configureTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "About the app"
        titleLabel.font = UIFont(name: "Apple SD Gothic Neo Bold", size: 30)
        titleLabel.textColor = UIColor(red:0/255, green:128/255, blue:255/255, alpha:1.0)
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    private func configureDescriptionLabel() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.text = "This simple app helps you organize your purchases in the form of list. You can add and delete items(by one or all at the time) and get full info about each of them as well. Also there is a search bar you can use in order to find item you need."
        descriptionLabel.font = UIFont(name: "Apple SD Gothic Neo Regular", size: 27)
        descriptionLabel.textAlignment = .justified
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.numberOfLines = 0
        descriptionLabel.minimumScaleFactor = 0.8
        view.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
}

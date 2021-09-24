//
//  MainListVC.swift
//  ShoppingList
//
//  Created by Andrey Sushkov on 11.08.21.
//

import UIKit
import RealmSwift


class MainListVC: UIViewController {
    @IBOutlet weak var itemsTableView: UITableView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var noItemsLabel: UILabel!
    @IBOutlet weak var howToAddLabel: UILabel!
    @IBOutlet weak var deleteAllItemsButton: UIBarButtonItem!
    
    private let realm = try! Realm()
    private var data: [RealmManager]? = []
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredData: [RealmManager]? = []
    var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else {
            return false
        }
        return text.isEmpty
    }
    var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data = Array(realm.objects(RealmManager.self))
        
        itemsTableView.rowHeight = 100
        showLabels()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for item"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func showLabels() {
        if data == [] {
            noItemsLabel.isHidden = false
            howToAddLabel.isHidden = false
            deleteAllItemsButton.isEnabled = false
        }
    }
    
    private func hideLabels() {
        noItemsLabel.isHidden = true
        howToAddLabel.isHidden = true
        deleteAllItemsButton.isEnabled = true
    }
    
    private func update() {
        data = Array(realm.objects(RealmManager.self))
        itemsTableView.reloadData()
    }
    
    @IBAction func deleteAll(_ sender: Any) {
        let alert = UIAlertController(title: "Attention!", message: "All the items will be deleted. Continiue?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete all", style: .destructive) { [self]_ in
            guard let clearArray = self.data else {
                return
            }
            realm.beginWrite()
            realm.delete(clearArray)
            try! realm.commitWrite()
            
            noItemsLabel.isHidden = false
            howToAddLabel.isHidden = false
            deleteAllItemsButton.isEnabled = false
            update()
            navigationController?.popToRootViewController(animated: true)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func aboutAppButton(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "aboutAppSB") as? AboutAppVC else {
            return
        }
        vc.title = "About the app"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(identifier: "addItemSB") as? AddNewItemVC else {
            return
        }
        
        vc.completionHandler = { [weak self] in
            self?.showLabels()
            self?.update()
        }
        vc.title = ""
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension MainListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredData?.count ?? 0
        }
        return data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomTableViewCell
        if isFiltering {
            cell.itemLabel.text = filteredData?[indexPath.row].item
        } else {
            cell.itemLabel.text = data?[indexPath.row].item
        }
        hideLabels()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item: RealmManager
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "detailSB") as? ItemsDetailsVC else {
            return
        }
        if isFiltering {
            item = filteredData?[indexPath.row] ?? RealmManager()
        } else {
            item = data?[indexPath.row] ?? RealmManager()
        }
        vc.item = item
        vc.delete = { [weak self] in
            self?.noItemsLabel.isHidden = false
            self?.howToAddLabel.isHidden = false
            self?.deleteAllItemsButton.isEnabled = false
            self?.update()
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = "Details"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipe = UIContextualAction(style: .destructive, title: "Delete") { [self] (action, self, completion) in
            guard let anotherItem = data?[indexPath.row] else {
                return
            }
            realm.beginWrite()
            realm.delete(anotherItem)
            try! realm.commitWrite()
            
            data?.remove(at: indexPath.row)
            itemsTableView.deleteRows(at: [indexPath], with: .automatic)
            
            showLabels()
            itemsTableView.reloadData()
        }
        return UISwipeActionsConfiguration(actions: [swipe])
    }
}

extension MainListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearch(searchController.searchBar.text ?? "")
    }
    
    func filterContentForSearch(_ searchText: String) {
        filteredData = data?.filter({ (item:RealmManager) -> Bool in
            return item.item.lowercased().contains(searchText.lowercased())
        })
        itemsTableView.reloadData()
    }
}



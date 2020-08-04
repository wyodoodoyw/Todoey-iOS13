//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class ToDoListViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var toDoItems: Results<Item>?
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "\(selectedCategory?.name ?? "To Do List")"
    }
    
    // MARK: - TableView DataSource Methods
    
        // Return the number of rows for the table.
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return toDoItems?.count ?? 1
        }
    
        // Provide a cell object for each row.
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = super.tableView(tableView, cellForRowAt: indexPath)
            
            if let item = toDoItems?[indexPath.row] {
                cell.textLabel?.text = toDoItems?[indexPath.row].title ?? "No Items Added Yet"
                cell.accessoryType = item.done ? .checkmark : .none
            } else {
                cell.textLabel?.text = "No Items Added"
            }
            
            return cell
        }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
            
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        

//            if let currentCategory = self.selectedCategory {
//                do {
//                    try self.realm.write {
//                        let newItem = Item()
//                        newItem.title = textField.text!
//                        newItem.dateCreated = Date()
//                        currentCategory.items.append(newItem)
//                    }
//                } catch {
//                    print("Error saving new items, \(error)")
//                }
//            }
//            self.tableView.reloadData()
//        }
        
//        alert.addTextField { (alertTextField) in
//            alertTextField.placeholder = "Create new item"
//            textField = alertTextField
//        }
//        alert.addAction(action)
//        present(alert, animated: true, completion: nil)
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new item"
            
        }
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Data Manipultaion Methods

    func loadItems() {
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    // MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.toDoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            } catch {
                print("Error deleting Item, \(error)")
            }
        }
    }
}

// MARK: - Search Bar Methods

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

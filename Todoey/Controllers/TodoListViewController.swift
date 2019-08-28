//
//  ViewController.swift
//  Todoey
//
//  Created by Alexander Ulrichsen on 27/08/2019.
//  Copyright © 2019 Alexander Ulrichsen. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    var todoItems: Results<Item>?
    let realm = try! Realm()

    var selectedCategory : Category? {      //Gets category from category class
        //didSet keyword happens as when selectedCategory is set with a value
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            //Ternary operator ==>              (shortened if else statement)
            //value = condition ? valueIf True : valueFlase
            cell.accessoryType = item.done ? .checkmark : .none
            
        }
        else {
            cell.textLabel?.text = "No Items Added"
        }
        
        
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
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
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        //Popup/UIAlert controller to show
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        //What will happen once user clicks add item button on UIAlert
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if textField.text != nil && textField.text != "" {
                
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = textField.text!
                            
                            newItem.dateCreated = Date()
                            
                            currentCategory.items.append(newItem)  //Adds new item to items list in Category class
                        }
                    } catch {
                        print("Error saving new items, \(error)")
                    }
                }
           }
            
            self.tableView.reloadData()
        }
        
        
        //Adds text field to alert to allow user to wirte their todo message
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Model Manupulation Methods
    
    
    func loadItems() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }

    
}

//MARK: - Search Bar Methods

//Extension to split up functionality of class
//Allows delegates to be split from initial declaration
extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
     
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
        
    }


    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            //Object that manages the execution of work items
            DispatchQueue.main.async {
                //Tells search bar to go back to previous state in the backgound
                searchBar.resignFirstResponder()
            }

        }
    }
}

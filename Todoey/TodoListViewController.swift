//
//  ViewController.swift
//  Todoey
//
//  Created by Alexander Ulrichsen on 27/08/2019.
//  Copyright © 2019 Alexander Ulrichsen. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["Find Mike", "Buy Eggs", "Destroy Demogorgon"]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load itemArray from stored default data
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = items
        }
    }

    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        print(itemArray[indexPath.row])
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Checks or unchecks row depending on if it is currently checked or not
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        //Popup/UIAlert controller to show
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        //What will happen once user clicks add item button on UIAlert
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if textField.text != nil && textField.text != "" {
                self.itemArray.append(textField.text!)  //Add alert text to itemArray
                
                //Saves updated array so that array will be reloaded every time app is opened
                self.defaults.set(self.itemArray, forKey: "TodoListArray")
                
                self.tableView.reloadData()
            }
        }
        
        //Adds text field to alert to allow user to wirte their todo message
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            
            textField = alertTextField
        }
        
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
}


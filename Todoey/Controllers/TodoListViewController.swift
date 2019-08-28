//
//  ViewController.swift
//  Todoey
//
//  Created by Alexander Ulrichsen on 27/08/2019.
//  Copyright © 2019 Alexander Ulrichsen. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()

    var selectedCategory : Category? {      //Gets category from category class
        //didSet keyword happens as when selectedCategory is set with a value
        didSet {
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext  //Singleton

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        //Ternary operator ==>              (shortened if else statement)
        //value = condition ? valueIf True : valueFlase
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
  
        //Delete items
//        context.delete(itemArray[indexPath.row])  //Remove data from permanent stores
//        itemArray.remove(at: indexPath.row)
        
        saveItems()
        
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
                
                let newItem = Item(context: self.context)
                newItem.title = textField.text!
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
                self.itemArray.append(newItem)  //Add alert text to itemArray
                
                self.saveItems()
                
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
    
    
    //MARK: - Model Manupulation Methods
    
    func saveItems() {
        
        do {
            try context.save()
        } catch{
            print("Error saving context, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    //Item.fetchRequest() is the default value if no parameter is provided when the method is called
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
       
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        //if predicate passed to method is not nil
        if let additionalPredicate = predicate {
            
            //Predicate for our request is a compound predicate of passed predicate and category predicate
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }
        else {
            request.predicate = categoryPredicate       //No additional predicate passed to function
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
    
}

//MARK: - Search Bar Methods

//Extension to split up functionality of class
//Allows delegates to be split from initial declaration
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        //Predicate used to search database
        //%@ = attribute name (searchBar.text in this case)
        //[cd] prevents it from bein case and diacretic sensitive
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
     
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
        
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

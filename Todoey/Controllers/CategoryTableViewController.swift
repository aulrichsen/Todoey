//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Alexander Ulrichsen on 28/08/2019.
//  Copyright © 2019 Alexander Ulrichsen. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {

    let realm = try! Realm()                //Initialise access point to realm database
    
    //Array of NS managed objects (Category from data model)
    var categoryArray: Results<Category>?
    
    //context used to Create, Read, Update and Destory data
    //Communicates with persistent container
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext  //Singleton

    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()

    }

    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //?? means Nil Coalescing Operator - tests is variable is equal to nil
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        //let item = categoryArray[indexPath.row]
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added Yet"
        
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {     //Finds selected index path
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
        
    }
    
    
    
    //MARK: - Data Manipulation Methods
    
    func saveData(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
            
        } catch{
            print("Error saving context, \(error)")
        }
        
        self.tableView.reloadData()
        
    }
    
    func loadData() {
        
        categoryArray = realm.objects(Category.self)

        tableView.reloadData()

    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        //Popup/UIAlert controller to show
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        //What will happen once user clicks add item button on UIAlert
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            if textField.text != nil && textField.text != "" {
                
                let newCategory = Category()
                newCategory.name = textField.text!

                self.saveData(category: newCategory)

            }
        }
        
        
        //Adds text field to alert to allow user to wirte their category
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
}

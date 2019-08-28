//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Alexander Ulrichsen on 28/08/2019.
//  Copyright © 2019 Alexander Ulrichsen. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    //Array of NS managed objects (Category from data model)
    var categoryArray = [Category]()
    
    //context used to Create, Read, Update and Destory data
    //Communicates with persistent container
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext  //Singleton

    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()

    }

    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        //let item = categoryArray[indexPath.row]
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {     //Finds selected index path
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
        
    }
    
    
    
    //MARK: - Data Manipulation Methods
    
    func saveData() {
        
        do {
            try context.save()
        } catch{
            print("Error saving context, \(error)")
        }
        
        self.tableView.reloadData()
        
    }
    
    func loadData(with request: NSFetchRequest<Category> = Category.fetchRequest()) {

        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }

        tableView.reloadData()

    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        //Popup/UIAlert controller to show
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        //What will happen once user clicks add item button on UIAlert
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            if textField.text != nil && textField.text != "" {
                
                let newCategory = Category(context: self.context)
                newCategory.name = textField.text!
                self.categoryArray.append(newCategory)
                
                self.saveData()

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

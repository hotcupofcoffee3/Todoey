//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Adam Moore on 4/30/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    // Initialize new 'Realm'
    let realm = try! Realm()
    
    
    
    // Have to change the type of 'categoryArray' to be of type 'Results', as declared in Realm.
    // Therefore, we renamed it to 'categories' and changed the type.
    // This can, however, be accessed using subscripts with indices.
    // We use it as an optional so that if there is nothing in 'categories', it doesn't crash our app.
    // var categoryArray = [Category]()
    
    var categories: Results<Category>?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadData()
    
    }
    
    
    // MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var newCategoryTextFieldFromAlertTextField = UITextField()
        
        let alert = UIAlertController(title: nil, message: "Add Category", preferredStyle: .alert)
        
        alert.addTextField { (addCategoryTextField) in
            
            addCategoryTextField.placeholder = "Create new category"
            newCategoryTextFieldFromAlertTextField = addCategoryTextField
            
        }
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
            
            let newCategory = Category()
            newCategory.name = newCategoryTextFieldFromAlertTextField.text!
            
            self.saveData(category: newCategory)

        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    // MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // If the 'categories' results from the 'Realm' database is empty, or nil, then the return is 1 row.
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        // If the 'categories' results from the 'Realm' database is empty, or nil, then the text for the 1 row that was created using our nil coalescing operator has the text 'No categories added yet'.
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        
        return cell
        
    }
    
    
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    
    // *** Delegate that sets the variable 'selectedCategory' on the 'ToDoListViewController'.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ToDoListViewController
        
        // Used as a global variable that selects the indexPath that was selected in the table.
        if let indexPath = tableView.indexPathForSelectedRow {
            
            // Sets 'selectedCategory' in the 'ToDoListViewController' to the current category being selected.
            destinationVC.selectedCategory = categories?[indexPath.row]
            
        }
        
    }
    
    
    
    // Mark: - Data Manipulation Methods
    
    func saveData(category: Category) {
        
        do {
            
            try realm.write {
                realm.add(category)
            }
            
        } catch {
            
            print("Error that we got: \(error)")
            
        }
        
        tableView.reloadData()
        
    }
    
    func loadData() {
        
        // Loads all of the objects that are in the 'Category' object.
        // This returns a 'Result' type, that isn't the same as an array, as in CoreData.
        // Therefore, it has to be converted in order to be used in our 'categoryArray' variable.
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
        
    }
    
    

}














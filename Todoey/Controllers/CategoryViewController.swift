//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Adam Moore on 4/30/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
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
        
        // Taps into Superclass cell in 'SwipeTableViewController' where the function is initially customized that we inherit from.
        // This initializes a cell based on the information in the (), with 'tableView' being the default table view name in this VC, and the 'indexPath' that is used here, and passes it to this instance of 'cell' using the superview's 'cellForRowAt' function.
        
        // *** In other words, the current VC's 'tableView' and 'indexPath' are passed to the identical function in the super class and uses its information (The custom cell dequeued and cast as the Swipe cell, and setting the 'cell.delegate' as the 'SwipeTableViewController') to set the parent's information as the 'cell' information for this particular cell.
        
        // We can then add the text that we want below to this cell.
        
        
        // **************
        
        // Also, make sure to change the class of the cell in the Main.storyboard to the class and module that match the 'Swipe' class and module necessary. Otherwise, it'll try to cast a 'UITableViewCell' as a 'SwipeTableViewCell', and the app will crash.
        
        // **************
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        // If the 'categories' results from the 'Realm' database is empty, or nil, then the text for the 1 row that was created using our nil coalescing operator has the text 'No categories added yet'.
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        
        let categoryBackground = UIColor(hexString: (categories?[indexPath.row].bgColor)!)!
        
        cell.backgroundColor = categoryBackground
        
        cell.textLabel?.textColor = ContrastColorOf(categoryBackground, returnFlat: true)
        
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
    
    
    // This taps into the function in the 'SwipeTableViewController', and overrides it when it is called. This is almost like a delegate, because it is initialized and run in the superview, but executed in this VC.
    override func updateModel(at indexPath: IndexPath) {
        
        if let category = self.categories?[indexPath.row] {
            do {

                try self.realm.write {
                    self.realm.delete(category)
                }

            } catch {

                print("Error deleting item: \(error)")

            }

        }
        
    }
    
    

}









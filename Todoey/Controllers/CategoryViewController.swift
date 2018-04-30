//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Adam Moore on 4/30/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

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
            
            let newCategory = Category(context: self.context)
            newCategory.name = newCategoryTextFieldFromAlertTextField.text!
            
            self.categoryArray.append(newCategory)
            
            self.saveData()

        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    // MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
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
            destinationVC.selectedCategory = categoryArray[indexPath.row]
            
        }
        
    }
    
    
    
    // Mark: - Data Manipulation Methods
    
    func saveData() {
        
        do {
            
            try context.save()
            
        } catch {
            
            print("Error that we got: \(error)")
            
        }
        
        tableView.reloadData()
        
    }
    
    func loadData() {
        
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            
            categoryArray = try context.fetch(request)
            
        } catch {
            
            print("Error that we got: \(error)")
            
        }
        
        tableView.reloadData()
        
    }
    
    

}














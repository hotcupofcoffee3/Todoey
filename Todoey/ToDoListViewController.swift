//
//  ToDoListViewController.swift
//  Todoey
//
//  Created by Adam Moore on 4/24/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    // No need to create an @IBOutlet for the table view when it is a UITableViewController
    // The default name for the outlet is "tableView"
    
    var itemArray = ["Find Mike", "Buy Eggs", "Destroy Demogorgon"]
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let items = UserDefaults.standard.object(forKey: "ToDoListArray") as? [String] {
            
            self.itemArray = items
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableView Datasoure Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)

        cell.textLabel?.text = itemArray[indexPath.row]

        return cell
        
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Adds checkmark if none, and removes it if it does.
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            
        } else {
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            
        }
        
        // Deselects row after it is selected, in a 'flash' sort of way, as it is animated.
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // Have to create local variable of 'textField' type, because when the textfield is loaded, it only has the text that is within the scope of the 'addTextField' alert action. Therefore, a 'UITextField' has to be created that gets the value of the 'alertTextField', so that whatever is typed in the text field is also assigned to the 'newItemTextField' variable. In other words, 'alertTextField.text' will always be empty for the 'Add Item' action, because the text is only accessible within the 'addTextField' action, and it can only be set when the action is called, so at the VERY BEGINNING, when there is NOTHING in the text field. By setting not the text, but the textfield, to a local variable (i.e., 'newItemTextField'), anything that goes done to the 'alertTextField' when it's opened and created in the alert is also done to the local variable. It is through this local variable that we access the text in the 'Add Item' action that we click.
        
        var newItemTextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            newItemTextField = alertTextField
        }
        
        alert.addAction(UIAlertAction(title: "Add Item", style: .default, handler: { (action) in
            
            self.itemArray.append(newItemTextField.text!)
            
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
          
            self.tableView.reloadData()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
    }
    


}
















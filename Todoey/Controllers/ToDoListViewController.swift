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
    
    var itemArray = [Item]()
    
//    let defaults = UserDefaults.standard
    
    // **************************
    
    // NSCoder way to store data that is more complex than UserDefault data.
    // This is the setup to the file path to access the document directory where the data is stored in the user domain mask.
    // This dataFilePath is an array, so we use 'first' to grab the first item in the array.
    // Then, you tap into the 'appendingPathComponent' method, and title it whatever.
    // This creates a path to the new plist that we are going to create.
    
    // ALSO, our 'Item' class has to conform to protocols 'Encodable'.
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    // **************************

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadData()
        
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

        cell.textLabel?.text = itemArray[indexPath.row].title
        
        
        // Ternary operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        

        return cell
        
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Adds checkmark if none, and removes it if it does, through setting the "done" properties and reloading the table data, so the "cellForRowAt" function above gets called and reloads the checkmark info.
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // Deselects row after it is selected, in a 'flash' sort of way, as it is animated.
        tableView.deselectRow(at: indexPath, animated: true)
        
        saveData()
        
        tableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            itemArray.remove(at: indexPath.row)
            saveData()
            tableView.reloadData()
            
        }
    }
    
    func saveData() {

        // This is used to save the data into the plist file that we created above, called 'Items.plist'.
        // It will encode the data to save it.
        let encoder = PropertyListEncoder()
        
        
        // We have to enclose this in a 'do...catch' block because the 'encode()' method can throw an error if the encoding doesn't work.
        do {
            
            // This will encode the 'itemArray' into our 'data' constant.
            // However, we have to 'try' to do it, as we are in the 'do...catch' block.
            // ALSO, our 'Item' class has to conform to protocols 'Encodable'.
            let data = try encoder.encode(itemArray)
            
            // We also have to 'try' to 'write()' to the data, as this could also throw an error.
            try data.write(to: dataFilePath!)
            
        } catch {
            
            // If it throws an error, we want to see it.
            print("Error encoding item array \(error)")
            
        }

    }
    
    func loadData() {

        // This will decode the 'data' into our 'itemArray' array.
        // However, we have to 'try' to do it, as we are in the 'do...catch' block.
        // ALSO, our 'Item' class has to conform to protocols 'Decodable'.
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            
            let decoder = PropertyListDecoder()
            
            do {
                
                itemArray = try decoder.decode([Item].self, from: data)
                
            } catch {
                
                print("Error: \(error)")
                
            }
            
        }
        
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
            
            self.itemArray.append(Item(title: newItemTextField.text!))
            
            self.saveData()
          
            self.tableView.reloadData()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
    }
    


}
















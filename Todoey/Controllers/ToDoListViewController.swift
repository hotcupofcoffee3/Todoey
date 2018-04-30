//
//  ToDoListViewController.swift
//  Todoey
//
//  Created by Adam Moore on 4/24/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    // No need to create an @IBOutlet for the table view when it is a UITableViewController
    // The default name for the outlet is "tableView"
    
    var itemArray = [Item]()
    
    
    // Checks that the 'selectedCategory' variable was set, which is going to necessarily be the case, as this VC won't be triggered unless a category is selected.
    // The 'didSet' is a method that triggers the 'loadData()' method to load our data.
    var selectedCategory: Category? {
        
        didSet {
            
            loadData()
            
        }
        
    }
    
    
    // *** Have to set a constant called "context" to hold the context that refers to the persistent container in the AppDelegate class. Here's how:
    // 1. Tap into the 'UIApplication' class
    // 2. Get the 'shared' singleton object, which corresponds to the entire project as an object.
    // 3. Tap into its 'delegate', which has the data type of 'UIApplicationDelegate?'
    // 4. Cast the delegate into our class, 'AppDelegate'.
    // 5. 'AppDelegate' and the 'UIApplication.shared.delegate' share the same class of 'UIApplicationDelegate', so it works.
    // 6. This sets all of this as an object, into which we can tap in the 'persistentContainer' object.
    // 7. Grab the 'viewContext' of that 'persistentContainer'
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      
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
        
//        itemArray[indexPath.row].setValue("Completed", forKey: "done")
        
        // Adds checkmark if none, and removes it if it does, through setting the "done" properties and reloading the table data, so the "cellForRowAt" function above gets called and reloads the checkmark info.
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // Deselects row after it is selected, in a 'flash' sort of way, as it is animated.
        tableView.deselectRow(at: indexPath, animated: true)
        
        saveData()
        
        tableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Have to delete from permanent storage first, as it uses 'itemArray[indexPath.row]' to delete from the permanent storage.
            // ***** It is set up like this:
            // Suppose we have 4 items in our array: indices 0, 1, 2, 3.
            // If 'itemArray.remove(at: indexPath.row)' is called first, say, on the last item in the array, then that leaves our array with indices 0, 1, & 2, with 'indexPath.row' set to 3.
            // However, the 'context.delete(itemArray[indexPath.row])' then tries to find this index, which is 3, and use it to delete from the permanent storage. Well, at this point, there would no longer be an index 3 in the 'itemArray', so the app would crash because the index is 'out of range'
            
            context.delete(itemArray[indexPath.row])
            itemArray.remove(at: indexPath.row)
            
            saveData()
            tableView.reloadData()
            
        }
    }
    
    func saveData() {

        // We have to tap into the 'context.save()' method in the 'AppDelegate' to save it to the 'persistentContainer'
        do {
            
            try context.save()
            
        } catch {
            
            print("Error saving context: \(error)")
            
        }

    }
    
    func loadData(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        // Filter by parent category as the first predicate.
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        // Create a compound predicate with the 'categoryPredicate' as the first predicate in the predicate array, and the parameter 'predicate' as the second.
        // The default value is 'nil' for the sorting predicate, as we only want to make sure that what we do EVERYTIME is filter the 'Item' results according to the parent category.
        // Therefore, we use optional binding
        
        if let additionalPredicate = predicate {
            
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
            
        } else {
            
            // This gets set to the request predicate.
            request.predicate = categoryPredicate
            
        }
        
        // Can only talk to context, so we have to 'fetch' using our 'request'.
        // This fetches EVERYTHING in the 'Item' entity/class.
        do{
            
            // 'fetch()' returns a result in the form of an array of the specified objects (which are our objects/rows of data that we have in 'Item'), which we know to be [Item], because we set it as such.
            // This is saved into our 'itemArray', which is what we use to load our table data as our data source.
            itemArray = try context.fetch(request)
        
        } catch {
            
            print("Error fetching data from context: \(error)")
            
        }
        
        tableView.reloadData()

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
            
            // 'Item(context:)' gets created automatically when we created the 'Item' entity in our data model
            // This creates 'newItem' as an 'NSManagedObject', which makes it a row in the database, with the columns being the properties 'title' and 'done' that we set.
            let newItem = Item(context: self.context)
            newItem.title = newItemTextField.text
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            // Also appended to the 'itemArray', as that's what we use for our tableView.
            self.itemArray.append(newItem)
            
            // We call the save method.
            // When we created a new 'NSManagedObject' above, this sees that we have changed the 'context', and saves it using the 'context.save()' method.
            self.saveData()
          
            self.tableView.reloadData()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
    }
    
}

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        // Have to use "NSPredicate(format:_:)" in order to search.
        // The 'title' part of the 'format' is the property in 'Item' that we will be searching for.
        // The "%@" symbols is used as a placeholder variable for our 'searchBar.text!' input that we used.
        // 'NSPredicate' is a data class that specifies how data should be fetched, and is part of Objective-C.
        // This 'format' string has a number of options to put in here to fetch from the database.
        // FYI, '[cd]' just tells the search not to be case- or diacritic-sensitive.
        // For a list, go to: academy.realm.io/posts/nspredicate-cheatsheet.
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        // Using 'NSSortDescriptor' sorts according to key and ascending/descending values.
        // 'sortDescriptors' contains an array of sort descriptors, but we only have one, so we have to use it as the only object in an array.
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        
        // Use the same 'do...catch' functionality from our 'loadData()' method, because it fetches the data and adds it to our local 'itemArray' variable.
        loadData(with: request, predicate: predicate)
        
    }
    
    func filterBy(name: String) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", name)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadData(with: request, predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // Another form of comparing to an empty string: ""
        if searchBar.text?.count == 0 {
            
            loadData()
            
            // Grabs the main thread, and runs the 'resignFirstResponder()' in the foreground, on the main thread, so that if there is some time needed to reload the table, or other background tasks when searching the internet, this process goes ahead and takes place right away, instead of waiting for the entire process to finish.
            DispatchQueue.main.async {
                
                searchBar.resignFirstResponder()
                
            }
            
        } else {
            
            filterBy(name: searchBar.text!)
            
        }
        
    }
    
    
    
}
















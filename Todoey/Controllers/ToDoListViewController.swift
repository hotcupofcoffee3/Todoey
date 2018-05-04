//
//  ToDoListViewController.swift
//  Todoey
//
//  Created by Adam Moore on 4/24/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {
    
    // No need to create an @IBOutlet for the table view when it is a UITableViewController
    // The default name for the outlet is "tableView"
    
    var items: Results<Item>?
    let realm = try! Realm()
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory: Category? {
        
        didSet {
            
            loadData()
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let colourHex = selectedCategory?.bgColor else { return }
        
        updateNavBar(withHexCode: colourHex)
        
        title = selectedCategory?.name
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        updateNavBar(withHexCode: "466D6F")
        
    }
    
    
    // MARK: - Nav Bar Setup Methods
    
    func updateNavBar(withHexCode colorHexCode: String) {
        
        guard let navBar = navigationController?.navigationBar else { return }
        
        guard let navBarColour = UIColor(hexString: colorHexCode) else { return }
        
        navBar.barTintColor = navBarColour
        
        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: ContrastColorOf(navBarColour, returnFlat: true)]
        
        searchBar.barTintColor = navBarColour
        
    }
    
    
    // MARK: - TableView Datasoure Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        if let item = items?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            // Ternary operator ==>
            // value = condition ? valueIfTrue : valueIfFalse
            cell.accessoryType = item.done ? .checkmark : .none
            
            let colourPercent = (CGFloat(indexPath.row) / CGFloat((items?.count)!)) / 2
            let categoryColor = selectedCategory?.bgColor
            let categoryAsUIColor = UIColor(hexString: categoryColor!)!
            let itemBackgroundColour = categoryAsUIColor.darken(byPercentage: colourPercent)!
            
            cell.backgroundColor = itemBackgroundColour
            cell.textLabel?.textColor = ContrastColorOf(itemBackgroundColour, returnFlat: true)
            
        } else {
            
            cell.textLabel?.text = "No items added yet."
            
        }
        
        return cell
        
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = items?[indexPath.row] {
            
            do {
                
                try realm.write {
                    item.done = !item.done
                }
                
            } catch {
                
                print("Error saving done status: \(error)")
                
            }

        }

        // Deselects row after it is selected, in a 'flash' sort of way, as it is animated.
        tableView.deselectRow(at: indexPath, animated: true)

        tableView.reloadData()
        
    }
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let item = items?[indexPath.row] {
            do {
                
                try realm.write {
                    realm.delete(item)
                }
                
            } catch {
                
                print("Error deleting item: \(error)")
                
            }
            
        }

    }
    
    func loadData() {

        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

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
            
            if let currentCategory = self.selectedCategory {
                
                do{
                    
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = newItemTextField.text!
                        newItem.date = Date()
                        currentCategory.items.append(newItem)
                    }
                    
                } catch {
                    
                    print("Error saving new items: \(error)")
                    
                }
                
            }
            
            self.tableView.reloadData()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
    }
    
}

extension ToDoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        // Filtering our 'items' array/results object with an NSPredicate, just like in CoreData.
        // We can then tag on the '.sorted()' method at the end, being sorted by keyPath and ascending.
        // This makes our 'items' object now only contain the information that we are searching for.
        // This also updates table results, as it isn't a new request from the database, but simply filtering the objects that were already in 'items'
        
        
        // *** Actual implementation from the instructions, but I resorted it with the function 'filterBy()' so that it can be called whenever a new letter is typed in the searchbar for when the 'textDidChange' searchBar method happens.
//        items = items?.filter("title CONTAINS[cd] %@", searchBar.text!)
        
        
        
        filterBy(name: searchBar.text!)

    }

    func filterBy(name: String) {

        items = items?.filter("title CONTAINS[cd] %@", name).sorted(byKeyPath: "date", ascending: false)

        tableView.reloadData()
        
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
            
            // Constantly filters and updates the table data as the user types.
            filterBy(name: searchBar.text!)

        }

    }



}
















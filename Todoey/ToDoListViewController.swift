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
    
    let itemArray = ["Find Mike", "Buy Eggs", "Destroy Demogorgon"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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


}


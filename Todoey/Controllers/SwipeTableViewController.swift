//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Adam Moore on 5/3/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import UIKit
import SwipeCellKit
import ChameleonFramework

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    var cell: UITableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80
        tableView.separatorStyle = .none

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        return cell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            print("Deleted")
            
            
            // This is used so that every child has access to this method in their own ways of executing it.
            // It is left empty because it doesn't need to do any functionality here.
            // What it does is executes within this function when the children use this method, which they inherit by being inheriting from this class as the subclass.
            // This passes in the 'updateModel(at:)' method the current 'indexPath' for each of the cells of its children.
            
            // ***** In other words, this function will run in the function below if nothing else is done.
            // However, if the children OVERRIDE the function, then the functionality they add in their overriding function will be what is called by this method.
            
            self.updateModel(at: indexPath)
            
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
        
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    
    
    // MARK: - Used to update data model generically, as this superclass cannot know anything about its children, so everything has to be generic.
    func updateModel(at indexPath: IndexPath) {
        
    }


}


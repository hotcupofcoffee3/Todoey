//
//  Item.swift
//  Todoey
//
//  Created by Adam Moore on 5/1/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var date: Date?
    
    // Backward relationship to 'Category' in a 'One to one' relationship
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}

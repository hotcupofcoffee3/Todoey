//
//  Category.swift
//  Todoey
//
//  Created by Adam Moore on 5/1/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    
    // 'List' is basically an array, declared in 'Realm'
    // This creates a 'One to many' relationship with 'Item'
    let items = List<Item>()
    
}

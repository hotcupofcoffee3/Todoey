//
//  ItemModel.swift
//  Todoey
//
//  Created by Adam Moore on 4/26/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import Foundation

// Has to conform to the protocols 'Encodable' in order to be saved into a plist.
// In order to be encodable, all of the data types WITHIN the custom class have to be standard data types

// Has to conform to 'Encodable' and 'Decodable'.
// We could write it: 'class Item: Encodable, Decodable'... however....
// Swift has combined those to be simply 'Codable'

class Item: Codable {
    
    var title: String
    var done: Bool = false
    init(title: String) {
        self.title = title
    }
    
}

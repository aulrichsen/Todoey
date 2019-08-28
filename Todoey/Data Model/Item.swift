//
//  Item.swift
//  Todoey
//
//  Created by Alexander Ulrichsen on 28/08/2019.
//  Copyright © 2019 Alexander Ulrichsen. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")  //Defines inverse relationship of items
    
}

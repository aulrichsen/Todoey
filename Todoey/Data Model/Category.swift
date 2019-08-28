//
//  Category.swift
//  Todoey
//
//  Created by Alexander Ulrichsen on 28/08/2019.
//  Copyright © 2019 Alexander Ulrichsen. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    
    let items = List<Item>()     //Create empty list of type Item
}

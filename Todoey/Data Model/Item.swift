//
//  Item.swift
//  Todoey
//
//  Created by Alexander Ulrichsen on 27/08/2019.
//  Copyright © 2019 Alexander Ulrichsen. All rights reserved.
//

import Foundation

//Item type is able to encode itself into a plist or a JSON
//Must have standard data types
class Item: Encodable, Decodable {
    var title : String = ""
    var done : Bool = false
    
}

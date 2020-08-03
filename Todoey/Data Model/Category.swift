//
//  Category.swift
//  Todoey
//
//  Created by Matthew Wood on 2020-08-02.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    
    let items = List<Item>()
}

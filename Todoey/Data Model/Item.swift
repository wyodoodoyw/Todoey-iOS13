//
//  Item.swift
//  Todoey
//
//  Created by Matthew Wood on 2020-08-01.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

//class Item: Encodable, Decodable {
class Item: Codable {
    var title: String = ""
    var done: Bool = false
}

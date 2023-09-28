//
//  Category.swift
//  TodoeyFinal
//
//  Created by SinaVN on 6/30/1402 AP.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = "0.598207 0.69861 0.976845 1"
    // To-many relationship - a category can have many items
    var items = List<Item>()
}

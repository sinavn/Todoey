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
//    @objc dynamic var id: Int = 1
    // To-many relationship - a category can have many items
    var items = List<Item>()
}

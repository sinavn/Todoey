//
//  Item.swift
//  TodoeyFinal
//
//  Created by SinaVN on 6/30/1402 AP.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var date : Date?
    // Inverse relationship - an item can only be a part of one parentCategory
     var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}

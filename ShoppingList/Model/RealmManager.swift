//
//  RealmManager.swift
//  ShoppingList
//
//  Created by Andrey Sushkov on 17.08.21.
//

import RealmSwift

class RealmManager: Object {
    @Persisted var item: String = ""
}

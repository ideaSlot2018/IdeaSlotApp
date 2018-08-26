//
//  Idea.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/08/04.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import Foundation
import RealmSwift

class Base: Object{
    @objc dynamic var createDate = Date()
    @objc dynamic var updateDate = Date()
}

class User: Base{
    @objc dynamic var userId: String? = NSUUID().uuidString
    @objc dynamic var userName: String? = ""
    @objc dynamic var password: String? = ""

    override class func primaryKey() -> String {
        return "userId"
    }
//    override static func indexedProperties() -> [String] {
//        return ["userId"]
//    }
}

class Words: Base {
    @objc dynamic var wordId: String? = NSUUID().uuidString
    @objc dynamic var word: String? = ""
//    @objc dynamic var category: Category?
    let category = LinkingObjects(fromType: Category.self, property: "words")
    
    @objc dynamic var userId: String? = ""
    @objc dynamic var ideaFlag: Int = 0
    
    override class func primaryKey() -> String {
        return "wordId"
    }
//    override static func indexedProperties() -> [String] {
//        return ["wordId"]
//    }
}

class Category: Base {
    @objc dynamic var categoryId = ""
    @objc dynamic var categoryName = ""
//    @objc dynamic var userId: String? = ""
    let words = List<Words>()
    let ideas = List<Idea>()

    override class func primaryKey() -> String {
        return "categoryId"
    }

}

class Idea: Base {
    @objc dynamic var ideaId: String? = NSUUID().uuidString
    @objc dynamic var ideaName: String? = ""
//    @objc dynamic var category: Category?
    let category = LinkingObjects(fromType: Category.self, property: "ideas")
    @objc dynamic var userId: String? = ""
    @objc dynamic var wordId_1: String? = ""
    @objc dynamic var operator_1: String? = ""
    @objc dynamic var wordId_2: String? = ""
    @objc dynamic var operator_2: String? = ""
    @objc dynamic var wordId_3: String? = ""
    @objc dynamic var operator_3: String? = ""
    @objc dynamic var detail: String? = ""

    override class func primaryKey() -> String {
        return "ideaId"
    }
//    override static func indexedProperties() -> [String] {
//        return ["ideaId"]
//    }
}

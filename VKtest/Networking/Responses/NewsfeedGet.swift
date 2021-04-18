//
//  NewsfeedGet.swift
//  VKtest
//
//  Created by Микаэл Мартиросян on 11.02.2021.
//

import Foundation
import RealmSwift

struct NewsfeedGetResponse: Decodable {
    let response: NewsfeedGetResults
}

struct NewsfeedGetResults: Decodable {
    var items: [NewsfeedGetItems]
    var profiles: [NewsfeedGetProfiles]
    var groups: [NewsfeedGetGroups]
    var nextFrom: String
    
    enum CodingKeys: String, CodingKey {
        case items
        case profiles
        case groups
        case nextFrom = "next_from"
    }
}

class NewsfeedGetItems: Object, Decodable {
    @objc dynamic var sourceId = 0
    @objc dynamic var date = 0
    @objc dynamic var text = ""
    
    enum CodingKeys: String, CodingKey {
        case sourceId = "source_id"
        case date = "date"
        case text = "text"
    }
    
    override class func primaryKey() -> String? {
        return "sourceId"
    }
}

class NewsfeedGetProfiles: Object, Decodable {
    @objc dynamic var firstName = ""
    @objc dynamic var id = 0
    @objc dynamic var lastName = ""
    @objc dynamic var screenName = ""
    @objc dynamic var photo50 = ""
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case id = "id"
        case lastName = "last_name"
        case screenName = "screen_name"
        case photo50 = "photo_50"
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

class NewsfeedGetGroups: Object, Decodable {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var screenName = ""
    @objc dynamic var isClosed = 0
    @objc dynamic var type = ""
    @objc dynamic var isMember = 0
    @objc dynamic var photo50 = ""
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case screenName = "screen_name"
        case isClosed = "is_closed"
        case type = "type"
        case isMember = "is_member"
        case photo50 = "photo_50"
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}



















//class NewsfeedGetProfiles: Object, Decodable {
//    @objc dynamic var firstName = ""
//    @objc dynamic var id = 0
//    @objc dynamic var lastName = ""
//    @objc dynamic var sex = 0
//    @objc dynamic var screenName = ""
//    @objc dynamic var photo50 = ""
//    @objc dynamic var photo100 = ""
//
//    enum CodingKeys: String, CodingKey {
//        case firstName = "first_name"
//        case id
//        case lastName = "last_name"
//        case sex
//        case screenName = "screen_name"
//        case photo50 = "photo_50"
//        case photo100 = "photo_100"
//    }
//
//    override class func primaryKey() -> String? {
//        return "id"
//    }
//}
//
//class NewsfeedGetGroups: Object, Decodable {
//    @objc dynamic var id = 0
//    @objc dynamic var name = ""
//    @objc dynamic var screenName = ""
//    @objc dynamic var type = ""
//    @objc dynamic var isMember = 0
//    @objc dynamic var photo50 = ""
//    @objc dynamic var photo100 = ""
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case name
//        case screenName = "screen_name"
//        case type
//        case isMember = "is_member"
//        case photo50 = "photo_50"
//        case photo100 = "photo_100"
//    }
//
//    override class func primaryKey() -> String? {
//        return "id"
//    }
//}

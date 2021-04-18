//
//  FriendsGet.swift
//  VKtest
//
//  Created by Микаэл Мартиросян on 29.12.2020.
//

import Foundation
import RealmSwift

struct FriendsGetResponse: Decodable {
    let response: FriendsGetResults
}

struct FriendsGetResults: Decodable {
    let count: Int
    let items: [FriendsGetItems]
}

class FriendsGetItems: Object, Decodable {
    @objc dynamic var id = 0
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
    @objc dynamic var photo50 = ""
    @objc dynamic var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case firstName = "first_name"
        case lastName = "last_name"
        case photo50 = "photo_50"
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

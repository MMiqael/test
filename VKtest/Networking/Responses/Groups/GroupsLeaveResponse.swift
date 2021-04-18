//
//  GroupsLeaveResponse.swift
//  VKtest
//
//  Created by Микаэл Мартиросян on 09.02.2021.
//

import Foundation
import RealmSwift

class GroupsLeaveResponse: Object, Decodable {
    @objc dynamic var response = 0
    
    enum CodingKeys: String, CodingKey {
        case response
    }
    
    override class func primaryKey() -> String? {
        return "response"
    }
}

//
//  PhotoGetAll.swift
//  VKtest
//
//  Created by Микаэл Мартиросян on 10.01.2021.
//

import Foundation
import RealmSwift

struct PhotosGetAllResponse: Decodable {
    let response: PhotosGetAllResults
}

struct PhotosGetAllResults: Decodable {
    let count: Int
    let items: [PhotosGetAllItems]
}

class PhotosGetAllItems: Object, Decodable {
    @objc dynamic var id = 0
    @objc dynamic var url = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case sizes
    }

    enum SizesCodingKeys: String, CodingKey {
        case url
    }

    required convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(Int.self, forKey: .id)

        var sizesValues = try values.nestedUnkeyedContainer(forKey: .sizes)
        let urlValues = try sizesValues.nestedContainer(keyedBy: SizesCodingKeys.self)
        self.url = try urlValues.decode(String.self, forKey: .url)
    }
    
    override static func primaryKey() -> String? {
        return "url"
    }
}

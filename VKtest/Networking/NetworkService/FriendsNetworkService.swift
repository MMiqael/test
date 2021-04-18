//
//  FriendsNetworkService.swift
//  VKtest
//
//  Created by Микаэл Мартиросян on 11.02.2021.
//

import Alamofire
import RealmSwift

class FriendsNetworkService {
    
    let baseUrl = "https://api.vk.com/method/friends"
    let session = Session.shared
    let version = "5.126"

    // MARK: .get
    func get(completion: @escaping (Int) -> Void) {
        let path = ".get"
        let url = baseUrl + path
        
        guard let token = session.token else { return }
        
        let params: Parameters = [
            "order": "hints",
            "fields": "photo_50",
            "access_token": token,
            "v": version
        ]
        
        AF.request(url, method: .get, parameters: params).responseData { [weak self] response in
            guard let data = response.value else { return print("data error") }
            do {
                let items = try JSONDecoder().decode(FriendsGetResponse.self, from: data).response.items
                let count = try JSONDecoder().decode(FriendsGetResponse.self, from: data).response.count
                print(items)
                self?.saveFriendsData(items)
                completion(count)
                print(count)
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: saveFriendsData
    func saveFriendsData(_ friends: [FriendsGetItems]) {
        do {
//            var config = Realm.Configuration.defaultConfiguration
//            config.deleteRealmIfMigrationNeeded = true
            
            let realm = try Realm(/*configuration: config*/)
            let oldValues = realm.objects(FriendsGetItems.self)
            realm.beginWrite()
            realm.delete(oldValues)
            realm.add(friends/*, update: .modified*/)
            try realm.commitWrite()
            
            print(realm.configuration.fileURL!)
        } catch {
            print(error)
        }
    }
}





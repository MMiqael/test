//
//  NewsfeedNetworkService.swift
//  VKtest
//
//  Created by Микаэл Мартиросян on 12.02.2021.
//

import Alamofire
import RealmSwift

class NewsfeedNetworkService {
    
    let baseUrl = "https://api.vk.com/method/newsfeed"
    let session = Session.shared
    let version = "5.126"
    
    // MARK: .get
    func get() {
        
        let path = ".get"
        let url = baseUrl + path
        
        guard let token = session.token else { return }
        
        let params: Parameters = [
            "filters": "post",
            "return_banned": 0,
            "count": 5,
            "access_token": token,
            "v": version
        ]
        
        AF.request(url, method: .get, parameters: params).responseData { /*[weak self]*/ response in
            guard let data = response.value else { return print("data error") }
            print("Response: \(response)")
            print("Data: \(data)")
        
            do {
                let items = try JSONDecoder().decode(NewsfeedGetResponse.self, from: data).response.items
                print("Items: \(items)")
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: saveNewsfeedData
    func saveNewsfeedData(_ newsfeed: [NewsfeedGetItems]) {
        do {
//            var config = Realm.Configuration.defaultConfiguration
//            config.deleteRealmIfMigrationNeeded = true
            
            let realm = try Realm(/*configuration: config*/)
            let oldValue = realm.objects(NewsfeedGetItems.self)
            realm.beginWrite()
            realm.delete(oldValue)
            realm.add(newsfeed, update: .modified)
            try realm.commitWrite()
            
            print(realm.configuration.fileURL!)
        } catch {
            print(error)
        }
    }
}

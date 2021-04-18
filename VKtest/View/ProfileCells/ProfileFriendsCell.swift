//
//  ProfileFriendsCell.swift
//  VKtest
//
//  Created by Микаэл Мартиросян on 08.02.2021.
//

import UIKit
import RealmSwift
import Alamofire

class ProfileFriendsCell: UITableViewCell {
    
    private var friends: Results<FriendsGetItems>?
    private let friendsNetworkService = FriendsNetworkService()

    @IBOutlet weak var friendsLabel: UILabel!
    @IBOutlet weak var friendsCount: UILabel!
    
    @IBOutlet weak var profileFriendsCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileFriendsCollectionView.delegate = self
        profileFriendsCollectionView.dataSource = self
        
        loadData()
        
        friendsNetworkService.get { count in
            print("Count: \(count)")
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func showFriendsButton(_ sender: Any) {
    }
    
    func loadData() {
        do {
            let realm = try Realm()
            let results = realm.objects(FriendsGetItems.self)
            friends = results
            reloadInputViews()
        } catch {
            print(error)
        }
    }
}

extension ProfileFriendsCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friends?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EnumReuseIdentifiers.profileFriendsCollectionCell.rawValue, for: indexPath) as? ProfileFriendsCollectionCell else { fatalError("Unable to creare explore table view cell") }
        
        cell.nameLabel.text = friends?[indexPath.row].fullName
        
        let session = URLSession.shared
        if let avatarUrl = URL(string: friends?[indexPath.row].photo50 ?? EnumDefaultValues.camera50.rawValue) {
            session.downloadTask(with: avatarUrl) { (url, _, error) in
                do {
                    guard let url = url else { return }
                    let data = try Data(contentsOf: url)
                    let avatar = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.avatar.image = avatar
                        cell.avatar.layer.cornerRadius = cell.avatar.frame.size.width / 2
                        cell.avatar.clipsToBounds = true
                        cell.avatar.contentMode = .scaleAspectFill
                        cell.avatar.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
                        cell.avatar.layer.borderWidth = 0.3
                        cell.avatar.translatesAutoresizingMaskIntoConstraints = false
                    }
                } catch {
                    print(error)
                }
            }.resume()
        }
        return cell
    }
}

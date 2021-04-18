//
//  ProfileTableController.swift
//  VKtest
//
//  Created by Микаэл Мартиросян on 08.02.2021.
//

import UIKit
import RealmSwift
import FirebaseAuth

class ProfileTableController: UITableViewController {
    
    private var friendsCount: Int?
    private var users: Results<UsersGetResults>?
    let usersNetworkService = UsersNetworkService()
    let friendsNetworkService = FriendsNetworkService()
    var count = 0
            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        loadData()
        
        friendsNetworkService.get { [weak self] count in
            self?.friendsCount = count
            self?.tableView.reloadData()
        }
        
        usersNetworkService.get()
    }
    
    @IBAction func logOut(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
        } catch (let error) {
            print(error)
        }
    }
    
    func loadData() {
        do {
            let realm = try Realm()
            let results = realm.objects(UsersGetResults.self)
            print(results)
            users = results
            print(users)
            tableView.reloadData()
        } catch {
            print(error)
        }
    }
    
    func addTitle(_ title: String) {
        navigationItem.title = title
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch section {
//        case 0:
//            return 1
//        case 1:
//            return 1
//        case 2:
//            return 1
//        default:
//            return 1
//        }
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        switch indexPath.row {
//        case 0:
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: EnumReuseIdentifiers.profileHeaderCell.rawValue, for: indexPath) as? ProfileHeaderCell else { fatalError() }
//
//            cell.nameLabel.text = "Max"
//            cell.avatar.image = UIImage(systemName: "person")
//
//            return cell
//        case 1:
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: EnumReuseIdentifiers.profileInfoCell.rawValue, for: indexPath) as? ProfileInfoCell else { fatalError() }
//
//            cell.cityLabel.text = "Moscow"
//            cell.bdLabel.text = "7.04.1993"
//            cell.sexLabel.text = "male"
//
//            return cell
//        case 2:
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: EnumReuseIdentifiers.profileFriendsCell.rawValue, for: indexPath) as? ProfileFriendsCell else { fatalError() }
//
//            cell.friendsCount.text = "162"
//
//            return cell
//        default:
//            return UITableViewCell()
//        }
        
        guard let screenName = users?[indexPath.row].screenName else { fatalError() }

        addTitle(screenName)

        switch indexPath.row {

        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EnumReuseIdentifiers.profileHeaderCell.rawValue, for: indexPath) as? ProfileHeaderCell else {fatalError("Unable to creare explore table view cell")}

            cell.nameLabel.text = users?[indexPath.row].fullName

            let session = URLSession.shared
            if let url = URL(string: users?[indexPath.row].photo100 ?? "") {
                session.downloadTask(with: url) { (url, _, error) in
                    do {
                        guard let url = url else { return }
                        let data = try Data(contentsOf: url)
                        let avatar = UIImage(data: data)
                        DispatchQueue.main.async {
                            cell.avatar.image = avatar
                        }
                    } catch {
                        print(error)
                    }
                }.resume()
            }

            return cell

        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EnumReuseIdentifiers.profileInfoCell.rawValue, for: indexPath) as? ProfileInfoCell else { fatalError("Unable to creare explore table view cell") }

            cell.cityLabel.text = "Город: New York"
            cell.bdLabel.text = "День рождения: \(String(users?[indexPath.row].bdate ?? ""))"

            switch users?[indexPath.row].sex {
            case 0:
                cell.sexLabel.text = "Пол: не указан"
            case 1:
                cell.sexLabel.text = "Пол: женский"
            case 2:
                cell.sexLabel.text = "Пол: мужской"
            default:
                cell.sexLabel.text = "Пол:"
            }

            return cell

        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EnumReuseIdentifiers.profileFriendsCell.rawValue, for: indexPath) as? ProfileFriendsCell else { fatalError("Unable to creare explore table view cell") }

            cell.friendsCount.text = String(friendsCount ?? 0)

            return cell

        default:
            return UITableViewCell()
        }
    }
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 2:
            return 125
        default:
            return 125
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//
//  UserGroupsController.swift
//  VKtest
//
//  Created by Микаэл Мартиросян on 19.11.2020.
//

import UIKit
import RealmSwift

class UserGroupsController: UITableViewController {
    
    private var userGroups: Results<GroupsGet>?
//    private let networkService = NetworkService()
    private var token: NotificationToken?
    
    let groupsNetworkService = GroupsNetworkService()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        navigationItem.title = "Мои группы"
        navigationController?.navigationBar.prefersLargeTitles = true
                
        loadData()
        realmNotifications()
        
        groupsNetworkService.get()
        
//        networkService.groupsGet()
    }
    
    func loadData() {
        do {
            let realm = try Realm()
            let results = realm.objects(GroupsGet.self)
            userGroups = results
            tableView.reloadData()
        } catch {
            print(error)
        }
    }
    
    func realmNotifications() {
        guard let realm = try? Realm() else { return }
        token = realm.objects(GroupsGet.self).observe({ [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial(_):
                tableView.reloadData()
            case let .update(_, deletions, insertions, modifications):
                tableView.beginUpdates()
                
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
                
                tableView.endUpdates()
            case .error(let error):
                print(error)
            }
        })
    }
    
    @IBAction func unwindToMyGroupsController(_ unwindSegue: UIStoryboardSegue) {
        if unwindSegue.identifier == EnumUnwindSegueIdentifiers.addNewGroup.rawValue {
            guard let sourceViewController = unwindSegue.source as? SearchGroupsController else { return }
            if let indexPath = sourceViewController.tableView.indexPathForSelectedRow {
                let newGroup = sourceViewController.searchGroups[indexPath.row]
                
                if newGroup.isMember == 0 {
                    do {
                        let realm = try Realm()
                        realm.beginWrite()
                        realm.add(newGroup, update: .modified)
                        try realm.commitWrite()
                    } catch {
                        print(error)
                    }
                    groupsNetworkService.join(groupId: newGroup.id)
                } else {
                    print("Add group error")
                }
            }
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userGroups?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EnumReuseIdentifiers.userGroupsCell.rawValue, for: indexPath) as? GroupsCell else {fatalError("Unable to creare explore table view cell")}
        
        let index = userGroups?[indexPath.row]
        
        cell.nameLabel.text = index?.name ?? ""
        
        let session = URLSession.shared
        if let avatarUrl = URL(string: index?.photo50 ?? "") {
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
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let group = userGroups?[indexPath.row] else { return }
        if editingStyle == .delete {
            groupsNetworkService.leave(groupId: group.id)
            do {
                let realm = try Realm()
                realm.beginWrite()
                realm.delete(group)
                try realm.commitWrite()
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

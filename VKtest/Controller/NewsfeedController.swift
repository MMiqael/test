//
//  NewsfeedController.swift
//  VKtest
//
//  Created by Микаэл Мартиросян on 28.11.2020.
//

import UIKit
import RealmSwift

class NewsfeedController: UITableViewController {
    
    var news: Results<NewsfeedGetItems>?
    let newsfeedNetworkService = NewsfeedNetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        navigationItem.title = "Новости"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        loadData()
        
        newsfeedNetworkService.get()
    }
    
    func loadData() {
        do {
            let realm = try Realm()
            let results = realm.objects(NewsfeedGetItems.self)
            print(results)
            news = results
            tableView.reloadData()
        } catch {
            print(error)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EnumReuseIdentifiers.newsFeedCell.rawValue, for: indexPath) as? NewsfeedCell else {fatalError("Unable to creare explore table view cell")}
        
        cell.avatar.image = UIImage(systemName: "person")
        cell.avatar.layer.cornerRadius = cell.avatar.frame.size.width / 2
        cell.avatar.clipsToBounds = true
        cell.avatar.contentMode = .scaleAspectFill
        cell.avatar.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
        cell.avatar.layer.borderWidth = 0.3
        cell.avatar.translatesAutoresizingMaskIntoConstraints = false
        
        cell.nameLabel.text = "Max"
        cell.timeLabel.text = "5 hours ago"
        
        cell.messageLabel.text = "Hello World!"
        cell.pictureImageView.image = UIImage(systemName: "person")
        
        cell.backgroundColor = .systemBackground
        cell.separatorView.backgroundColor = .systemGray5
        
//        cell.avatarView.avatar.image = UIImage(named: news[indexPath.row].avatar)
//        cell.nameLabel.text = news[indexPath.row].name
//        cell.timeLabel.text = news[indexPath.row].time
//        cell.messageLabel.text = news[indexPath.row].message
//        cell.pictureImageView.image = UIImage(named: news[indexPath.row].picture)
//        cell.backgroundColor = .systemBackground
//        cell.separatorView.backgroundColor = .systemGray5

        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Extension

//extension NewsFeedController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 1
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EnumReuseIdentifiers.newsImageCell.rawValue, for: indexPath) as! NewsImageCell
//        
//        cell.pictureImageView.image = UIImage(named: news[indexPath.row].picture)
//        
//        return cell
//    }
//    
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        let frameCV = collectionView.frame
//        let widthCell = frameCV.width
//        
//        let image = UIImage(named: news[indexPath.row].picture)
//        let widthImage = image!.size.width
//        let heightImage = image!.size.height
//        
//        func resize(_ widthCell: CGFloat, _ widthImage: CGFloat, _ heightImage: CGFloat) -> CGFloat {
//            let widthDifference = widthImage / widthCell
//            let heightCell = heightImage / widthDifference
//            return heightCell
//        }
//        
//        let heightCell = resize(widthCell, widthImage, heightImage)
//        
//        return CGSize(width: widthCell, height: heightCell)
//    }
//}

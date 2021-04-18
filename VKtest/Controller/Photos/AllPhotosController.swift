//
//  AllPhotosController.swift
//  VKtest
//
//  Created by Микаэл Мартиросян on 19.11.2020.
//

import UIKit
import RealmSwift

class AllPhotosController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
        
    var allPhotos: Results<PhotosGetAllItems>?
    let photosNetworkService = PhotosNetworkService()
    var ownerId = 0
    var token: NotificationToken?
            
//    var photoControllerDelegate: PhotoController?
        
    override func viewDidLoad() {
        super.viewDidLoad()
                
        loadData()
        realmNotification()
        
        photosNetworkService.getAll(ownerId: ownerId)
    }
    
    func loadData() {
        do {
            let realm = try Realm()
            let results = realm.objects(PhotosGetAllItems.self)
            allPhotos = results
            collectionView.reloadData()
        } catch {
            print(error)
        }
    }
    
    func realmNotification() {
        guard let realm = try? Realm() else { return }
        token = realm.objects(PhotosGetAllItems.self).observe({ [weak self] (change: RealmCollectionChange) in
            guard let collectionView = self?.collectionView else { return }
            switch change {
            
            case .initial(_):
                collectionView.reloadData()
            case let .update(_, deletions, insertions, modifications):
                collectionView.performBatchUpdates({
                    collectionView.deleteItems(at: deletions.map({ IndexPath(item: $0, section: 0) }))
                    collectionView.insertItems(at: insertions.map({ IndexPath(item: $0, section: 0)}))
                    collectionView.reloadItems(at: modifications.map({ IndexPath(item: $0, section: 0)}))
                }, completion: nil)
            case .error(let error):
                print(error)
            }
        })
    }

    
    // MARK: - Navigation

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard segue.identifier == EnumSegueIdentifiers.photoSegue.rawValue else { return }
//        guard let vc = segue.destination as? LargeSizePhotoController else { return }
//        if let _ = collectionView.indexPathsForSelectedItems {
//            vc.largeSizePhotos = allPhotos
//        }
//    }
    
    
    // MARK: - UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPhotos?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EnumReuseIdentifiers.albumCell.rawValue, for: indexPath) as? AllPhotosCell else {fatalError("Unable to creare explore collection view cell")}
        
        let index = allPhotos?[indexPath.item]
                
        let session = URLSession.shared
        if let photoUrl = URL(string: index?.url ?? "") {
            session.downloadTask(with: photoUrl) { (url, _, error) in
                do {
                    guard let url = url else { return }
                    let data = try Data(contentsOf: url)
                    let photo = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.photoImageView.image = photo
                    }
                } catch {
                    print(error)
                }
            }.resume()
        }
        return cell
    }
    
    // Переход на выбранное фото
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        photoControllerDelegate?.indexPath = indexPath
//        
//    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let countCells = 3
        let width = (Int(collectionView.frame.width) - 5) / countCells
        return CGSize(width: width, height: width)
    }
}

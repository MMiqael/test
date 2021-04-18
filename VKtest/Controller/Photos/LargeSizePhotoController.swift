//
//  LargeSizePhotoController.swift
//  VKtest
//
//  Created by Микаэл Мартиросян on 30.11.2020.
//

import UIKit

class LargeSizePhotoController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var largeSizePhotos = [PhotosGetAllItems]()
    let r = PhotosNetworkService()
//    var id = 0
    var delegate: UIImage?
    
    //    var indexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipe(sender:)))
        view.addGestureRecognizer(swipeGestureRecognizer)
        
        // Переход на выбранное фото
        //        collectionView.performBatchUpdates(nil) { (result) in
        ////            guard let index = self.indexPath else {return}
        //            self.collectionView.scrollToItem(at: self.indexPath, at: .centeredHorizontally, animated: false)
        //    }
        
//        networkService.getLargeSizePhotos(/*id: id*/) { [weak self] photo in
//            self?.largeSizePhotos = photo
//            self?.collectionView.reloadData()
//        }
    }
    
    
    
    
    @objc func swipe(sender: UISwipeGestureRecognizer) {
        print("swipe")
    }
    
    
    
    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return largeSizePhotos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EnumReuseIdentifiers.photoCell.rawValue, for: indexPath) as? LargeSizePhotoCell else {fatalError("Unable to creare explore collection view cell")}
        
        let index = largeSizePhotos[indexPath.item]
        
        let session = URLSession.shared
        if let photoUrl = URL(string: index.url) {
            session.downloadTask(with: photoUrl) { (url, _, error) in
                guard let url = url else { return }
                do {
                    let data = try Data(contentsOf: url)
                    let photo = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.photoImageView.image = photo
                        self.delegate = photo
                    }
                } catch {
                    print(error)
                }
            }
        }
        return cell
    }
    
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//                
//        let frameCV = collectionView.frame
//        let widthCell = frameCV.width
//        
//        if let image = delegate {
//        let widthImage = image.size.width
//        let heightImage = image.size.height
//        }
//        
//        func resize(_ widthCell: CGFloat, _ widthImage: CGFloat, _ heightImage: CGFloat) -> CGFloat {
//            let widthDifference = widthImage / widthCell
//            let heightCell = heightImage / widthDifference
//            return heightCell
//        }
//        
//        let heightCell = resize(widthCell, widthImage, heightImage)
//        
//        
//        return CGSize(width: widthCell, height: heightCell)
//    }
}

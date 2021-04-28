//
//  PhotoCollectionController.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 11.12.2020.
//  Copyright © 2020 Yuriy Fedyunkin. All rights reserved.
//

import UIKit

class PhotoCollectionController: UICollectionViewController {
    
    var photoLibrary = [Photo]()
    var currentUser: User?
    private let gradient = GradientView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        if let user = currentUser {
            NetworkManager.shared.getPhotosVK(owener: user) { [weak self] photos in
                DispatchQueue.main.async {
                    self?.addToPhotosRealm(photos: photos)
                    self?.readPhotoRealm()
                }
            }
        }
        
        gradient.setupGeneralGradientView(for: self.collectionView)
    }
    
    // MARK: - Методы добавления фото друзей в Realm и закрузка из Realm
    
    private func addToPhotosRealm(photos: [Photo]) {
        guard let user = currentUser else {return}
        UsersDB.shared.writePhotos(photos, user: user)
    }
    
    private func readPhotoRealm() {
        guard let user = currentUser else {return}
        photoLibrary = Array(user.photos)
        collectionView.reloadData()
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return photoLibrary.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCollectionCell
        cell.configure(withPhoto: photoLibrary[indexPath.row])
        
        return cell
    }
    
    // MARK:- UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let swipeVC = self.storyboard?.instantiateViewController(withIdentifier: "SwipeMode") as? PhotoSwipeController else { return }
        
        swipeVC.currentImage = indexPath.item
        swipeVC.photoLibrary = self.photoLibrary
        
        navigationController?.pushViewController(swipeVC, animated: true)
        
    }
    
}

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = currentUser {
            NetworkManager.shared.getPhotosVK(owener: user) { [weak self] photos in
                DispatchQueue.main.async {
                    self?.photoLibrary = photos
                    self?.collectionView.reloadData()
                }
            }
        }
        
        
        let gradient = GradientView()
        gradient.setupGradient(startColor: .blue, endColor: .systemGray, startLocation: 0, endLocation: 1, startPoint: .zero, endPoint: CGPoint(x:0, y: 1))
        
        gradient.alpha = 0.6
        collectionView.backgroundView = gradient
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

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

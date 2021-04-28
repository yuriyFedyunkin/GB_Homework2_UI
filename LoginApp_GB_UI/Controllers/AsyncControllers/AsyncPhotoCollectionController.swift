//
//  AsyncPhotoCollectionController.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 27.04.2021.
//  Copyright © 2021 Yuriy Fedyunkin. All rights reserved.
//

import AsyncDisplayKit

class AsyncPhotoCollectionController: ASDKViewController<ASCollectionNode>, ASCollectionDataSource, ASCollectionDelegate {
    
//    private let gradient = GradientView()
    var photos = [Photo]()
    var userId: String?
    var albumId: String?
    private var photoService: PhotoService?
    let flowLayout = UICollectionViewFlowLayout()
    
    var collectionNode: ASCollectionNode {
        return node
    }
    
    override init() {
        super.init(node: ASCollectionNode(collectionViewLayout: flowLayout))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionNode.delegate = self
        self.collectionNode.dataSource = self
        self.collectionNode.backgroundColor = UIColor(red: 121/255.0,
                                                      green: 121/255.0,
                                                      blue: 232/255.0,
                                                      alpha: 1.0)
//        gradient.setupGeneralGradientView(for: self.collectionNode.view)
        photoService = PhotoService(container: collectionNode.view)
        getPhotoRequest()
        
    }
    private func getPhotoRequest() {
        if let user = userId,
           let album = albumId {
            NetworkManager.shared.getPhotoFromAlbumVK(ownerId: user, albumId: album) { [weak self] photos in
                DispatchQueue.main.async {
                    self?.photos = photos
                    self?.collectionNode.reloadData()
                }
            }
        }
    }
    
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        guard photos.count > indexPath.row else { return { ASCellNode() } }
        let photo = photos[indexPath.row]
        let photoURL = photo.url
        let likesCount = photo.likes
        
        let cellNodeBlock = { [weak self] () -> ASCellNode in
            guard let self = self else { return ASCellNode() }
            let photoImage = self.photoService?.photo(atIndexpath: indexPath, byUrl: photoURL)
            let node = AsyncPhotoCollectionCell(photo: photoImage ?? UIImage(), likes: likesCount)
            return node
        }
        return cellNodeBlock
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        let swipeVC = PhotoSwipeController()
        swipeVC.currentImage = indexPath.row
        swipeVC.photoLibrary = self.photos
        
        navigationController?.pushViewController(swipeVC, animated: true)
    }
    
    
}




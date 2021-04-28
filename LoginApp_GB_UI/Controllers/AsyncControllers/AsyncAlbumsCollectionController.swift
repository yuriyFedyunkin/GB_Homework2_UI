//
//  AsyncAlbumsCollectionController.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 27.04.2021.
//  Copyright © 2021 Yuriy Fedyunkin. All rights reserved.
//

import AsyncDisplayKit

class AsyncAlbumsCollectionController: ASDKViewController<ASCollectionNode>, ASCollectionDataSource, ASCollectionDelegate {
    
//    private let gradient = GradientView()
    var albums = [Album]()
    var currentUser: User?
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
        
        if let user = currentUser {
            NetworkManager.shared.getUserAlbumsVK(owner: user) { [weak self] albums in
                DispatchQueue.main.async {
                    self?.albums = albums
                    self?.collectionNode.reloadData()
                }
            }
        }
    }
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        albums.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        guard albums.count > indexPath.row else { return { ASCellNode() } }
        let album = albums[indexPath.row]
        let coverURL = album.coverURL
        let photosCount = album.size
        let title = album.title
        
        let cellNodeBlock = { [weak self] () -> ASCellNode in
            guard let self = self else { return ASCellNode() }
            let albumCover = self.photoService?.photo(atIndexpath: indexPath, byUrl: coverURL)
            let node = AsyncAlbumsCollectionCell(cover: albumCover ?? UIImage(),
                                                 photosCount: photosCount,
                                                 title: title)
            return node
        }
        return cellNodeBlock
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        
        let destVC = AsyncPhotoCollectionController()
        let album = albums[indexPath.row]
        
        destVC.photos = Array(album.photos)
        destVC.albumId = String(album.id)
        destVC.userId = String(album.ownerId)
        
        destVC.navigationItem.title = album.title
        navigationController?.pushViewController(destVC, animated: true)    
    }
    
    // MARK: - Методы добавления альбомов друзей в Realm и загрузка из Realm
 /*
    private func addToAlbumsRealm(albums: [Album]) {
        guard let user = currentUser else {return}
        UsersDB.shared.wtiteAlbums(albums, user: user)
    }
    
    private func readAlbumsRealm() {
        guard let user = currentUser else {return}
        albums = UsersDB.shared.readAlbums(user: user)
        collectionNode.reloadData()
    }
  */
}


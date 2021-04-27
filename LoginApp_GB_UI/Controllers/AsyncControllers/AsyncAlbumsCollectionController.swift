//
//  AsyncAlbumsCollectionController.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 27.04.2021.
//  Copyright © 2021 Yuriy Fedyunkin. All rights reserved.
//

import AsyncDisplayKit

class AsyncPhotoCollectionController: ASDKViewController<ASCollectionNode>, ASCollectionDataSource, ASCollectionDelegate {
    
    private let gradient = GradientView()
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
        gradient.setupGeneralGradientView(for: self.collectionNode.view)
        photoService = PhotoService(container: collectionNode.view)
        
        if let user = currentUser {
            NetworkManager.shared.getUserAlbumsVK(owner: user) { [weak self] albums in
                DispatchQueue.main.async {
                    self?.addToAlbumsRealm(albums: albums)
                    self?.readAlbumsRealm()
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
    
    // MARK: - Методы добавления альбомов друзей в Realm и загрузка из Realm
    
    private func addToAlbumsRealm(albums: [Album]) {
        guard let user = currentUser else {return}
        UsersDB.shared.wtiteAlbums(albums, user: user)
    }
    
    private func readAlbumsRealm() {
        guard let user = currentUser else {return}
        albums = UsersDB.shared.readAlbums(user: user)
        collectionNode.reloadData()
    }
    
}


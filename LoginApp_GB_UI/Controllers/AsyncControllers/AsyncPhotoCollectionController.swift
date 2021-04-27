//
//  AsyncPhotoCollectionController.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 27.04.2021.
//  Copyright © 2021 Yuriy Fedyunkin. All rights reserved.
//

import AsyncDisplayKit
/*
class AsyncPhotoCollectionController: ASDKViewController<ASCollectionNode>, ASCollectionDataSource, ASCollectionDelegate {
    
    private let gradient = GradientView()
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
        gradient.setupGeneralGradientView(for: self.collectionNode.view)
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
}
*/

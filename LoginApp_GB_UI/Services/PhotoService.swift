//
//  PhotoService.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 10.04.2021.
//  Copyright © 2021 Yuriy Fedyunkin. All rights reserved.
//

import Foundation
import Alamofire

class PhotoService {
    
    private static let cacheLifeTime: TimeInterval = 5 * 24 * 60 * 60
    private static let pathName: String = {
        
        let pathName = "images"
        
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return pathName }
        let url = cachesDirectory.appendingPathComponent(pathName, isDirectory: true)
        
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        
        return pathName
    }()
    
    private func getFilePath(url: String) -> String? {
        
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        
        let hashName = url.split(separator: "/").last ?? "default"
        return cachesDirectory.appendingPathComponent(PhotoService.pathName + "/" + hashName).path
    }
    
    private func saveImageToCache(url: String, image: UIImage) {
        guard let fileName = getFilePath(url: url),
        let data = image.pngData() else { return }
        FileManager.default.createFile(atPath: fileName, contents: data, attributes: nil)
    }
    
    private class func isFileOld(path: String) -> Bool {
        guard
            let info = try? FileManager.default.attributesOfItem(atPath: path),
            let modificationDate = info[FileAttributeKey.modificationDate] as? Date
        else { return true }
        
        let lifeTime = Date().timeIntervalSince(modificationDate)
        
        return lifeTime > cacheLifeTime
    }
    
    private func getImageFromCache(url: String) -> UIImage? {
        guard
            let fileName = getFilePath(url: url),
            !PhotoService.isFileOld(path: url),
            let image = UIImage(contentsOfFile: fileName) else { return nil }
        
        DispatchQueue.main.async { [weak self] in
            self?.images[url] = image
        }
        return image
    }

    private var images = [String: UIImage]()
    
    private func loadPhoto(atIndexpath indexPath: IndexPath, byUrl url: String) {
        AF.request(url).responseData(queue: DispatchQueue.global()) { [weak self] response in
            guard
                let data = response.data,
                let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async { [weak self] in
                self?.images[url] = image
            }
            self?.saveImageToCache(url: url, image: image)
            DispatchQueue.main.async { [weak self] in
                self?.container.reloadRow(atIndexpath: indexPath)
            }
            
        }
    }

    func photo(atIndexpath indexPath: IndexPath, byUrl url: String) -> UIImage? {
        var image: UIImage?
        if let photo = images[url] {
            image = photo
        } else if let photo = getImageFromCache(url: url) {
            image = photo
        } else {
            loadPhoto(atIndexpath: indexPath, byUrl: url)
        }
        return image
    }
    
    private class func getImageFolderPath() -> String? {
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        return cachesDirectory.appendingPathComponent(PhotoService.pathName).path
    }
    
    class func clearOldCache() throws {
        guard let imageFolderPath = getImageFolderPath() else { return }
        let cachedImages = try FileManager.default.contentsOfDirectory(atPath: imageFolderPath)
        for cachedImagePath in cachedImages {
            let imagePath = imageFolderPath + "/" + cachedImagePath
            if isFileOld(path: imagePath) {
                try FileManager.default.removeItem(atPath: imagePath)
            }
        }
    }
    
    private let container: DataReloadable
    
    init(container: UITableView) {
        self.container = Table(table: container)
    }
    
    init(container: UICollectionView) {
        self.container = Collection(collection: container)
    }
    
        
}

fileprivate protocol DataReloadable {
    func reloadRow(atIndexpath indexPath: IndexPath)
}

extension PhotoService {
    
    private class Table: DataReloadable {
        let table: UITableView
        
        init(table: UITableView) {
            self.table = table
        }
        
        func reloadRow(atIndexpath indexPath: IndexPath) {
            table.reloadRows(at: [indexPath], with: .none)
        }
        
    }
    
    private class Collection: DataReloadable {
        let collection: UICollectionView
        
        init(collection: UICollectionView) {
            self.collection = collection
        }
        
        func reloadRow(atIndexpath indexPath: IndexPath) {
            collection.reloadItems(at: [indexPath])
        }
    }
}

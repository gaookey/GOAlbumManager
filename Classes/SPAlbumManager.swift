//
//  SPAlbumManager.swift
//  SPAlbumManager
//
//  Created by 高文立 on 2021/4/13.
//

import UIKit
import Photos

@objcMembers class SPAlbumManager {
    
    @objc public enum MediaType: Int {
        case image
        case livePhoto
        case imageAndLivePhoto
        case video
        case audio
        case videoAndAudio
        case all
    }
    
    public var mediaType = MediaType.image
    public var albums = [SPAlbum]()
    
    static let shared = SPAlbumManager()
    
    private init() { }
}

extension SPAlbumManager {
    
    public func requestAlbum(completionHandler: ((_ albums: [SPAlbum]) -> ())?) {
        SPPremissionManager.shared.album { (state) in
            if state == .unauthorized {
                completionHandler?(self.albums)
                return
            }
            
            DispatchQueue(label: "com.swiftprimer.queue.album").async {
                self.albums = self.getAllAlbums()
                DispatchQueue.main.async {
                    completionHandler?(self.albums)
                }
            }
        }
    }
    
    private func getAllAlbums() -> [SPAlbum] {
        let results: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: PHFetchOptions())
        
        for index in 0..<results.count {
            let collection = results.object(at: index)
            let album = SPAlbum(collection: collection, type: mediaType)
            
            if album.items.count > 0 && collection.assetCollectionSubtype.rawValue != 1000000201 {
                albums.append(album)
            }
        }
        
        return albums.sorted { (obj1, obj2) -> Bool in
            return obj1.items.count > obj2.items.count
        }
    }
}

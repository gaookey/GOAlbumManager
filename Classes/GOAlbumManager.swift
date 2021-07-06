//
//  GOAlbumManager.swift
//  GOAlbumManager
//
//  Created by 高文立 on 2021/4/13.
//

import UIKit
import Photos

public class GOAlbumManager {
    
    public enum MediaType: Int {
        case image
        case livePhoto
        case imageAndLivePhoto
        case video
        case audio
        case videoAndAudio
        case all
    }
    
    public var mediaType = MediaType.image
    public var albums = [GOAlbum]()
    
    static public let shared = GOAlbumManager()
    
    private init() { }
}

extension GOAlbumManager {
    
    public func requestAlbum(completionHandler: ((_ albums: [GOAlbum]) -> ())?) {
        GOPremissionManager.shared.album { (state) in
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
    
    private func getAllAlbums() -> [GOAlbum] {
        let results: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: PHFetchOptions())
        
        for index in 0..<results.count {
            let collection = results.object(at: index)
            let album = GOAlbum(collection: collection, type: mediaType)
            
            if album.items.count > 0 && collection.assetCollectionSubtype.rawValue != 1000000201 {
                albums.append(album)
            }
        }
        
        return albums.sorted { (obj1, obj2) -> Bool in
            return obj1.items.count > obj2.items.count
        }
    }
}

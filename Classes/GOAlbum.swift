//
//  GOAlbum.swift
//  GOAlbumManager
//
//  Created by 高文立 on 2021/4/13.
//

import UIKit
import Photos

public class GOAlbum: NSObject {
    
    public var collection = PHAssetCollection()
    public var type = GOAlbumManager.MediaType.image
    
    public var items = [GOAlbumItem]()
    
    public var thumbItem: GOAlbumItem? {
        get {
            return items.first
        }
    }
    
    public convenience init(collection: PHAssetCollection, type: GOAlbumManager.MediaType) {
        self.init()
        
        self.collection = collection
        self.type = type
        
        fetchItems()
    }
    
    private func fetchItems() {
        let results: PHFetchResult<PHAsset> = PHAsset.fetchAssets(in: collection, options: PHFetchOptions())
        guard results.count > 0 else { return }
        
        for index in 0..<results.count {
            let asset: PHAsset = results.object(at: index)
            
            if type == .image {
                if asset.mediaType == .image {
                    items.append(GOAlbumItem(asset: asset))
                }
            } else if type == .livePhoto {
                if asset.mediaSubtypes == .photoLive {
                    items.append(GOAlbumItem(asset: asset))
                }
            } else if type == .imageAndLivePhoto {
                if asset.mediaType == .image || asset.mediaSubtypes == .photoLive {
                    items.append(GOAlbumItem(asset: asset))
                }
            } else if type == .video {
                if asset.mediaType == .video {
                    items.append(GOAlbumItem(asset: asset))
                }
            } else if type == .audio {
                if asset.mediaType == .audio {
                    items.append(GOAlbumItem(asset: asset))
                }
            } else if type == .videoAndAudio {
                if asset.mediaType == .video || asset.mediaType == .audio {
                    items.append(GOAlbumItem(asset: asset))
                }
            } else {
                items.append(GOAlbumItem(asset: asset))
            }
        }
        
        items = items.reversed()
    }
}

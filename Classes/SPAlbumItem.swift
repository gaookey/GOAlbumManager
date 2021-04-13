//
//  SPAlbumItem.swift
//  SPAlbumManager
//
//  Created by 高文立 on 2021/4/13.
//

import UIKit
import Photos

public class SPAlbumItem: NSObject {
    
    public var requestId: PHImageRequestID = 0
    public var asset = PHAsset()
    
    public convenience init(asset: PHAsset) {
        self.init()
        self.asset = asset
    }
}

extension SPAlbumItem {
    
    public func fullSizeImageURL(completionHandler: ((_ url: URL?, _ isInCloud: Bool) -> ())?) {
        self.asset.requestContentEditingInput(with: PHContentEditingInputRequestOptions()) {[weak self] (input, info) in
            guard let weakSelf = self else { return }
            completionHandler?(input?.fullSizeImageURL, weakSelf.isInCloud(info: info))
        }
    }
    
    public func image(completionHandler: ((_ image: UIImage?, _ isInCloud: Bool) -> ())?) {
        image(option: SPAlbumOptions.shared.imageOptions, completionHandler: completionHandler)
    }
    
    public func thumbImage(size: CGSize, completionHandler: ((_ image: UIImage?, _ isInCloud: Bool) -> ())?) {
        image(size: CGSize(width: size.width * UIScreen.main.scale, height: size.height * UIScreen.main.scale), option: SPAlbumOptions.shared.imageOptions, completionHandler: completionHandler)
    }
    
    public func thumbVideo(size: CGSize, completionHandler: ((_ image: UIImage?, _ isInCloud: Bool) -> ())?) {
        thumbImage(size: size, completionHandler: completionHandler)
    }
    
    public func imageData(completionHandler: ((_ data: Data?, _ isInCloud: Bool) -> ())?) {
        if #available(iOS 13, *) {
            requestId = SPAlbumOptions.shared.manager.requestImageDataAndOrientation(for: asset, options: SPAlbumOptions.shared.imageOptions) {[weak self] (data, string, orientation, info) in
                DispatchQueue.main.async {
                    guard let weakSelf = self else { return }
                    completionHandler?(data, weakSelf.isInCloud(info: info))
                }
            }
        } else {
            requestId = SPAlbumOptions.shared.manager.requestImageData(for: asset, options: SPAlbumOptions.shared.imageOptions) {[weak self] (data, string, orientation, info) in
                DispatchQueue.main.async {
                    guard let weakSelf = self else { return }
                    completionHandler?(data, weakSelf.isInCloud(info: info))
                }
            }
        }
    }
    
    public func videoAsset(completionHandler: ((_ asset: AVAsset?, _ audioMix: AVAudioMix?, _ isInCloud: Bool) -> ())?) {
        SPAlbumOptions.shared.manager.requestAVAsset(forVideo: asset, options: SPAlbumOptions.shared.videoOptions) {[weak self] (asset, audioMix, info) in
            DispatchQueue.main.async {
                guard let weakSelf = self else { return }
                completionHandler?(asset, audioMix, weakSelf.isInCloud(info: info))
            }
        }
    }
    
    public func videoPlayerItem(completionHandler: ((_ item: AVPlayerItem?, _ isInCloud: Bool) -> ())?) {
        SPAlbumOptions.shared.manager.requestPlayerItem(forVideo: asset, options: SPAlbumOptions.shared.videoOptions) {[weak self] (item, info) in
            DispatchQueue.main.async {
                guard let weakSelf = self else { return }
                completionHandler?(item, weakSelf.isInCloud(info: info))
            }
        }
    }
    
    public func livePhoto(completionHandler: ((_ livePhoto: PHLivePhoto?, _ isInCloud: Bool) -> ())?) {
        SPAlbumOptions.shared.manager.requestLivePhoto(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .default, options: SPAlbumOptions.shared.livePhotoOptions) {[weak self] (livePhoto, info) in
            DispatchQueue.main.async {
                guard let weakSelf = self else { return }
                completionHandler?(livePhoto, weakSelf.isInCloud(info: info))
            }
        }
    }
}

extension SPAlbumItem {
    
    private func image(size: CGSize = PHImageManagerMaximumSize, option: PHImageRequestOptions, completionHandler: ((_ image: UIImage?, _ isInCloud: Bool) -> ())?) {
        requestId = SPAlbumOptions.shared.manager.requestImage(for: asset, targetSize: size, contentMode: .default, options: option, resultHandler: { (image, info) in
            DispatchQueue.main.async {
                completionHandler?(image, self.isInCloud(info: info))
            }
        })
    }
    
    private func isInCloud(info: [AnyHashable : Any]?) -> Bool {
        guard let i = info, let isInCloud: Bool = i[PHImageResultIsInCloudKey] as? Bool else { return false }
        return isInCloud
    }
}

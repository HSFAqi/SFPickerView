//
//  SFPhotosCollectionView.swift
//  SFPickerView_Example
//
//  Created by 黄山锋 on 2020/2/9.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import Photos

public enum SFPhotosMediaType {
    case onlyImage
    case onlyVideo
    case imageAndVideo
}
public enum SFPhotosSelectMode {
    case single
    case mul
}

public class SFPhotosCollectionView: SFBaseCollectionView {
    
    // MARK: - Property(private)
    private var isGranted: Bool = false
    private var photoModels = [SFPhotoModel]()
    private var mediaType: SFPhotosMediaType = .onlyImage
    private var selectMode: SFPhotosSelectMode = .single

    // MARK: - ConfigUI
    override func configUI() {
        super.configUI()
        self.config.alertViewHeight = 0.9 * UIScreen.main.bounds.height
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                [weak self] (firstStatus) in
                if firstStatus == .authorized {
                    self?.isGranted = true
                } else {
                    self?.isGranted = false
                    self?.showGrantAlert()
                }
            })
            break
        case .restricted:
            self.isGranted = false
            showGrantAlert()
            break
        case .denied:
            self.isGranted = false
            showGrantAlert()
            break
        case .authorized:
            self.isGranted = true
            break
        @unknown default:
            print("系统预留值")
            showGrantAlert()
            break
        }
            
    }
    
    /// 授权提示
    private func showGrantAlert() {
        SFAlertView.showAlert(title: "访问失败", message: "请授权相册权限", sureTitle: "好的") { (action) in
            let url = URL.init(string: UIApplication.openSettingsURLString)
            if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.openURL(url!)
            }
        }
    }
    
    // MARK: - 获取相册数据
    func getAllPhotoModelsFromSysytem() {
        DispatchQueue.global().async {
            var models = [SFPhotoModel]()
            let options = PHFetchOptions.init()
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)] //时间排序
            switch self.mediaType {
            case .onlyImage:
                options.predicate = NSPredicate.init(format: "mediaType == %ld", PHAssetMediaType.image.rawValue)
                break
            case .onlyVideo:
                options.predicate = NSPredicate.init(format: "mediaType == %ld", PHAssetMediaType.video.rawValue)
                break
            case .imageAndVideo:
                break
            }
            let assetsFetchResults: PHFetchResult = PHAsset.fetchAssets(with: options)
            assetsFetchResults.enumerateObjects { (asset, index, stop) in
                let model = SFPhotoModel()
                model.asset = asset
                models.append(model)
            }
            self.photoModels = models
            DispatchQueue.main.async {
                self.updateWithDataSource(self.photoModels)
            }
        }
    }
    
    /// 【Photos】类方法
    /// - Parameters:
    ///   - title: 标题
    ///   - config: 配置
    ///   - callback: 回调
    @discardableResult
    public final class func showPhotosCollectionWithTitle(_ title: String?, mediaType: SFPhotosMediaType, selectMode: SFPhotosSelectMode, config: SFConfig?, callback: @escaping ((SFPhotoModel?) -> Void)) -> SFPhotosCollectionView{
        let collectionView = SFPhotosCollectionView(frame: CGRect.zero)
        collectionView.showPhotosCollectionWithTitle(title, mediaType: mediaType, selectMode: selectMode, config: config, callback: callback)
        return collectionView
    }
    
    /// 【Photos】对象方法
    /// - Parameters:
    ///   - title: 标题
    ///   - config: 配置
    ///   - callback: 回调
    public final func showPhotosCollectionWithTitle(_ title: String?, mediaType: SFPhotosMediaType, selectMode: SFPhotosSelectMode, config: SFConfig?, callback: @escaping ((SFPhotoModel?) -> Void)) {
        if isGranted {
            self.mediaType = mediaType
            self.selectMode = selectMode
            showCollectionWithTitle(title, dataSource: photoModels, config: config, cellType: SFPhotoCell.self, configCell: { (cell, data) in
                if let c = cell as? SFPhotoCell, let model = data as? SFPhotoModel {
                    if let thumbnail = model.thumbnail {
                        c.photoImgView.image = thumbnail
                    }else{
                        guard let a = model.asset else { return }
                        let options = PHImageRequestOptions.init()
                        options.deliveryMode = PHImageRequestOptionsDeliveryMode.opportunistic
                        options.resizeMode = PHImageRequestOptionsResizeMode.fast;
                        PHCachingImageManager.default().requestImage(for: a, targetSize: self.itemSize, contentMode: .aspectFill, options: options) { (image, value) in
                            model.thumbnail = image
                            c.photoImgView.image = image
                        }
                    }
                }
            }) { (value) in
                if let model = value as? SFPhotoModel? {
                    callback(model)
                }
            }
            getAllPhotoModelsFromSysytem()
        }else{
            self.removeFromSuperview()
        }
    }
}
extension SFPhotosCollectionView {
    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        super.collectionView(collectionView, didSelectItemAt: indexPath)
        
    }
}



//
//  SFPhotoCell.swift
//  SFPickerView_Example
//
//  Created by 黄山锋 on 2020/2/9.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

class SFPhotoCell: UICollectionViewCell {
    
    // MARK: - Property()
    private lazy var photoImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    private lazy var selImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.image = UIImage.bundleImageWithName("sf_select_nor")
        imgView.highlightedImage = UIImage.bundleImageWithName("sf_select_sel")
        return imgView
    }()
    
}

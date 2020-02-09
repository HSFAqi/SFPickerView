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
    private lazy var selectImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.image = UIImage.bundleImageWithName("sf_select_nor")
        imgView.highlightedImage = UIImage.bundleImageWithName("sf_select_sel")
        return imgView
    }()
    
    // MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ConfigUI
    func configUI() {
        addSubview(photoImgView)
        addSubview(selectImgView)
        photoImgView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        selectImgView.frame = CGRect(x: frame.size.width-40, y: frame.size.height-40, width: 30, height: 30)
    }
}

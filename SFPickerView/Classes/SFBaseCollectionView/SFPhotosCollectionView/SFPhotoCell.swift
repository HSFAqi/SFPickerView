//
//  SFPhotoCell.swift
//  SFPickerView_Example
//
//  Created by 黄山锋 on 2020/2/9.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

enum SFPhotoType {
    case image
    case gif
    case live
    case video
}

class SFPhotoCell: UICollectionViewCell {
    
    var image: UIImage? {
        willSet{
            if let img = newValue {
                photoImgView.image = img
            }
        }
    }
    var type: SFPhotoType = .image {
        willSet{
            switch newValue {
            case .image:
                tagLabel.isHidden = true
                playImgView.isHidden = true
                break
            case .gif:
                tagLabel.text = "GIF"
                tagLabel.isHidden = false
                playImgView.isHidden = true
                break
            case .live:
                tagLabel.text = "LIVE"
                tagLabel.isHidden = false
                playImgView.isHidden = true
                break
            case .video:
                tagLabel.isHidden = true
                playImgView.isHidden = false
                break
            }
        }
    }
    // MARK: - Property(private)
    private lazy var photoImgView: SFImageView = {
        let imgView = SFImageView(frame: CGRect.zero)
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.backgroundColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1)
        return imgView
    }()
    private lazy var tagLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 6
        label.isHidden = true
        return label
    }()
    private lazy var selectImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage.bundleImageWithName("sf_select_nor")
        imgView.highlightedImage = UIImage.bundleImageWithName("sf_select_sel")
        imgView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(selectAction))
        imgView.addGestureRecognizer(tap)
        return imgView
    }()
    private lazy var playImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage.bundleImageWithName("sf_play")
        imgView.alpha = 0.8
        imgView.isHidden = true
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
        addSubview(tagLabel)
        addSubview(selectImgView)
        addSubview(playImgView)
        
        photoImgView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        tagLabel.frame = CGRect(x: 8, y: 8, width: 40, height: 20)
        selectImgView.frame = CGRect(x: frame.size.width-34, y: frame.size.height-34, width: 24, height: 24)
        playImgView.frame = CGRect(x: (frame.size.width-40)/2, y: (frame.size.height-40)/2, width: 40, height: 40)
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 8
    }
    
    /// 选择
    @objc private func selectAction() {
        selectImgView.isHighlighted = !selectImgView.isHighlighted
    }
    
}

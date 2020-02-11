//
//  SFImageView.swift
//  SFPickerView_Example
//
//  Created by 黄山锋 on 2020/2/11.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

public class SFImageView: UIImageView {

    private lazy var indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .whiteLarge
        view.startAnimating()
        return view
    }()

    // MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(indicator)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public var image: UIImage? {
        willSet{
            if let _ = newValue {
                indicator.stopAnimating()
                indicator.isHidden = true
            }else{
                indicator.startAnimating()
                indicator.isHidden = false
            }
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        indicator.center = center
    }
}

//
//  SFUIImageExtension.swift
//  SFPickerView_Example
//
//  Created by 黄山锋 on 2020/2/9.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

public extension UIImage {
    /// 获取Bundle中的图片
    class func bundleImageWithName(_ name: String, type: String = ".png") -> UIImage? {
        let bundle = Bundle.getBundle(forClass: SFBaseView.self as AnyClass, resource: "SFPickerView")
        let filePath = bundle?.path(forResource: name, ofType: type)
        let image = UIImage(contentsOfFile: filePath ?? "")
        return image
    }
}

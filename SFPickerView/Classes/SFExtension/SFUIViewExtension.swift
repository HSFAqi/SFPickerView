//
//  SFUIViewExtension.swift
//  SFPickerView_Example
//
//  Created by 黄山锋 on 2020/2/8.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    class func createViewFromNibName(_ name: String) -> Self {
        let bundle = Bundle.getBundle(forClass: SFBaseView.self as AnyClass, resource: "SFPickerView")!
        let nib = bundle.loadNibNamed(name, owner: self, options: nil)
        return nib?.first as! Self
    }
    class func createViewFromNib() -> Self {
        return UIView.createViewFromNibName(String(describing: Self.self)) as! Self
    }
}


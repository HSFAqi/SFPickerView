//
//  SFModel.swift
//  SFPickerView_Example
//
//  Created by 黄山锋 on 2020/1/9.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import Photos

// MARK: - Model
/// 省
public class SFProvinceModel: SFPickerModel {
    public var code: String?
    public var name: String?
    public var index: Int?
    public var citylist: [SFCityModel]?
    public override var value: SFPickerDataProtocol? {
        get{
            return name
        }
        set{
            name = newValue as? String
        }
    }
    public override var nextList: [Any?]? {
        get{
            return citylist
        }
        set{
            citylist = newValue as? [SFCityModel]
        }
    }
}

/// 市
public class SFCityModel: SFPickerModel {
    public var code: String?
    public var name: String?
    public var index: Int?
    public var arealist: [SFAreaModel]?
    public override var value: SFPickerDataProtocol? {
        get{
            return name
        }
        set{
            name = newValue as? String
        }
    }
    public override var nextList: [Any?]? {
        get{
            return arealist
        }
        set{
            arealist = newValue as? [SFAreaModel]
        }
    }
}

/// 区
public class SFAreaModel: SFPickerModel {
    public var code: String?
    public var name: String?
    public var index: Int?
    public override var value: SFPickerDataProtocol? {
        get{
            return name
        }
        set{
            name = newValue as? String
        }
    }
    //public override var nextList: [Any]? // 没有就没必要重写了
}

/// 联系人
public class SFContactsModel {
    public var name: String?
    public var tel: String?
    public init() { }
}
@objc protocol CollationIndexable {
    @objc var collationString : String { get }
}
extension SFContactsModel : CollationIndexable {
    @objc var collationString : String {
        guard let n = name, n.isEmpty == false else {
            return ""
        }
        var result = ""
        if n.isIncludeChinese() {
            result = n.transformToPinyin(hasBlank: false)
        }else{
            result = n
        }
        return result
    }
}

/// 相册
public class SFPhotoModel {
    public var asset: PHAsset?
    public var selected: Bool = false
    public var image: UIImage?
    public var thumbnail: UIImage?
}




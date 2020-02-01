//
//  SFModel.swift
//  SFPickerView_Example
//
//  Created by 黄山锋 on 2020/1/9.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation


// MARK: - Model
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




//
//  SFImagePickerView.swift
//  SFPickerView_Example
//
//  Created by 黄山锋 on 2020/1/9.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

class SFImagePickerView: SFBasePickerView {

    // MARK: - 单列
    /// 【Image】单列，类方法（单列时推荐使用）
    /// - Parameters:
    ///   - title: 标题
    ///   - appearance: 自定义外观
    ///   - dataSource: 数据源
    ///   - defaultIndex: 默认选中项
    ///   - isCallbackWhenSelecting: 选择时是否自动回调
    ///   - callback: 回调
    @discardableResult
    public final class func showPickerWithTitle(_ title: String?, appearance: SFPickerImageViewAppearance?, dataSource: SFPickerSingleData, defaultIndex: Int?, config: SFConfig?, callback: @escaping ((Int, UIImage?) -> Void)) -> SFBasePickerView{
        let pickerView = SFImagePickerView(frame: CGRect.zero)
        pickerView.showPickerWithTitle(title, appearance: appearance, dataSource: dataSource, defaultIndex: defaultIndex, config: config, callback: callback)
        return pickerView
    }
    /// 【Image】单列，对象方法（单列时推荐使用）
    /// - Parameters:
    ///   - title: 标题
    ///   - appearance: 自定义外观
    ///   - dataSource: 数据源
    ///   - defaultIndex: 默认选中项
    ///   - config: 配置
    ///   - callback: 回调
    public final func showPickerWithTitle(_ title: String?, appearance: SFPickerImageViewAppearance?, dataSource: SFPickerSingleData, defaultIndex: Int?, config: SFConfig?, callback: @escaping ((Int, UIImage?) -> Void)) {
        self.showPickerWithTitle(title, style: .imageView(appearance: appearance), dataSource: dataSource, defaultIndex: defaultIndex, config: config) { (index, value) in
            let image = value as! UIImage?
            callback(index, image)
        }
    }
    
    // MARK: - 单列+多列+联动
    /// 【Image】单列+多列+联动，类方法
    /// - Parameters:
    ///   - title: 标题
    ///   - appearance: 自定义外观
    ///   - dataSource: 数据源
    ///   - defaultIndex: 默认选中项
    ///   - config: 配置
    ///   - callback: 回调
    @discardableResult
    public final class func showPickerWithTitle(_ title: String?, appearance: SFPickerImageViewAppearance?, dataType: SFPickerDataType, defaultIndexs: [Int]?, config: SFConfig?, callback: @escaping (([Int], [UIImage?]) -> Void)) -> SFBasePickerView{
        let pickerView = SFImagePickerView(frame: CGRect.zero)
        pickerView.showPickerWithTitle(title, appearance: appearance, dataType: dataType, defaultIndexs: defaultIndexs, config: config, callback: callback)
        return pickerView
    }
    /// 【Image】单列+多列+联动，对象方法
    /// - Parameters:
    ///   - title: 标题
    ///   - appearance: 自定义外观
    ///   - dataSource: 数据源
    ///   - defaultIndex: 默认选中项
    ///   - config: 配置
    ///   - callback: 回调
    public final func showPickerWithTitle(_ title: String?, appearance: SFPickerImageViewAppearance?, dataType: SFPickerDataType, defaultIndexs: [Int]?, config: SFConfig?, callback: @escaping (([Int], [UIImage?]) -> Void)) {
        self.showPickerWithTitle(title, style: .imageView(appearance: appearance), dataType: dataType, defaultIndexs: defaultIndexs, config: config) { (indexs, values) in
            let images = values as! [UIImage?]
            callback(indexs, images)
        }
    }
}

//
//  SFImagePickerView.swift
//  SFPickerView_Example
//
//  Created by 黄山锋 on 2020/1/9.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

public class SFImagePickerView: SFBasePickerView {

    // MARK: - 单列
    /// Image】单列，类方法
    /// - Parameters:
    ///   - title: 标题
    ///   - appearance: 自定义外观
    ///   - dataSource: 数据源
    ///   - defaultIndex: 默认选中项
    ///   - config: 配置
    ///   - callback: 回调
    @discardableResult
    public final class func showImagePickerWithTitle(_ title: String?, appearance: SFPickerLabelAppearance?, dataSource: SFPickerSingleData, defaultIndex: Int?, config: SFConfig?, callback: @escaping ((Int, UIImage?) -> Void)) -> SFBasePickerView{
        let pickerView = SFImagePickerView(frame: CGRect.zero)
        pickerView.showImagePickerWithTitle(title, appearance: appearance, dataSource: dataSource, defaultIndex: defaultIndex, config: config, callback: callback)
        return pickerView
    }
    /// 【Image】单列，对象方法
    /// - Parameters:
    ///   - title: 标题
    ///   - appearance: 自定义外观
    ///   - dataSource: 数据源
    ///   - defaultIndex: 默认选中项
    ///   - config: 配置
    ///   - callback: 回调
    public final func showImagePickerWithTitle(_ title: String?, appearance: SFPickerLabelAppearance?, dataSource: SFPickerSingleData, defaultIndex: Int?, config: SFConfig?, callback: @escaping ((Int, UIImage?) -> Void)) {
        guard let _ = dataSource as? [UIImage?] else {
            return
        }
        self.showPickerWithTitle(title, style: .label(appearance: appearance), dataSource: dataSource, defaultIndex: defaultIndex, config: config) { (index, value) in
            let image = value as! UIImage?
            callback(index, image)
        }
    }
    
    // MARK: - 多列
    /// 【Image】多列，类方法
    /// - Parameters:
    ///   - title: 标题
    ///   - appearance: 自定义外观
    ///   - dataSource: 数据源
    ///   - defaultIndex: 默认选中项
    ///   - config: 配置
    ///   - callback: 回调
    @discardableResult
    public final class func showImagePickerWithTitle(_ title: String?, appearance: SFPickerLabelAppearance?, dataSource: SFPickerMulData, defaultIndexs: [Int]?, config: SFConfig?, callback: @escaping (([Int], [UIImage?]) -> Void)) -> SFBasePickerView{
        let pickerView = SFImagePickerView(frame: CGRect.zero)
        pickerView.showImagePickerWithTitle(title, appearance: appearance, dataSource: dataSource, defaultIndexs: defaultIndexs, config: config, callback: callback)
        return pickerView
    }
    /// 【Image】多列，对象方法
    /// - Parameters:
    ///   - title: 标题
    ///   - appearance: 自定义外观
    ///   - dataSource: 数据源
    ///   - defaultIndex: 默认选中项
    ///   - config: 配置
    ///   - callback: 回调
    public final func showImagePickerWithTitle(_ title: String?, appearance: SFPickerLabelAppearance?, dataSource: SFPickerMulData, defaultIndexs: [Int]?, config: SFConfig?, callback: @escaping (([Int], [UIImage?]) -> Void)) {
        guard let _ = dataSource as? [[UIImage?]] else {
            return
        }
        self.showPickerWithTitle(title, style: .label(appearance: appearance), dataType: .mul(data: dataSource), defaultIndexs: defaultIndexs, config: config) { (indexs, values) in
            let images = values as! [UIImage?]
            callback(indexs, images)
        }
    }
    
    // MARK: - 联动
    /// 【Image】联动，类方法
    /// - Parameters:
    ///   - title: 标题
    ///   - appearance: 自定义外观
    ///   - dataSource: 数据源
    ///   - defaultIndex: 默认选中项
    ///   - config: 配置
    ///   - callback: 回调
    @discardableResult
    public final class func showImagePickerWithTitle(_ title: String?, appearance: SFPickerLabelAppearance?, dataSource: SFPickerLinkgeData, defaultIndexs: [Int]?, config: SFConfig?, callback: @escaping (([Int], [SFPickerModel?], [UIImage?]) -> Void)) -> SFBasePickerView{
        let pickerView = SFImagePickerView(frame: CGRect.zero)
        pickerView.showImagePickerWithTitle(title, appearance: appearance, dataSource: dataSource, defaultIndexs: defaultIndexs, config: config, callback: callback)
        return pickerView
    }
    /// 【Image】联动，对象方法
    /// - Parameters:
    ///   - title: 标题
    ///   - appearance: 自定义外观
    ///   - dataSource: 数据源
    ///   - defaultIndex: 默认选中项
    ///   - config: 配置
    ///   - callback: 回调
    public final func showImagePickerWithTitle(_ title: String?, appearance: SFPickerLabelAppearance?, dataSource: SFPickerLinkgeData, defaultIndexs: [Int]?, config: SFConfig?, callback: @escaping (([Int], [SFPickerModel?], [UIImage?]) -> Void)) {
        self.showPickerWithTitle(title, style: .label(appearance: appearance), dataType: .linkge(data: dataSource), defaultIndexs: defaultIndexs, config: config) { (indexs, values) in
            let models = values as! [SFPickerModel?]
            var images = [UIImage?]()
            for model in models {
                var image: UIImage?
                if let img = model?.value as? UIImage {
                    image = img
                }
                else if let imageName = model?.value as? String {
                    image = UIImage(named: imageName)
                }
                images.append(image)
                // 暂时不添加网络图片功能
            }
            callback(indexs, models, images)
        }
    }
}

//
//  SFStringPickerView.swift
//  SFPickerView_Example
//
//  Created by 黄山锋 on 2020/1/9.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

// TODO:

public class SFStringPickerView: SFBasePickerView {

    // MARK: - 单列
    /// 【String】单列，类方法（单列时推荐使用）
    /// - Parameters:
    ///   - title: 标题
    ///   - appearance: 自定义外观
    ///   - dataSource: 数据源
    ///   - defaultIndex: 默认选中项
    ///   - isCallbackWhenSelecting: 选择时是否自动回调
    ///   - callback: 回调
    @discardableResult
    public final class func showStringPickerWithTitle(_ title: String?, appearance: SFPickerLabelAppearance?, dataSource: SFPickerSingleData, defaultIndex: Int?, config: SFConfig?, callback: @escaping ((Int, String?) -> Void)) -> SFBasePickerView{
        let pickerView = SFStringPickerView(frame: CGRect.zero)
        pickerView.showStringPickerWithTitle(title, appearance: appearance, dataSource: dataSource, defaultIndex: defaultIndex, config: config, callback: callback)
        return pickerView
    }
    /// 【String】单列，对象方法（单列时推荐使用）
    /// - Parameters:
    ///   - title: 标题
    ///   - appearance: 自定义外观
    ///   - dataSource: 数据源
    ///   - defaultIndex: 默认选中项
    ///   - config: 配置
    ///   - callback: 回调
    public final func showStringPickerWithTitle(_ title: String?, appearance: SFPickerLabelAppearance?, dataSource: SFPickerSingleData, defaultIndex: Int?, config: SFConfig?, callback: @escaping ((Int, String?) -> Void)) {
        guard let _ = dataSource as? [String?] else {
            return
        }
        self.showPickerWithTitle(title, style: .label(appearance: appearance), dataSource: dataSource, defaultIndex: defaultIndex, config: config) { (index, value) in
            let string = value as! String?
            callback(index, string)
        }
    }
    
    // MARK: - 多列
    /// 【String】多列，类方法
    /// - Parameters:
    ///   - title: 标题
    ///   - appearance: 自定义外观
    ///   - dataSource: 数据源
    ///   - defaultIndex: 默认选中项
    ///   - config: 配置
    ///   - callback: 回调
    @discardableResult
    public final class func showStringPickerWithTitle(_ title: String?, appearance: SFPickerLabelAppearance?, dataSource: SFPickerMulData, defaultIndexs: [Int]?, config: SFConfig?, callback: @escaping (([Int], [String?]) -> Void)) -> SFBasePickerView{
        let pickerView = SFStringPickerView(frame: CGRect.zero)
        pickerView.showStringPickerWithTitle(title, appearance: appearance, dataSource: dataSource, defaultIndexs: defaultIndexs, config: config, callback: callback)
        return pickerView
    }
    /// 【String】多列，对象方法
    /// - Parameters:
    ///   - title: 标题
    ///   - appearance: 自定义外观
    ///   - dataSource: 数据源
    ///   - defaultIndex: 默认选中项
    ///   - config: 配置
    ///   - callback: 回调
    public final func showStringPickerWithTitle(_ title: String?, appearance: SFPickerLabelAppearance?, dataSource: SFPickerMulData, defaultIndexs: [Int]?, config: SFConfig?, callback: @escaping (([Int], [String?]) -> Void)) {
        guard let _ = dataSource as? [[String?]] else {
            return
        }
        self.showPickerWithTitle(title, style: .label(appearance: appearance), dataType: .mul(data: dataSource), defaultIndexs: defaultIndexs, config: config) { (indexs, values) in
            let strings = values as! [String?]
            callback(indexs, strings)
        }
    }
    
    // MARK: - 联动
    /// 【String】联动，类方法
    /// - Parameters:
    ///   - title: 标题
    ///   - appearance: 自定义外观
    ///   - dataSource: 数据源
    ///   - defaultIndex: 默认选中项
    ///   - config: 配置
    ///   - callback: 回调
    @discardableResult
    public final class func showStringPickerWithTitle(_ title: String?, appearance: SFPickerLabelAppearance?, dataSource: SFPickerLinkgeData, defaultIndexs: [Int]?, config: SFConfig?, callback: @escaping (([Int], [SFPickerModel?], [String?]) -> Void)) -> SFBasePickerView{
        let pickerView = SFStringPickerView(frame: CGRect.zero)
        pickerView.showStringPickerWithTitle(title, appearance: appearance, dataSource: dataSource, defaultIndexs: defaultIndexs, config: config, callback: callback)
        return pickerView
    }
    /// 【String】联动，对象方法
    /// - Parameters:
    ///   - title: 标题
    ///   - appearance: 自定义外观
    ///   - dataSource: 数据源
    ///   - defaultIndex: 默认选中项
    ///   - config: 配置
    ///   - callback: 回调
    public final func showStringPickerWithTitle(_ title: String?, appearance: SFPickerLabelAppearance?, dataSource: SFPickerLinkgeData, defaultIndexs: [Int]?, config: SFConfig?, callback: @escaping (([Int], [SFPickerModel?], [String?]) -> Void)) {
        
        self.showPickerWithTitle(title, style: .label(appearance: appearance), dataType: .linkge(data: dataSource), defaultIndexs: defaultIndexs, config: config) { (indexs, values) in
            let models = values as! [SFPickerModel?]
            var values = [String?]()
            for model in models {
                values.append(model?.value as? String)
            }
            callback(indexs, models, values)
        }
    }
}

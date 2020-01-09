//
//  SFStringPickerView.swift
//  SFPickerView_Example
//
//  Created by 黄山锋 on 2020/1/9.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

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
    public final class func showPickerWithTitle(_ title: String?, appearance: SFPickerLabelAppearance?, dataSource: SFPickerSingleData, defaultIndex: Int = 0, config: SFConfig?, callback: @escaping ((Int, String) -> Void)) -> SFBasePickerView{
        return SFBasePickerView.showPickerWithTitle(title, style: .label(appearance: appearance), dataSource: dataSource, defaultIndex: defaultIndex, config: config, callback: callback as! ((Int, SFPickerDataProtocol?) -> Void))
    }
    /// 【String】单列，对象方法（单列时推荐使用）
    /// - Parameters:
    ///   - title: 标题
    ///   - appearance: 自定义外观
    ///   - dataSource: 数据源
    ///   - defaultIndex: 默认选中项
    ///   - config: 配置
    ///   - callback: 回调
    public final func showPickerWithTitle(_ title: String?, appearance: SFPickerLabelAppearance?, dataSource: SFPickerSingleData, defaultIndex: Int = 0, config: SFConfig?, callback: @escaping ((Int, String) -> Void)) {
        self.showPickerWithTitle(title, style: .label(appearance: appearance), dataSource: dataSource, defaultIndex: defaultIndex, config: config, callback: callback as! ((Int, SFPickerDataProtocol?) -> Void))
    }
    
    // MARK: - 单列+多列+联动
    /// 【String】单列+多列+联动，类方法
    /// - Parameters:
    ///   - title: 标题
    ///   - appearance: 自定义外观
    ///   - dataSource: 数据源
    ///   - defaultIndex: 默认选中项
    ///   - config: 配置
    ///   - callback: 回调
    @discardableResult
    public final class func showPickerWithTitle(_ title: String?, appearance: SFPickerLabelAppearance?, mode: SFPickerDataMode, defaultIndexs: [Int]?, config: SFConfig?, callback: @escaping (([Int], [String]) -> Void)) -> SFBasePickerView{
        return SFBasePickerView.showPickerWithTitle(title, style: .label(appearance: appearance), mode: mode, defaultIndexs: defaultIndexs, config: config, callback: callback as! (([Int], [SFPickerDataProtocol?]) -> Void))
    }
    /// 【String】单列+多列+联动，对象方法
    /// - Parameters:
    ///   - title: 标题
    ///   - appearance: 自定义外观
    ///   - dataSource: 数据源
    ///   - defaultIndex: 默认选中项
    ///   - config: 配置
    ///   - callback: 回调
    public final func showPickerWithTitle(_ title: String?, appearance: SFPickerLabelAppearance?, mode: SFPickerDataMode, defaultIndexs: [Int]?, config: SFConfig?, callback: @escaping (([Int], [String]) -> Void)) {
        self.showPickerWithTitle(title, style: .label(appearance: appearance), mode: mode, defaultIndexs: defaultIndexs, config: config, callback: callback as! (([Int], [SFPickerDataProtocol?]) -> Void))
    }
}

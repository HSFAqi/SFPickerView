//
//  SFBasePickerView.swift
//  SFPickerView_Example
//
//  Created by 黄山锋 on 2020/1/9.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

// MARK: - SFPickerDataMode
public protocol SFPickerModelProtocol {
    var code: String? {get set}
    var name: String? {get set}
    var nextList: [Any]? {get set}
}

public typealias SFPickerSingleData = [String]
public typealias SFPickerMulData = [[String]]
public typealias SFPickerLinkgeData = [SFPickerModelProtocol]

public enum SFPickerDataMode {
    case single(data: SFPickerSingleData)
    case mul(data: SFPickerMulData)
    case linkge(data: SFPickerLinkgeData)
    
    // 当你不确定数据源类型时，可以选择这个模式，代码会自动到前5中模式中去匹配
    case any(data: [Any])
    func getUsefulMode() -> Self {
        var usefulMode = self
        switch self {
        case .any(data: let data):
            if let d = data as? SFPickerSingleData {
                usefulMode = .single(data: d)
            }
            else if let d = data as? SFPickerMulData {
                usefulMode = .mul(data: d)
            }
            else if let d = data as? SFPickerLinkgeData {
                usefulMode = .linkge(data: d)
            }
            else {
                assertionFailure("请确保data的数据类型")
            }
            break
        default:
            usefulMode = self
        }
        return usefulMode
    }
}
// MARK: - SFPickerStyle
public enum SFPickerStyle {
    case label(appearance: SFPickerLabelAppearance?)
    case imageView(appearance: SFPickerImageViewAppearance?)
}
public struct SFPickerLabelAppearance {
    public var font: UIFont = UIFont.systemFont(ofSize: 20)
    public var textColor: UIColor = UIColor.black
    public var textAlignment: NSTextAlignment = .center
    public var adjustsFontSizeToFitWidth: Bool = true
    public var minimumScaleFactor: CGFloat = 0.5
    // 传入自定义label
    public var customLabel: UILabel?
}
public struct SFPickerImageViewAppearance {
    public var contentMode: UIView.ContentMode = .scaleAspectFit
    // 传入自定义imageView
    public var customImageView: UIImageView?
}


public class SFBasePickerView: SFBaseView {
    
    // MARK: - Property(private)
    private lazy var pickerView: UIPickerView = {
        let view = UIPickerView()
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    private(set) var style: SFPickerStyle = .label(appearance: nil)
    private(set) var dataSource = [Any]() // 数据源
    private(set) var linkgeDataSource = [Any]() // 联动模式时使用的数据源
    private(set) var selectedIndexs = [Int]() // 选中Index
    private(set) var selectedValues = [String]() // 选中Value
    private var callbackBlock: ((Int, String) -> Void)? // 单列回调
    private var mulCallbackBlock: (([Int], [String]) -> Void)? // 多列回调
    private var isMul: Bool = false // 是否多列
    private var isLinkge: Bool = false // 是否联动
    private var isChanged: Bool = false // 是否更改
    
    
    // MARK: - ConfigUI
    override func configUI() {
        super.configUI()
        alertView.contentView = pickerView
    }
    public override var config: SFConfig {
        willSet{
            /** 说明：
             * UIPickerView的代理方法rowHeightForComponent，只有在UIPickerView在绘制时才会调用
             * pickerView.reloadAllComponents()并不会刷新rowHeight
             */
            if newValue.rowHeight != config.rowHeight {
                pickerView.frame = CGRect.zero
                alertView.contentView = pickerView
            }
        }
    }
    
    // MARK: - 单列
    /// 单列，类方法（单列时推荐使用）
    /// - Parameters:
    ///   - title: 标题
    ///   - dataSource: 数据源
    ///   - defaultIndex: 默认选中项
    ///   - isCallbackWhenSelecting: 选择时是否自动回调
    ///   - callback: 回调
    @discardableResult
    public class func showPickerWithTitle(_ title: String?, style: SFPickerStyle?, dataSource: SFPickerSingleData, defaultIndex: Int = 0, config: SFConfig?, callback: @escaping ((Int, String) -> Void)) -> SFBasePickerView{
        let pickerView = SFBasePickerView(frame: CGRect.zero)
        pickerView.showPickerWithTitle(title, style: style, dataSource: dataSource, config: config, callback: callback)
        return pickerView
    }
    /// 单列，对象方法（单列时推荐使用）
    /// - Parameters:
    ///   - title: 标题
    ///   - dataSource: 数据源
    ///   - defaultIndex: 默认选中项
    ///   - config: 配置
    ///   - callback: 回调
    public func showPickerWithTitle(_ title: String?, style: SFPickerStyle?, dataSource: SFPickerSingleData, defaultIndex: Int = 0, config: SFConfig?, callback: @escaping ((Int, String) -> Void)) {
        guard dataSource.count > 0 else {
            assertionFailure("dataSource不能为空!")
            return
        }
        isMul = false
        self.title = title
        if let s = style {
            self.style = s
        }
        self.dataSource = dataSource
        self.selectedIndexs = [defaultIndex]
        configSeletedIndexAndValues()
        if let c = config {
            self.config = c
        }
        self.callbackBlock = callback
        isChanged = false
        show()
        self.alertView.sureBlock = {
            [weak self] in
            guard let ws = self else {
                return
            }
            if !ws.isChanged || !ws.config.isCallbackWhenSelecting {
                if let callback = ws.callbackBlock {
                    callback(ws.selectedIndexs[0], ws.selectedValues[0])
                }
            }
            ws.dismiss()
        }
    }
    
    // MARK: - 单列+多列+联动
    /// 单列+多列+联动，类方法
    /// - Parameters:
    ///   - title: 标题
    ///   - dataSource: 数据源
    ///   - defaultIndex: 默认选中项
    ///   - config: 配置
    ///   - callback: 回调
    @discardableResult
    public class func showPickerWithTitle(_ title: String?, style: SFPickerStyle?, mode: SFPickerDataMode, defaultIndexs: [Int]?, config: SFConfig?, callback: @escaping (([Int], [String]) -> Void)) -> SFBasePickerView{
        let pickerView = SFBasePickerView(frame: CGRect.zero)
        pickerView.showPickerWithTitle(title, style: style, mode: mode, defaultIndexs: defaultIndexs, config: config, callback: callback)
        return pickerView
    }
    /// 单列+多列+联动，对象方法
    /// - Parameters:
    ///   - title: 标题
    ///   - dataSource: 数据源
    ///   - defaultIndex: 默认选中项
    ///   - config: 配置
    ///   - callback: 回调
    public func showPickerWithTitle(_ title: String?, style: SFPickerStyle?, mode: SFPickerDataMode, defaultIndexs: [Int]?, config: SFConfig?, callback: @escaping (([Int], [String]) -> Void)) {
        self.title = title
        if let s = style {
            self.style = s
        }
        let usefulMode = mode.getUsefulMode()
        switch usefulMode {
        case .single(data: let data):
            self.dataSource = data
            isLinkge = false
            isMul = false
            if let indexs = defaultIndexs {
                guard defaultIndexs?.count == 1 else {
                    assertionFailure("【单列】请确保defaultIndexs?.count == 1")
                    return
                }
                self.selectedIndexs = indexs
            }else{
                self.selectedIndexs = [0]
            }
            break
        case .mul(data: let data):
            self.dataSource = data
            isLinkge = false
            isMul = true
            if let indexs = defaultIndexs {
                guard defaultIndexs?.count == dataSource.count else {
                    assertionFailure("【多列】请确保defaultIndexs?.count == dataSource.count")
                    return
                }
                self.selectedIndexs = indexs
            }else{
                var customIndexs = [Int]()
                for _ in data {
                    customIndexs.append(0)
                }
                self.selectedIndexs = customIndexs
            }
            break
        case .linkge(data: let data):
            self.dataSource = data
            isLinkge = true
            isMul = true
            if let data = self.dataSource as? SFPickerLinkgeData {
                if self.linkgeDataSource.count > 0 {
                    let replaceSubrange = 0...self.linkgeDataSource.count-1
                    self.linkgeDataSource.replaceSubrange(replaceSubrange, with: Array.init(repeating: [], count: replaceSubrange.count))
                }
                getLinkgeDataWith(data)
                self.linkgeDataSource.reverse()
            }
            break
        case .any(data: _):
            break
        }
        guard self.dataSource.count > 0 else {
            assertionFailure("dataSource不能为空")
            return
        }
        configSeletedIndexAndValues()
        if let c = config {
            self.config = c
        }
        self.mulCallbackBlock = callback
        show()
        self.alertView.sureBlock = {
            [weak self] in
            guard let ws = self else {
                return
            }
            if !ws.isChanged || !ws.config.isCallbackWhenSelecting {
                if let callback = ws.mulCallbackBlock {
                    callback(ws.selectedIndexs, ws.selectedValues)
                }
            }
            ws.dismiss()
        }
    }
    
    // MARK: - Func
    /// 默认选中值
    private func configSeletedIndexAndValues() {
        let data = isLinkge ? linkgeDataSource : dataSource
        pickerView.reloadAllComponents()
        if selectedValues.count > 0 {
            selectedValues.removeAll()
        }
        var components: [[String]] = [[String]]()
        if isMul {
            if let c = (data as? [[String]]) {
                components = c
            }
        }else{
            if let r = (data as? [String]) {
                components = [r]
            }
        }
        for (idx, rows) in components.enumerated() {
            let defaultIndex = self.selectedIndexs[idx]
            guard defaultIndex >= 0, defaultIndex < rows.count else {
                assertionFailure("请确保defaultIndexs数组中index不越界")
                return
            }
            var v: String = ""
            if rows.count > 0 {
                v = rows[defaultIndex]
            }
            selectedValues.append(v)
            pickerView.selectRow(defaultIndex, inComponent: idx, animated: true)
        }
    }
    
    /// 【联动】数据结构转换
    private func getLinkgeDataWith(_ data: SFPickerLinkgeData, component: Int = 0) {
        var nameArr = [String]()
        var index = 0
        if self.selectedIndexs.count > component, self.selectedIndexs.count > 0 {
            index = self.selectedIndexs[component]
        }else{
            index = 0
            self.selectedIndexs.append(index)
        }
        for (idx, model) in data.enumerated() {
            nameArr.append(model.name ?? "")
            if idx == index {
                if let nextList = model.nextList as? SFPickerLinkgeData {
                    self.getLinkgeDataWith(nextList, component: component+1)
                }
            }
        }
        self.linkgeDataSource.append(nameArr)
    }

}

// MARK: - UIPickerViewDataSource
extension SFBasePickerView: UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return selectedIndexs.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let data = isLinkge ? linkgeDataSource : dataSource
        var values = [String]()
        if isMul {
            if let components = (data as? [[String]]) {
                values = components[component]
            }
        }else{
            if let rows = (dataSource as? [String]) {
                values = rows
            }
        }
        return values.count
    }
}

// MARK: - UIPickerViewDelegate
extension SFBasePickerView: UIPickerViewDelegate {

    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return config.rowHeight
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        guard let customView = view else {
            var registerView = UIView()
            switch style {
            case .label(appearance: let appearance):
                var label = UILabel()
                var customAppearance: SFPickerLabelAppearance
                if let custom = appearance {
                    customAppearance = custom
                }else{
                    customAppearance = SFPickerLabelAppearance()
                }
                if let customLabel = customAppearance.customLabel {
                    label = customLabel
                }else{
                    label.font = customAppearance.font
                    label.textColor = customAppearance.textColor
                    label.textAlignment = customAppearance.textAlignment
                    label.adjustsFontSizeToFitWidth = customAppearance.adjustsFontSizeToFitWidth
                    label.minimumScaleFactor = customAppearance.minimumScaleFactor
                }
                label.text = getPickerViewDataAtRow(row, component: component)
                registerView = label
                break
            case .imageView(appearance: let appearance):
                var imageView = UIImageView()
                var customAppearance: SFPickerImageViewAppearance
                if let custom = appearance {
                    customAppearance = custom
                }else{
                    customAppearance = SFPickerImageViewAppearance()
                }
                if let customImageView = customAppearance.customImageView {
                    imageView = customImageView
                }else{
                    imageView.contentMode = customAppearance.contentMode
                }
                registerView = imageView
                break
            }
            return registerView
        }
        
        return customView
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedIndexs[component] = row
        if isLinkge {
            updateLinkgeDataWhenSelect(component: component)
        }
        isChanged = true
        makeSureSelectedValuesInComponent(component)
        if let callback = callbackBlock, config.isCallbackWhenSelecting == true {
            callback(selectedIndexs[0], selectedValues[0])
        }
        if let mulCallback = mulCallbackBlock, config.isCallbackWhenSelecting == true {
            mulCallback(selectedIndexs, selectedValues)
        }
    }
    
    /// 获取指定row的数据
    func getPickerViewDataAtRow(_ row: Int, component: Int) -> String? {
        let data = isLinkge ? linkgeDataSource : dataSource
        if isMul {
            if let components = (data as? [[String]]) {
                let rows = components[component]
                return rows[row]
            }else{
                return ""
            }
        }else{
            if let rows = (data as? [String]) {
                return rows[row]
            }else{
                return ""
            }
        }
    }
    /// 【联动】刷新数据
    private func updateLinkgeDataWhenSelect(component: Int) {
        if (selectedIndexs.count-1) >= (component+1) {
            let range = component+1...selectedIndexs.count-1
            selectedIndexs.replaceSubrange(range, with: Array.init(repeating: 0, count: range.count))
            if isLinkge, let data = self.dataSource as? SFPickerLinkgeData {
                let replaceSubrange = 0...self.linkgeDataSource.count-1
                self.linkgeDataSource.replaceSubrange(replaceSubrange, with: Array.init(repeating: [], count: replaceSubrange.count))
                getLinkgeDataWith(data)
                self.linkgeDataSource.reverse()
            }
            for c in range {
                let row = selectedIndexs[c]
                pickerView.reloadComponent(c)
                pickerView.selectRow(row, inComponent: c, animated: true)
                makeSureSelectedValuesInComponent(c)
            }
        }
    }
    /// 确保选中的values
    private func makeSureSelectedValuesInComponent(_ component: Int) {
        let data = isLinkge ? linkgeDataSource : dataSource
        var values = [String]()
        if isMul {
            if let components = (data as? [[String]]) {
                let rows = components[component]
                values = rows
            }
        }else{
            if let rows = (data as? [String]) {
                values = rows
            }
        }
        let index = selectedIndexs[component]
        if values.count > 0, values.count >= index {
            selectedValues[component] = values[index]
        }else{
            selectedValues[component] = ""
        }
    }
}

//
//  SFBasePickerView.swift
//  SFPickerView_Example
//
//  Created by 黄山锋 on 2020/1/9.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

// MARK: - SFPickerData
public protocol SFPickerDataProtocol {}
extension UIImage: SFPickerDataProtocol { }
extension String: SFPickerDataProtocol { }
public class SFPickerModel: SFPickerDataProtocol {
    public var value: SFPickerDataProtocol?
    public var nextList: [Any?]?
    public init() { }
}

public typealias SFPickerSingleData = [SFPickerDataProtocol?]
public typealias SFPickerMulData = [[SFPickerDataProtocol?]]
public typealias SFPickerLinkgeData = [SFPickerModel?]

public enum SFPickerDataType {
    case single(data: SFPickerSingleData)
    case mul(data: SFPickerMulData)
    case linkge(data: SFPickerLinkgeData)
    
    // 当你不确定数据源类型时，可以选择这个模式，代码会自动到前5中模式中去匹配
    case any(data: [Any?])
    func getUsefulDataType() -> Self {
        var usefulDataType = self
        switch self {
        case .any(data: let data):
            if let d = data as? SFPickerSingleData {
                usefulDataType = .single(data: d)
            }
            else if let d = data as? SFPickerMulData {
                usefulDataType = .mul(data: d)
            }
            else if let d = data as? SFPickerLinkgeData {
                usefulDataType = .linkge(data: d)
            }
            else {
                assertionFailure("请确保data的数据类型")
            }
            break
        default:
            usefulDataType = self
        }
        return usefulDataType
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
    
    // MARK: - Property(public)
    public lazy var pickerView: UIPickerView = {
        let view = UIPickerView()
        view.delegate = self
        view.dataSource = self
        return view
    }()
    // MARK: - Property(private)
    private(set) var style: SFPickerStyle = .label(appearance: nil) // 样式
    private(set) var dataSource = [Any?]() // 外部传入的数据源
    private(set) var usefulDataSource = [[SFPickerDataProtocol?]]() // 内部使用的数据源
    private(set) var selectedIndexs = [Int]() // 选中Index
    private(set) var selectedValues = [SFPickerDataProtocol?]() // 选中Value
    private var callbackBlock: ((Int, SFPickerDataProtocol?) -> Void)? // 单列回调
    private var mulCallbackBlock: (([Int], [SFPickerDataProtocol?]) -> Void)? // 多列回调
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
    /// 【Base】单列，类方法（单列时推荐使用）
    /// - Parameters:
    ///   - title: 标题
    ///   - style: 样式
    ///   - dataSource: 数据源
    ///   - defaultIndex: 默认选中项
    ///   - isCallbackWhenSelecting: 选择时是否自动回调
    ///   - callback: 回调
    @discardableResult
    public final class func showPickerWithTitle(_ title: String?, style: SFPickerStyle?, dataSource: SFPickerSingleData, defaultIndex: Int?, config: SFConfig?, callback: @escaping ((Int, SFPickerDataProtocol?) -> Void)) -> SFBasePickerView{
        let pickerView = SFBasePickerView(frame: CGRect.zero)
        pickerView.showPickerWithTitle(title, style: style, dataSource: dataSource, defaultIndex: defaultIndex, config: config, callback: callback)
        return pickerView
    }
    /// 【Base】单列，对象方法（单列时推荐使用）
    /// - Parameters:
    ///   - title: 标题
    ///   - style: 样式
    ///   - dataSource: 数据源
    ///   - defaultIndex: 默认选中项
    ///   - config: 配置
    ///   - callback: 回调
    public final func showPickerWithTitle(_ title: String?, style: SFPickerStyle?, dataSource: SFPickerSingleData, defaultIndex: Int?, config: SFConfig?, callback: @escaping ((Int, SFPickerDataProtocol?) -> Void)) {
        guard dataSource.count > 0 else {
            assertionFailure("dataSource不能为空!")
            return
        }
        isLinkge = false
        self.title = title
        if let s = style {
            self.style = s
        }
        self.dataSource = dataSource
        self.usefulDataSource = [dataSource]
        if let d = defaultIndex {
            self.selectedIndexs = [d]
        }else{
            self.selectedIndexs = [0]
        }
        initialSeletedValues()
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
    /// 【Base】单列+多列+联动，类方法
    /// - Parameters:
    ///   - title: 标题
    ///   - style: 样式
    ///   - dataSource: 数据源
    ///   - defaultIndex: 默认选中项
    ///   - config: 配置
    ///   - callback: 回调
    @discardableResult
    public final class func showPickerWithTitle(_ title: String?, style: SFPickerStyle?, dataType: SFPickerDataType, defaultIndexs: [Int]?, config: SFConfig?, callback: @escaping (([Int], [SFPickerDataProtocol?]) -> Void)) -> SFBasePickerView{
        let pickerView = SFBasePickerView(frame: CGRect.zero)
        pickerView.showPickerWithTitle(title, style: style, dataType: dataType, defaultIndexs: defaultIndexs, config: config, callback: callback)
        return pickerView
    }
    /// 【Base】单列+多列+联动，对象方法
    /// - Parameters:
    ///   - title: 标题
    ///   - style: 样式
    ///   - dataSource: 数据源
    ///   - defaultIndex: 默认选中项
    ///   - config: 配置
    ///   - callback: 回调
    public final func showPickerWithTitle(_ title: String?, style: SFPickerStyle?, dataType: SFPickerDataType, defaultIndexs: [Int]?, config: SFConfig?, callback: @escaping (([Int], [SFPickerDataProtocol?]) -> Void)) {
        self.title = title
        if let s = style {
            self.style = s
        }
        if let c = config {
            self.config = c
        }
        self.mulCallbackBlock = callback
        // 数据源
        updateDataSource(dataType: dataType, defaultIndexs: defaultIndexs)
        isChanged = false
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
    public func updateDataSource(dataType: SFPickerDataType, defaultIndexs: [Int]?) {
        let usefulDataType = dataType.getUsefulDataType()
        switch usefulDataType {
        case .single(data: let data):
            isLinkge = false
            self.dataSource = data
            self.usefulDataSource = [data]
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
            isLinkge = false
            self.dataSource = data
            self.usefulDataSource = data
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
            isLinkge = true
            self.dataSource = data
            getLinkgeDataWith(data)
            break
        case .any(data: _):
            break
        }
        guard self.usefulDataSource.count > 0 else {
            assertionFailure("数据源不能为空")
            return
        }
        // 默认选中值
        initialSeletedValues()
    }
    
    /// 默认选中值
    private func initialSeletedValues() {
        pickerView.reloadAllComponents()
        self.selectedValues = Array.init(repeating: nil, count: self.selectedIndexs.count)
        for (component, row) in self.selectedIndexs.enumerated() {
            updateSelectedValuesInComponent(component)
            pickerView.selectRow(row, inComponent: component, animated: true)
        }
    }
    
    /// 更新选中值
    private func updateSelectedValuesInComponent(_ component: Int) {
        guard usefulDataSource.count > 0,
            usefulDataSource.count > component,
            selectedIndexs.count == usefulDataSource.count else {
            assertionFailure("数组越界")
            return
        }
        let rows = usefulDataSource[component]
        let index = selectedIndexs[component]
        if rows.count > 0, rows.count > index {
            selectedValues[component] = rows[index]
        }else{
            selectedValues[component] = nil
        }
    }
    
    /// 【联动】数据结构转换
    private func getLinkgeDataWith(_ data: SFPickerLinkgeData, component: Int = 0) {
        // 获取row
        var row = 0
        if self.selectedIndexs.count > 0, self.selectedIndexs.count > component {
            row = self.selectedIndexs[component]
        }else{
            row = 0
            self.selectedIndexs.append(row)
            self.usefulDataSource.append([])
        }
        // 获取value
        var valueArr = [SFPickerDataProtocol?]()
        for (idx, model) in data.enumerated() {
            valueArr.append(model)
            if idx == row {
                if let nextList = model?.nextList as? SFPickerLinkgeData {
                    self.getLinkgeDataWith(nextList, component: component+1)
                }
            }
        }
        self.usefulDataSource[component] = valueArr
    }

}

// MARK: - UIPickerViewDataSource
extension SFBasePickerView: UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return selectedIndexs.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let rows = usefulDataSource[component]
        return rows.count
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
            updateRowDataAt(row: row, component: component, reusing: registerView)
            return registerView
        }
        updateRowDataAt(row: row, component: component, reusing: customView)
        return customView
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedIndexs[component] = row
        if isLinkge {
            updateLinkgeDataWhenSelect(component: component)
        }else{
            updateSelectedValuesInComponent(component)
        }
        isChanged = true
        if let callback = callbackBlock, config.isCallbackWhenSelecting == true {
            callback(selectedIndexs[0], selectedValues[0])
        }
        if let mulCallback = mulCallbackBlock, config.isCallbackWhenSelecting == true {
            mulCallback(selectedIndexs, selectedValues)
        }
    }
    
    /// 更新row数据
    func updateRowDataAt(row: Int, component: Int, reusing view: UIView) {
        let rows = usefulDataSource[component]
        let rowData = rows[row]
        var value: SFPickerDataProtocol?
        if isLinkge {
            if let model = rowData as? SFPickerModel {
                value = model.value
            }
        }else{
            value = rowData
        }
        if let label = view as? UILabel {
            label.text = value as? String
        }
        else if let imageView = view as? UIImageView {
            if let image = value as? UIImage {
                imageView.image = image
            }
            else if let imageName = value as? String {
                imageView.image = UIImage(named: imageName)
            }
            // 暂时不添加网络图片功能
        }
    }
    
    /// 【联动】刷新数据
    private func updateLinkgeDataWhenSelect(component: Int) {
        if (selectedIndexs.count-1) >= (component+1) {
            let range = component+1...selectedIndexs.count-1
            selectedIndexs.replaceSubrange(range, with: Array.init(repeating: 0, count: range.count))
            usefulDataSource.replaceSubrange(range, with: Array.init(repeating: [], count: range.count))
            if isLinkge, let data = self.dataSource as? SFPickerLinkgeData {
                getLinkgeDataWith(data)
            }
            for c in range {
                let row = selectedIndexs[c]
                pickerView.reloadComponent(c)
                pickerView.selectRow(row, inComponent: c, animated: true)
                updateSelectedValuesInComponent(c)
            }
        }
    }
    
}

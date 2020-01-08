//
//  SFStringPickerView.swift
//  LuckyMascot
//
//  Created by 黄山锋 on 2019/12/30.
//  Copyright © 2019 黄山锋. All rights reserved.
//

import UIKit

// TODO:
// 【联动】传入数据模型

public typealias SFStringSingleData = [String]
public typealias SFStringMulData = [[String]]
public typealias SFStringLinkgeData = [SFPickerModelProtocol]

public protocol SFPickerModelProtocol {
    var code: String? {get set}
    var name: String? {get set}
    var nextList: [Any]? {get set}
}

public enum SFStringMode {
    case single(data: SFStringSingleData)
    case mul(data: SFStringMulData)
    case linkge(data: SFStringLinkgeData)
    
    // 当你不确定数据源类型时，可以选择这个模式，代码会自动到前5中模式中去匹配
    case any(data: [Any])
    func getUsefulMode() -> Self {
        var usefulMode = self
        switch self {
        case .any(data: let data):
            if let d = data as? SFStringSingleData {
                usefulMode = .single(data: d)
            }
            else if let d = data as? SFStringMulData {
                usefulMode = .mul(data: d)
            }
            else if let d = data as? SFStringLinkgeData {
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

public class SFStringPickerView: SFPickerView {
    
    // MARK: - Property(private)
    private lazy var pickerView: UIPickerView = {
        let view = UIPickerView()
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
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
    public override var config: SFPickerConfig {
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
    public class func showPickerWithTitle(_ title: String?, dataSource: SFStringSingleData, defaultIndex: Int = 0, config: SFPickerConfig?, callback: @escaping ((Int, String) -> Void)) -> SFStringPickerView{
        let pickerView = SFStringPickerView(frame: CGRect.zero)
        pickerView.showPickerWithTitle(title, dataSource: dataSource, config: config, callback: callback)
        return pickerView
    }
    /// 单列，对象方法（单列时推荐使用）
    /// - Parameters:
    ///   - title: 标题
    ///   - dataSource: 数据源
    ///   - defaultIndex: 默认选中项
    ///   - config: 配置
    ///   - callback: 回调
    public func showPickerWithTitle(_ title: String?, dataSource: SFStringSingleData, defaultIndex: Int = 0, config: SFPickerConfig?, callback: @escaping ((Int, String) -> Void)) {
        guard dataSource.count > 0 else {
            assertionFailure("dataSource不能为空!")
            return
        }
        isMul = false
        self.title = title
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
    public class func showPickerWithTitle(_ title: String?, mode: SFStringMode, defaultIndexs: [Int]?, config: SFPickerConfig?, callback: @escaping (([Int], [String]) -> Void)) -> SFStringPickerView{
        let pickerView = SFStringPickerView(frame: CGRect.zero)
        pickerView.showPickerWithTitle(title, mode: mode, defaultIndexs: defaultIndexs, config: config, callback: callback)
        return pickerView
    }
    /// 单列+多列+联动，对象方法
    /// - Parameters:
    ///   - title: 标题
    ///   - dataSource: 数据源
    ///   - defaultIndex: 默认选中项
    ///   - config: 配置
    ///   - callback: 回调
    public func showPickerWithTitle(_ title: String?, mode: SFStringMode, defaultIndexs: [Int]?, config: SFPickerConfig?, callback: @escaping (([Int], [String]) -> Void)) {
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
            if let data = self.dataSource as? SFStringLinkgeData {
                getLinkgeDataWith(data, component: 0)
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
        self.title = title
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
    public func getLinkgeDataWith(_ data: SFStringLinkgeData, component: Int) {
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
                if let nextList = model.nextList as? SFStringLinkgeData {
                    self.getLinkgeDataWith(nextList, component: component+1)
                }
            }
        }
        self.linkgeDataSource.append(nameArr)
    }

}

// MARK: - UIPickerViewDataSource
extension SFStringPickerView: UIPickerViewDataSource {
    
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
extension SFStringPickerView: UIPickerViewDelegate {

    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return config.rowHeight
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
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
    
    /// 【联动】刷新数据
    func updateLinkgeDataWhenSelect(component: Int) {
        if (selectedIndexs.count-1) >= (component+1) {
            let range = component+1...selectedIndexs.count-1
            selectedIndexs.replaceSubrange(range, with: Array.init(repeating: 0, count: range.count))
            if isLinkge, let data = self.dataSource as? SFStringLinkgeData {
                getLinkgeDataWith(data, component: 0)
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
    func makeSureSelectedValuesInComponent(_ component: Int) {
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

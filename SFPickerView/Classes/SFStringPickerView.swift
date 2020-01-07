//
//  SFStringPickerView.swift
//  LuckyMascot
//
//  Created by 黄山锋 on 2019/12/30.
//  Copyright © 2019 黄山锋. All rights reserved.
//

import UIKit

// TODO:
// 1，多列时的联动

public class SFStringPickerConfig: SFPickerConfig {
    public var rowHeight: CGFloat = 50
}

public class SFStringPickerView: SFPickerView {
    
    // MARK: - Property(private)
    private lazy var pickerView: UIPickerView = {
        let view = UIPickerView()
        view.delegate = self
        view.dataSource = self
        return view
    }()
    private(set) var isMul: Bool = false
    private(set) var isLinkge: Bool = false // 是否联动
    private(set) var dataSource = [Any]()
    private(set) var linkgeDataSource = [Any]() // 联动模式时使用的数据源
    private(set) var selectedIndexs = [Int]()
    private(set) var selectedValues = [String]()
    private(set) var isCallbackWhenSelecting: Bool = false
    private var callbackBlock: ((Int, String) -> Void)?
    private var mulCallbackBlock: (([Int], [String]) -> Void)?
    private var isChanged: Bool = false
    
    // MARK: - ConfigUI
    override func configUI() {
        super.configUI()
        alertView.contentView = pickerView
    }
    public override var config: SFPickerConfig{
        didSet{
            /** 说明：
             * UIPickerView的代理方法rowHeightForComponent，只有在UIPickerView在绘制时才会调用
             * pickerView.reloadAllComponents()并不会刷新rowHeight
             */
            pickerView.frame = CGRect.zero
            alertView.contentView = pickerView
        }
    }
    
    // MARK: - 单列
    /// show（单列，对象方法）
    /// - Parameters:
    ///   - title: 标题
    ///   - dataSource: 数据源
    ///   - defaultIndex: 默认选中项
    ///   - isCallbackWhenSelecting: 选择时是否自动回调
    ///   - callback: 回调
    public func showPickerWithTitle(_ title: String?, dataSource: [String], defaultIndex: Int = 0, isCallbackWhenSelecting: Bool, callback: @escaping ((Int, String) -> Void)) {
        guard dataSource.count > 0 else {
            assertionFailure("dataSource不能为空!")
            return
        }
        isMul = false
        self.title = title
        self.dataSource = dataSource
        self.selectedIndexs = [defaultIndex]
        configSeletedIndexAndValues()
        self.isCallbackWhenSelecting = isCallbackWhenSelecting
        self.callbackBlock = callback
        isChanged = false
        show()
        self.alertView.sureBlock = {
            [weak self] in
            guard let ws = self else {
                return
            }
            if !ws.isChanged || !ws.isCallbackWhenSelecting {
                if let callback = ws.callbackBlock {
                    callback(ws.selectedIndexs[0], ws.selectedValues[0])
                }
            }
            ws.dismiss()
        }
    }
    /// show（单列，类方法）
    /// - Parameters:
    ///   - title: 标题
    ///   - dataSource: 数据源
    ///   - defaultIndex: 默认选中项
    ///   - isCallbackWhenSelecting: 选择时是否自动回调
    ///   - callback: 回调
    @discardableResult
    public class func showPickerWithTitle(_ title: String?, dataSource: [String], defaultIndex: Int = 0, isCallbackWhenSelecting: Bool, callback: @escaping ((Int, String) -> Void)) -> SFStringPickerView{
        let pickerView = SFStringPickerView(frame: CGRect.zero)
        pickerView.showPickerWithTitle(title, dataSource: dataSource, isCallbackWhenSelecting: isCallbackWhenSelecting, callback: callback)
        return pickerView
    }
    
    
    // MARK: - 多列
    /// show（多列，对象方法）
    /// - Parameters:
    ///   - title: 标题
    ///   - dataSource: 数据源
    ///   - defaultIndexs: 默认选中项
    ///   - isCallbackWhenSelecting: 选择时是否自动回调
    ///   - callback: 回调
    public func showPickerWithTitle(_ title: String?, dataSource: [[String]], defaultIndexs: [Int]?, isCallbackWhenSelecting: Bool, callback: @escaping (([Int], [String]) -> Void)) {
        guard dataSource.count > 0 else {
            assertionFailure("dataSource不能为空")
            return
        }
        if let indexs = defaultIndexs {
            guard defaultIndexs?.count == dataSource.count else {
                assertionFailure("请确保defaultIndexs?.count == dataSource.count")
                return
            }
            self.selectedIndexs = indexs
        }else{
            var customIndexs = [Int]()
            for _ in dataSource {
                customIndexs.append(0)
            }
            self.selectedIndexs = customIndexs
        }
        isMul = true
        self.title = title
        self.dataSource = dataSource
        configSeletedIndexAndValues()
        self.isCallbackWhenSelecting = isCallbackWhenSelecting
        self.mulCallbackBlock = callback
        show()
        self.alertView.sureBlock = {
            [weak self] in
            guard let ws = self else {
                return
            }
            if !ws.isChanged || !ws.isCallbackWhenSelecting {
                if let callback = ws.mulCallbackBlock {
                    callback(ws.selectedIndexs, ws.selectedValues)
                }
            }
            ws.dismiss()
        }
    }
    /// show（多列，类方法）
    /// - Parameters:
    ///   - title: 标题
    ///   - dataSource: 数据源
    ///   - defaultIndexs: 默认选中项
    ///   - isCallbackWhenSelecting: 选择时是否自动回调
    ///   - callback: 回调
    @discardableResult
    public class func showPickerWithTitle(_ title: String?, dataSource: [[String]], defaultIndexs: [Int]?, isCallbackWhenSelecting: Bool, callback: @escaping (([Int], [String]) -> Void)) -> SFStringPickerView{
        let pickerView = SFStringPickerView(frame: CGRect.zero)
        pickerView.showPickerWithTitle(title, dataSource: dataSource, defaultIndexs: defaultIndexs, isCallbackWhenSelecting: isCallbackWhenSelecting, callback: callback)
        return pickerView
    }
    
    
    // MARK: - 联动
    /// show（联动，对象方法）
    /// - Parameters:
    ///   - title: 标题
    ///   - dataSource: 数据源
    ///   - defaultIndexs: 默认选中项
    ///   - isCallbackWhenSelecting: 选择时是否自动回调
    ///   - callback: 回调
    public func showPickerWithTitle(_ title: String?, dataSource: [Any], defaultIndexs: [Int]?, isCallbackWhenSelecting: Bool, callback: @escaping (([Int], [String]) -> Void)) {
        guard dataSource.count > 0 else {
            assertionFailure("dataSource不能为空")
            return
        }
        /**
         * 相似类型
         * 一维：[String]
         * 二维：[[String: [String]]]
         * 三维：[[String: [[String: [String]]]]]
         * 四维：[[String: [[String: [[String: [String]]]]]]]
         * 这里只处理到四维
         */
        // 一维
        if let data = dataSource as? [String] {
            self.dataSource = data
            if let indexs = defaultIndexs {
                guard indexs.count == 1 else {
                    assertionFailure("【联动】【一维】请确保defaultIndexs?.count == 1")
                    return
                }
                self.selectedIndexs = indexs
            }else{
                self.selectedIndexs = [0]
            }
        }
        // 二维
        else if let data = dataSource as? [[String: [String]]] {
            self.dataSource = data
            if let indexs = defaultIndexs {
                guard indexs.count == 2 else {
                    assertionFailure("【联动】【二维】请确保defaultIndexs?.count == 2")
                    return
                }
                self.selectedIndexs = indexs
            }else{
                self.selectedIndexs = [0, 0]
            }
        }
        // 三维
        else if let data = dataSource as? [[String: [[String: [String]]]]] {
            self.dataSource = data
            if let indexs = defaultIndexs {
                guard indexs.count == 3 else {
                    assertionFailure("【联动】【三维】请确保defaultIndexs?.count == 3")
                    return
                }
                self.selectedIndexs = indexs
            }else{
                self.selectedIndexs = [0, 0, 0]
            }
        }
        // 四维
        else if let data = dataSource as? [[String: [[String: [[String: [String]]]]]]]{
            self.dataSource = data
            if let indexs = defaultIndexs {
                guard indexs.count == 4 else {
                    assertionFailure("【联动】【四维】请确保defaultIndexs?.count == 4")
                    return
                }
                self.selectedIndexs = indexs
            }else{
                self.selectedIndexs = [0, 0, 0, 0]
            }
        }
        getLinkgeData()
        isMul = true
        isLinkge = true
        self.title = title
        configSeletedIndexAndValues()
        self.isCallbackWhenSelecting = isCallbackWhenSelecting
        self.mulCallbackBlock = callback
        show()
        self.alertView.sureBlock = {
            [weak self] in
            guard let ws = self else {
                return
            }
            if !ws.isChanged || !ws.isCallbackWhenSelecting {
                if let callback = ws.mulCallbackBlock {
                    callback(ws.selectedIndexs, ws.selectedValues)
                }
            }
            ws.dismiss()
        }
    }
    /// show（联动，类方法）
    /// - Parameters:
    ///   - title: 标题
    ///   - dataSource: 数据源
    ///   - defaultIndexs: 默认选中项
    ///   - isCallbackWhenSelecting: 选择时是否自动回调
    ///   - callback: 回调
    @discardableResult
    public class func showPickerWithTitle(_ title: String?, dataSource: [Any], defaultIndexs: [Int]?, isCallbackWhenSelecting: Bool, callback: @escaping (([Int], [String]) -> Void)) -> SFStringPickerView{
        let pickerView = SFStringPickerView(frame: CGRect.zero)
        pickerView.showPickerWithTitle(title, dataSource: dataSource, defaultIndexs: defaultIndexs, isCallbackWhenSelecting: isCallbackWhenSelecting, callback: callback)
        return pickerView
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
    
    func updateLinkgeDataWhenSelectRow(_ row: Int, component: Int) {
        if (selectedIndexs.count-1) >= (component+1) {
            let range = component+1...selectedIndexs.count-1
            selectedIndexs.replaceSubrange(range, with: Array.init(repeating: 0, count: range.count))
            getLinkgeData()
            for i in range {
                let row = selectedIndexs[i]
                pickerView.reloadComponent(i)
                pickerView.selectRow(row, inComponent: i, animated: true)
            }
        }
    }
    /// 【联动】刷新数据
    func getLinkgeData() {
        // 一维
        if let data = dataSource as? [String] {
            self.linkgeDataSource = [data]
        }
        // 二维
        else if let data0 = dataSource as? [[String: [String]]] {
            var arr0 = [String]()
            var arr1 = [String]()
            for (idx0, dic0) in data0.enumerated() {
                let key0 = dic0.keys.first!
                arr0.append(key0)
                if idx0 == self.selectedIndexs[0] {
                    let value = dic0[key0]!
                    arr1 = value
                }
            }
            self.linkgeDataSource = [arr0, arr1]
        }
        // 三维
        else if let data0 = dataSource as? [[String: [[String: [String]]]]] {
            var arr0 = [String]()
            var arr1 = [String]()
            var arr2 = [String]()
            for (idx0, dic0) in data0.enumerated() {
                let key0 = dic0.keys.first!
                arr0.append(key0)
                if idx0 == self.selectedIndexs[0] {
                    let data1 = dic0[key0]!
                    for (idx1, dic1) in data1.enumerated() {
                        let key1 = dic1.keys.first!
                        arr1.append(key1)
                        if idx1 == self.selectedIndexs[1] {
                            let value = dic1[key1]!
                            arr2 = value
                        }
                    }
                }
            }
            self.linkgeDataSource = [arr0, arr1, arr2]
        }
        // 四维
        else if let data0 = dataSource as? [[String: [[String: [[String: [String]]]]]]]{
            var arr0 = [String]()
            var arr1 = [String]()
            var arr2 = [String]()
            var arr3 = [String]()
            for (idx0, dic0) in data0.enumerated() {
                let key0 = dic0.keys.first!
                arr0.append(key0)
                if idx0 == self.selectedIndexs[0] {
                    let data1 = dic0[key0]!
                    for (idx1, dic1) in data1.enumerated() {
                        let key1 = dic1.keys.first!
                        arr1.append(key1)
                        if idx1 == self.selectedIndexs[1] {
                            let data2 = dic1[key1]!
                            for (idx2, dic2) in data2.enumerated() {
                                let key2 = dic2.keys.first!
                                arr2.append(key2)
                                if idx2 == self.selectedIndexs[2] {
                                    let value = dic2[key2]!
                                    arr3 = value
                                }
                            }
                        }
                    }
                }
            }
            self.linkgeDataSource = [arr0, arr1, arr2, arr3]
        }
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
        let c = config as? SFStringPickerConfig
        return c?.rowHeight ?? 50
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
            updateLinkgeDataWhenSelectRow(row, component: component)
        }
        isChanged = true
        let data = isLinkge ? linkgeDataSource : dataSource
        var values: [String]!
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
        selectedValues[component] = values[row]
        if let callback = callbackBlock, self.isCallbackWhenSelecting == true {
            callback(selectedIndexs[0], selectedValues[0])
        }
        if let mulCallback = mulCallbackBlock, self.isCallbackWhenSelecting == true {
            mulCallback(selectedIndexs, selectedValues)
        }
    }
}

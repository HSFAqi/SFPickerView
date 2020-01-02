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

public class SFStringPickerView: SFPickerView {
    
    // MARK: - Property(private)
    private lazy var pickerView: UIPickerView = {
        let view = UIPickerView()
        view.delegate = self
        view.dataSource = self
        return view
    }()
    private(set) var isMul: Bool = false
    private(set) var dataSource = [Any]()
    private(set) var defaultIndexs = [Int]()
    private(set) var selectedIndexs = [Int]()
    private(set) var selectedValues = [String]()
    
    
    // MARK: - ConfigUI
    override func configUI() {
        super.configUI()
        alertView.contentView = pickerView
    }
    
    
    // MARK: - 单列
    /// show（单列，对象方法）
    /// - Parameters:
    ///   - title: 标题
    ///   - dataSource: 数据源
    public func showPickerWithTitle(_ title: String, dataSource: [String], defaultIndex: Int = 0,  completed: @escaping ((Int, String) -> Void)) {
        guard dataSource.count > 0 else {
            assertionFailure("dataSource不能为空!")
            return
        }
        isMul = false
        self.title = title
        self.dataSource = dataSource
        pickerView.reloadAllComponents()
        self.defaultIndexs = [defaultIndex]
        configSeletedIndexAndValues()
        show()
        self.alertView.sureBlock = {
            [weak self] in
            guard let weakSelf = self else {
                return
            }
            let index = weakSelf.selectedIndexs[0]
            let value = weakSelf.selectedValues[0]
            completed(index, value)
            weakSelf.dismiss()
        }
    }
    /// show（单列，类方法）
    /// - Parameters:
    ///   - title: 标题
    ///   - dataSource: 数据源
    @discardableResult
    public class func showPickerWithTitle(_ title: String, dataSource: [String], defaultIndex: Int = 0,  completed: @escaping ((Int, String) -> Void)) -> SFStringPickerView{
        let pickerView = SFStringPickerView(frame: CGRect.zero)
        pickerView.showPickerWithTitle(title, dataSource: dataSource, defaultIndex: defaultIndex, completed: completed)
        return pickerView
    }
    
    
    // MARK: - 多列
    /// show（多列，对象方法）
    /// - Parameters:
    ///   - title: 标题
    ///   - dataSource: 数据源
    public func showPickerWithTitle(_ title: String, dataSource: [[String]], defaultIndexs: [Int]?,  completed: @escaping (([Int], [String]) -> Void)) {
        guard dataSource.count > 0 else {
            assertionFailure("dataSource不能为空")
            return
        }
        if let indexs = defaultIndexs {
            guard defaultIndexs?.count == dataSource.count else {
                assertionFailure("请确保defaultIndexs?.count == dataSource.count")
                return
            }
            self.defaultIndexs = indexs
        }else{
            var customIndexs = [Int]()
            for _ in dataSource {
                customIndexs.append(0)
            }
            self.defaultIndexs = customIndexs
        }
        isMul = true
        self.title = title
        self.dataSource = dataSource
        pickerView.reloadAllComponents()
        configSeletedIndexAndValues()
        show()
        self.alertView.sureBlock = {
            [weak self] in
            guard let weakSelf = self else {
                return
            }
            let index = weakSelf.selectedIndexs
            let value = weakSelf.selectedValues
            completed(index, value)
            weakSelf.dismiss()
        }
    }
    /// show（多列，类方法）
    /// - Parameters:
    ///   - title: 标题
    ///   - dataSource: 数据源
    @discardableResult
    public class func showPickerWithTitle(_ title: String, dataSource: [[String]], defaultIndexs: [Int]?,  completed: @escaping (([Int], [String]) -> Void)) -> SFStringPickerView{
        let pickerView = SFStringPickerView(frame: CGRect.zero)
        pickerView.showPickerWithTitle(title, dataSource: dataSource, defaultIndexs: defaultIndexs, completed: completed)
        return pickerView
    }
    
    
    // MARK: - Func
    /// 默认选中值
    private func configSeletedIndexAndValues() {
        if isMul {
            guard defaultIndexs.count == dataSource.count else {
                assertionFailure("【多列】请确保defaultIndexs?.count == dataSource.count")
                return
            }
        }else{
            guard defaultIndexs.count == 1 else {
                assertionFailure("【单列】请确保defaultIndexs?.count == 1")
                return
            }
        }
        
        if selectedIndexs.count > 0 {
            selectedIndexs.removeAll()
        }
        if selectedValues.count > 0 {
            selectedValues.removeAll()
        }
        var components: [[String]] = [[String]]()
        if isMul {
            if let c = (dataSource as? [[String]]) {
                components = c
            }
        }else{
            if let r = (dataSource as? [String]) {
                components = [r]
            }
        }
        for (idx, rows) in components.enumerated() {
            let defaultIndex = self.defaultIndexs[idx] 
            guard defaultIndex >= 0, defaultIndex < rows.count else {
                assertionFailure("请确保defaultIndexs数组中index不越界")
                return
            }
            selectedIndexs.append(defaultIndex)
            var v: String = ""
            if rows.count > 0 {
                v = rows[defaultIndex]
            }
            selectedValues.append(v)
            pickerView.selectRow(defaultIndex, inComponent: idx, animated: true)
        }
    }
    
}

// MARK: - UIPickerViewDataSource
extension SFStringPickerView: UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        var components = [[String]]()
        if isMul {
            if let c = (dataSource as? [[String]]) {
                components = c
            }
        }else{
            if let r = (dataSource as? [String]) {
                components = [r]
            }
        }
        return components.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var rows = [String]()
        if isMul {
            if let c = (dataSource as? [[String]]) {
                rows = c[component]
            }
        }else{
            if let r = (dataSource as? [String]) {
                rows = r
            }
        }
        return rows.count
    }
    
}

// MARK: - UIPickerViewDelegate
extension SFStringPickerView: UIPickerViewDelegate {

    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if isMul {
            if let components = (dataSource as? [[String]]) {
                let rows = components[component]
                return rows[row]
            }else{
                return ""
            }
        }else{
            if let rows = (dataSource as? [String]) {
                return rows[row]
            }else{
                return ""
            }
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var values: [String]!
        if isMul {
            if let components = (dataSource as? [[String]]) {
                let rows = components[component]
                values = rows
            }
        }else{
            if let rows = (dataSource as? [String]) {
                values = rows
            }
        }
        selectedIndexs[component] = row
        selectedValues[component] = values[row]
    }
}

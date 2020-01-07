//
//  SFDatePickerView.swift
//  SFPickerView_Example
//
//  Created by 黄山锋 on 2020/1/2.
//  Copyright © 2020 黄山锋. All rights reserved.
//

import UIKit

// TODO:
// 1，自定义SFDateMode


public class SFDatePickerView: SFPickerView {
        
    // MARK: - Enum
    public enum SFDateMode: String {
        // 系统（UIDatePicker）
        case time = "yyyy年MM月dd EEE a HH:mm"
        case date = ""
        case dateAndTime
        case countDownTimer
        // 自定义（UIPickerView）
        
    }

    // MARK: - Property(private)
    private lazy var systemPickerView: UIDatePicker = {
        let view = UIDatePicker()
        let language = Locale.preferredLanguages.first
        let locale = Locale.init(identifier: language ?? "zh-Hans-CN")
        view.locale = locale
        view.addTarget(self, action: #selector(systemPickerViewDidSelect), for: .valueChanged)
        return view
    }()
    private lazy var customPickerView: UIPickerView = {
        let view = UIPickerView()
        view.delegate = self
        view.dataSource = self
        return view
    }()
    private(set) var mode: SFDateMode = .time
    private var formatterStr: String = ""
    private(set) var minDate: Date?
    private(set) var maxDate: Date?
    private(set) var isCallbackWhenSelecting: Bool = false
    private(set) var selectedDate: Date!
    private(set) var selectedValue: String!
    private var callbackBlock: ((Date, String) -> Void)?
    private var isChanged: Bool = false
    
    
    // MARK: - ConfigUI
    override func configUI() {
        super.configUI()
        alertView.contentView = systemPickerView
    }
    public override var config: SFPickerConfig{
        didSet{
            /** 说明：
             * UIPickerView的代理方法rowHeightForComponent，只有在UIPickerView在绘制时才会调用
             * pickerView.reloadAllComponents()并不会刷新rowHeight
             */
        }
    }
    
    // MARK: - <#name#>
    
    /// show（对象方法）
    /// - Parameters:
    ///   - title: 标题
    ///   - mode: 模式
    ///   - minDate: 最小值
    ///   - maxDate: 最大值
    ///   - isCallbackWhenSelecting: 选择时是否自动回调
    ///   - callback: 回调
    public func showPickerWithTitle(_ title: String?, mode: SFDateMode, minDate: Date?, maxDate: Date?, isCallbackWhenSelecting: Bool, callback: @escaping ((Date, String) -> Void)) {
        self.title = title
        self.mode = mode
        self.minDate = minDate
        self.maxDate = maxDate
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
                    switch ws.mode {
                    case .time, .date, .dateAndTime, .countDownTimer:
                        ws.selectedDate = ws.systemPickerView.date
                        ws.selectedValue = ws.getDateStringWith(date: ws.selectedDate, dateFormat: ws.mode.rawValue)
                        callback(ws.selectedDate, ws.selectedValue)
                    }
                }
            }
            ws.dismiss()
        }
    }
    /// show（类方法）
    /// - Parameters:
    ///   - title: 标题
    ///   - mode: 模式
    ///   - minDate: 最小值
    ///   - maxDate: 最大值
    ///   - isCallbackWhenSelecting: 选择时是否自动回调
    ///   - callback: 回调
    @discardableResult
    public class func showPickerWithTitle(_ title: String?, mode: SFDateMode, minDate: Date?, maxDate: Date?, isCallbackWhenSelecting: Bool, callback: @escaping ((Date, String) -> Void)) -> SFDatePickerView {
        let picker = SFDatePickerView(frame: CGRect.zero)
        picker.showPickerWithTitle(title, mode: mode, minDate: minDate, maxDate: maxDate, isCallbackWhenSelecting: isCallbackWhenSelecting, callback: callback)
        return picker
    }
    
    /// 格式化时间（Date转String）
    /// - Parameters:
    ///   - date: 时间
    ///   - dateFormat: 格式化字符串
    private func getDateStringWith(date: Date, dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: date)
    }
    
    /// 系统（UIDatePicker）选择时
    @objc private func systemPickerViewDidSelect(_ pickerView: UIDatePicker) {
        isChanged = true
        self.selectedDate = self.systemPickerView.date
        self.selectedValue = self.getDateStringWith(date: self.selectedDate, dateFormat: self.mode.rawValue)
        if let callback = callbackBlock, isCallbackWhenSelecting == true {
            callback(self.selectedDate, self.selectedValue)
        }
    }
}

// MARK: - UIPickerViewDataSource
extension SFDatePickerView: UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    
}

// MARK: - UIPickerViewDelegate
extension SFDatePickerView: UIPickerViewDelegate {

    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return config.rowHeight
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "&"
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        isChanged = true
        
    }
}


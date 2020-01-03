//
//  SFDatePickerView.swift
//  SFPickerView_Example
//
//  Created by 黄山锋 on 2020/1/2.
//  Copyright © 2020 黄山锋. All rights reserved.
//

import UIKit

class SFDatePickerView: SFPickerView {
    
    // MARK: - Enum
    enum SFDateMode {
        // 系统（UIDatePicker）
        case time
        case date
        case dateAndTime
        case countDownTimer
        // 自定义（UIPickerView）
        
    }

    // MARK: - Property(private)
    private lazy var systemPickerView: UIDatePicker = {
        let view = UIDatePicker()
        return view
    }()
    private lazy var customPickerView: UIPickerView = {
        let view = UIPickerView()
        view.delegate = self
        view.dataSource = self
        return view
    }()
    private var mode: SFDateMode = .time
    
    // MARK: - ConfigUI
    override func configUI() {
        super.configUI()
        alertView.contentView = systemPickerView
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
        return 50
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "&"
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}


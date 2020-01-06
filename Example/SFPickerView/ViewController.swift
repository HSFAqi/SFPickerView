//
//  ViewController.swift
//  SFPickerView
//
//  Created by hsfiOSGitHub on 01/02/2020.
//  Copyright (c) 2020 hsfiOSGitHub. All rights reserved.
//

import UIKit
import SFPickerView

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - string
    @IBAction func stringAction(_ sender: UIButton) {
        let dataSource0 = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        let dataSource1 = [dataSource0, dataSource0]
        let isCallbackWhenSelecting = false
        
        if sender.tag == 0 {
            let picker = SFStringPickerView(frame: CGRect.zero)
            picker.showPickerWithTitle("【单列】对象方法", dataSource: dataSource0, defaultIndex: 0, isCallbackWhenSelecting: isCallbackWhenSelecting) { (index, value) in
                print("index:\(index)")
                print("value:\(value)")
            }
        }
        else if sender.tag == 1 {
            SFStringPickerView.showPickerWithTitle("【单列】类方法", dataSource: dataSource0, defaultIndex: 0, isCallbackWhenSelecting: isCallbackWhenSelecting) { (index, value) in
                print("index:\(index)")
                print("value:\(value)")
            }
        }
        else if sender.tag == 2 {
            let picker = SFStringPickerView(frame: CGRect.zero)
            picker.showPickerWithTitle("【多列】对象方法", dataSource: dataSource1, defaultIndexs: [2, 3], isCallbackWhenSelecting: isCallbackWhenSelecting) { (indexs, values) in
                print("indexs:\(indexs)")
                print("values:\(values)")
            }
        }
        else if sender.tag == 3 {
            SFStringPickerView.showPickerWithTitle("【多列】类方法", dataSource: dataSource1, defaultIndexs: [2, 3], isCallbackWhenSelecting: isCallbackWhenSelecting) { (indexs, values) in
                print("indexs:\(indexs)")
                print("values:\(values)")
            }
        }
    }
    
    
    // MARK: - address
    @IBAction func addressAction(_ sender: UIButton) {
        if sender.tag == 0 {
            let picker = SFAddressPickerView(frame: CGRect.zero)
            picker.showPickerWithTitle("地址对象方法", defaultIndexs: nil) { (provinceModel, cityModel, areaModel) in
                print("provinceModel:\(String(describing: provinceModel?.name))")
                print("cityModel:\(String(describing: cityModel?.name))")
                print("areaModel:\(String(describing: areaModel?.name))")
            }
        }
        else if sender.tag == 1 {
            SFAddressPickerView.showPickerWithTitle("地址对象方法", defaultIndexs: nil) { (provinceModel, cityModel, areaModel) in
                print("provinceModel:\(String(describing: provinceModel?.name))")
                print("cityModel:\(String(describing: cityModel?.name))")
                print("areaModel:\(String(describing: areaModel?.name))")
            }
        }
    }
    
    
    // date
    @IBAction func dateAction(_ sender: UIButton) {
        if sender.tag == 0 {
            let picker = SFDatePickerView(frame: CGRect.zero)
            var config = SFPickerConfig()
            config.during = 1
            var appearance = SFPickerAlertViewAppearance()
            appearance.contentViewBackgroundColor = UIColor.white
            
//            let cancelBtn = UIButton()
//            cancelBtn.setTitle("✈️", for: .normal)
//            cancelBtn.backgroundColor = UIColor.orange
//            appearance.customCancleBtn = cancelBtn
            
            config.appearance = appearance
            config.isAnimated = true
            picker.config = config
            picker.showPickerWithTitle("时间", mode: .time, minDate: nil, maxDate: nil, isCallbackWhenSelecting: true) { (date, value) in
                print("date:\(date)")
                print("value:\(value)")
            }
        }
        else if sender.tag == 1 {
            SFDatePickerView.showPickerWithTitle("时间", mode: .time, minDate: nil, maxDate: nil, isCallbackWhenSelecting: true) { (date, value) in
                print("date:\(date)")
                print("value:\(value)")
            }
        }
    }
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


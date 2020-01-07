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
        let isCallbackWhenSelecting = true
        
        if sender.tag == 0 {
            let picker = SFStringPickerView(frame: CGRect.zero)
            picker.config.rowHeight = 100
            picker.config.maskBackgroundColor = UIColor.red
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
        else if sender.tag == 4 {
            SFStringPickerView.showPickerWithTitle("【单列】类方法", dataSource: dataSource0, defaultIndex: 0, isCallbackWhenSelecting: isCallbackWhenSelecting) { (index, value) in
                print("index:\(index)")
                print("value:\(value)")
            }
        }
        else if sender.tag == 5 {
            let data = [["0": ["A", "B", "C"]],
                        ["1": ["@", "#", "$"]],
                        ["2": ["I", "II", "III"]],
                        ["3": ["a", "b", "c"]],
                        ["4": ["个", "十", "百"]],
                        ["5": ["时", "分", "秒"]]]
            SFStringPickerView.showPickerWithTitle("【联动】二维", dataSource: data, defaultIndexs: [2, 0], isCallbackWhenSelecting: isCallbackWhenSelecting) { (indexs, values) in
                print("indexs:\(indexs)")
                print("values:\(values)")
            }
        }
        else if sender.tag == 6 {
            let arr0 = ["🐱", "🐩", "🐷"]
            let arr1 = ["🐭", "🐒", "🐔"]
            let arr2 = ["🐂", "🐅", "🐰"]
            let data = [["0": [["A": arr0], ["B": arr1], ["C": arr2]]],
                        ["1": [["@": arr0], ["#": arr1], ["$": arr2]]],
                        ["2": [["I": arr0], ["II": arr1], ["III": arr2]]],
                        ["3": [["a": arr0], ["b": arr1], ["c": arr2]]],
                        ["4": [["个": arr0], ["十": arr1], ["百": arr2]]],
                        ["5": [["时": arr0], ["分": arr1], ["秒": arr2]]]]
            SFStringPickerView.showPickerWithTitle("【联动】三维", dataSource: data, defaultIndexs: [2, 0, 2], isCallbackWhenSelecting: isCallbackWhenSelecting) { (indexs, values) in
                print("indexs:\(indexs)")
                print("values:\(values)")
            }
        }
        else if sender.tag == 7 {
            let arr0 = [["🐱": ["q", "w", "e"]], ["🐩": ["r", "t", "y"]], ["🐷": ["u", "i", "o"]]]
            let arr1 = [["🐭": ["p", "a", "s"]], ["🐒": ["d", "f", "g"]], ["🐔": ["h", "j", "k"]]]
            let arr2 = [["🐂": ["l", "z", "x"]], ["🐅": ["c", "v", "b"]], ["🐰": ["n", "m"]]]
            let data = [["0": [["A": arr0], ["B": arr1], ["C": arr2]]],
                        ["1": [["@": arr0], ["#": arr1], ["$": arr2]]],
                        ["2": [["I": arr0], ["II": arr1], ["III": arr2]]],
                        ["3": [["a": arr0], ["b": arr1], ["c": arr2]]],
                        ["4": [["个": arr0], ["十": arr1], ["百": arr2]]],
                        ["5": [["时": arr0], ["分": arr1], ["秒": arr2]]]]
            SFStringPickerView.showPickerWithTitle("【联动】四维", dataSource: data, defaultIndexs: [2, 0, 2, 0], isCallbackWhenSelecting: isCallbackWhenSelecting) { (indexs, values) in
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


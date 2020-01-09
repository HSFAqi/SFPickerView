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
        
        if sender.tag == 0 {
            let picker = SFBasePickerView(frame: CGRect.zero)
            picker.config.alertViewHeight = 500
            picker.config.isCallbackWhenSelecting = true
            picker.config.maskBackgroundColor = UIColor.red
            picker.config.appearance.contentViewBackgroundColor = UIColor.cyan
            picker.showPickerWithTitle("【单列】对象方法", dataSource: dataSource0, defaultIndex: 0, config: nil) { (index, value) in
                print("index:\(index)")
                print("value:\(value)")
            }
        }
        else if sender.tag == 1 {
            SFBasePickerView.showPickerWithTitle("【单列】类方法", dataSource: dataSource0, defaultIndex: 0, config: nil) { (index, value) in
                print("index:\(index)")
                print("value:\(value)")
            }
        }
        else if sender.tag == 2 {
            let picker = SFBasePickerView(frame: CGRect.zero)
            picker.showPickerWithTitle("【多列】对象方法", mode: .mul(data: dataSource1), defaultIndexs: [2, 3], config: nil) { (indexs, values) in
                print("indexs:\(indexs)")
                print("values:\(values)")
            }
        }
        else if sender.tag == 3 {
            SFBasePickerView.showPickerWithTitle("【多列】类方法", mode: .mul(data: dataSource1), defaultIndexs: [2, 3], config: nil) { (indexs, values) in
                print("indexs:\(indexs)")
                print("values:\(values)")
            }
        }
        else if sender.tag == 4 {
            SFBasePickerView.showPickerWithTitle("【单列】==【一维】", mode: .single(data: dataSource0), defaultIndexs: [0], config: nil) { (index, value) in
                print("index:\(index)")
                print("value:\(value)")
            }
        }
        else if sender.tag == 5 {
            
        }
        else if sender.tag == 6 {
            let picker = SFAddressPickerView(frame: CGRect.zero)
            let data = picker.provinceDataSource
            SFBasePickerView.showPickerWithTitle("地址", mode: .any(data: data), defaultIndexs: nil, config: nil) { (indexs, values) in
                print("indexs:\(indexs)")
                print("values:\(values)")
            }
            picker.removeFromSuperview()
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
            SFBasePickerView.showPickerWithTitle("【联动】四维", mode: .any(data: data), defaultIndexs: [2, 0, 2, 0], config: nil) { (indexs, values) in
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
            
        }
        else if sender.tag == 1 {
            
        }
    }
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


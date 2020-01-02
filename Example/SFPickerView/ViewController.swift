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
        if sender.tag == 0 {
            let picker = SFStringPickerView(frame: CGRect.zero)
            picker.showPickerWithTitle("单列对象方法", dataSource: ["1", "2", "3", "4", "5", "6"]) { (index, value) in
                print("index:\(index)")
                print("value:\(value)")
            }
        }
        else if sender.tag == 1 {
            SFStringPickerView.showPickerWithTitle("单列类方法", dataSource: ["1", "2", "3", "4", "5", "6"]) { (index, value) in
                print("index:\(index)")
                print("value:\(value)")
            }
        }
        else if sender.tag == 2 {
            let picker = SFStringPickerView(frame: CGRect.zero)
            picker.showPickerWithTitle("多列对象方法", dataSource: [["1", "2", "3", "4", "5", "6"], ["1", "2", "3", "4", "5", "6"]], defaultIndexs: [1, 2]) { (indexs, values) in
                print("indexs:\(indexs)")
                print("values:\(values)")
            }
        }
        else if sender.tag == 3 {
            SFStringPickerView.showPickerWithTitle("多列类方法", dataSource: [["1", "2", "3", "4", "5", "6"], ["1", "2", "3", "4", "5", "6"]], defaultIndexs: [1, 2]) { (indexs, values) in
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
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


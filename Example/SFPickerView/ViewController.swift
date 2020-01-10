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
            picker.showPickerWithTitle("【单列】对象方法", style: nil, dataSource: [], defaultIndex: 0, config: nil) { (index, value) in
                print("index:\(index)")
                print("value:\(String(describing: value))")
            }
        }
        else if sender.tag == 1 {
            SFStringPickerView.showPickerWithTitle("【单列】类方法", style: nil, dataSource: dataSource0, defaultIndex: 0, config: nil) { (index, value) in
                print("index:\(index)")
                print("value:\(String(describing: value))")
            }
            
        }
        else if sender.tag == 2 {
            let picker = SFBasePickerView(frame: CGRect.zero)
            picker.showPickerWithTitle("【多列】对象方法", style: nil, dataType: .mul(data: dataSource1), defaultIndexs: [2, 3], config: nil) { (indexs, values) in
                print("indexs:\(indexs)")
                print("values:\(values)")
            }
        }
        else if sender.tag == 3 {
            SFBasePickerView.showPickerWithTitle("【多列】类方法", style: nil, dataType: .mul(data: dataSource1), defaultIndexs: [2, 3], config: nil) { (indexs, values) in
                print("indexs:\(indexs)")
                print("values:\(values)")
            }
        }
        else if sender.tag == 4 {
            SFBasePickerView.showPickerWithTitle("【单列】==【一维】", style: nil, dataType: .single(data: dataSource0), defaultIndexs: [0], config: nil) { (index, value) in
                print("index:\(index)")
                print("value:\(value)")
            }
        }
        else if sender.tag == 5 {
            
        }
        else if sender.tag == 6 {
           
        }
        else if sender.tag == 7 {
            
        }
    }
    
    
    // MARK: - address
    @IBAction func addressAction(_ sender: UIButton) {
        if sender.tag == 0 {
            let picker = SFAddressPickerView(frame: CGRect.zero)
            picker.showPickerWithTitle("【地址】类方法", appearance: nil, defaultIndexs: nil, config: nil) { (provinceModel, cityModel, areaModel) in
                print("province:\(String(describing: provinceModel?.value))")
                print("city:\(String(describing: cityModel?.value))")
                print("area:\(String(describing: areaModel?.value))")
            }
        }
        else if sender.tag == 1 {
            SFAddressPickerView.showPickerWithTitle("【地址】类方法", appearance: nil, defaultIndexs: nil, config: nil) { (provinceModel, cityModel, areaModel) in
                print("province:\(String(describing: provinceModel?.value))")
                print("city:\(String(describing: cityModel?.value))")
                print("area:\(String(describing: areaModel?.value))")
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


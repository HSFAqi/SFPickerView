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
    
    var picker: SFDatePickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

    }

    // MARK: - string
    @IBAction func stringAction(_ sender: UIButton) {
        let dataSource0 = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        
        
        if sender.tag == 0 {
            let pickerView = SFStringPickerView(frame: CGRect.zero)
            pickerView.showPickerWithTitle("单列-对象方法", appearance: nil, dataSource: dataSource0, defaultIndex: 3, config: nil) { (index, value) in
                print("index：\(index)")
                print("value：\(value)")
            }
            
        }
        else if sender.tag == 1 {
            
        }
        else if sender.tag == 2 {
            
        }
        else if sender.tag == 3 {
            
        }
        else if sender.tag == 4 {
            
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
            let pickerView = SFAddressPickerView(frame: CGRect.zero)
            pickerView.showPickerWithTitle("地址-对象方法", appearance: nil, defaultIndexs: nil, config: nil) { (provinceModel, cityModel, areaModel) in
                print("province：\(String(describing: provinceModel?.name))")
                print("city：\(String(describing: cityModel?.name))")
                print("area：\(String(describing: areaModel?.name))")
            }
            
        }
        else if sender.tag == 1 {
            SFAddressPickerView.showPickerWithTitle("地址-类方法", appearance: nil, defaultIndexs: nil, config: nil) { (provinceModel, cityModel, areaModel) in
                print("province：\(String(describing: provinceModel?.name))")
                print("city：\(String(describing: cityModel?.name))")
                print("area：\(String(describing: areaModel?.name))")
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


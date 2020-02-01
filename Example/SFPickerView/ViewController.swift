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
        let imageDataSource = ["download-0", "download-1", "download-2", "download-3", "download-4", "download-5"]
        
        if sender.tag == 0 {
            let pickerView = SFImagePickerView(frame: CGRect.zero)
            pickerView.config.rowHeight = 100
            pickerView.showImagePickerWithTitle("图片", appearance: nil, dataSource: imageDataSource, defaultIndex: nil, config: nil) { (index, image) in
                print("index：\(index)")
                print("image：\(image)")
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
        let mode = SFDateMode.YMDhms
        let minDate = Date.init(timeInterval: -24*3600, since: Date())
        let maxDate = Date.init(timeInterval: 24*3600, since: Date())
        let selDate = Date()
        if sender.tag == 0 {
            let pickerView = SFDatePickerView(frame: CGRect.zero)
            pickerView.showPickerWithTitle("时间-对象方法", appearance: nil, mode: mode, minDate: minDate, maxDate: maxDate, selDate: selDate, format: nil, config: nil) { (date, dateString) in
                print("date：\(date)")
                print("dateString：\(dateString)")
            }
        }
        else if sender.tag == 1 {
            SFDatePickerView.showPickerWithTitle("时间-类方法", appearance: nil, mode: mode, minDate: minDate, maxDate: maxDate, selDate: selDate, format: "yyyy", config: nil) { (date, dateString) in
                print("date：\(date)")
                print("dateString：\(dateString)")
            }
        }
    }
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


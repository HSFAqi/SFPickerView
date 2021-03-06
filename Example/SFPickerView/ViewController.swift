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
    
    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: self.view.bounds, style: UITableView.Style.grouped)
        view.dataSource = self
        view.delegate = self
        return view
    }()
    let dataSource: [[String]] = {
        var arr = [[String]]()
        /**
         * SFStringPickerView
         * 单列
         * 多列
         * 联动
         */
        var subArr0 = [String]()
        subArr0.append("单列")
        subArr0.append("多列")
        subArr0.append("联动")
        /**
         * SFImagePickerView
         * 单列
         * 多列
         * 联动
         */
        var subArr1 = [String]()
        subArr1.append("单列")
        subArr1.append("多列")
        subArr1.append("联动")
        /**
         * SFAddressPickerView
         */
        var subArr2 = [String]()
        subArr2.append("地址")
        /**
         * SFDatePickerView
         */
        var subArr3 = [String]()
        subArr3.append("时间")
        
        /**
         * SFContactsTableView
         */
        var subArr4 = [String]()
        subArr4.append("联系人")
        
        /**
         * SFBaseMapView
         */
        var subArr5 = [String]()
        subArr5.append("地图选点")
        
        /**
         * SFPhotosCollectionView
         */
        var subArr6 = [String]()
        subArr6.append("选照片")
        
        arr.append(subArr0)
        arr.append(subArr1)
        arr.append(subArr2)
        arr.append(subArr3)
        arr.append(subArr4)
        arr.append(subArr5)
        arr.append(subArr6)
        
        return arr
    }()
    let titleDataSourcce = ["SFStringPickerView", "SFImagePickerView", "SFAddressPickerView", "SFDatePickerView", "SFContactsTableView", "SFBaseMapView", "SFPhotosCollectionView"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(self.tableView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let subArr = dataSource[section]
        return subArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        cell.accessoryType = .disclosureIndicator
        let subArr = dataSource[indexPath.section]
        let title = subArr[indexPath.row]
        cell.textLabel?.text = title
        return cell
    }
}
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleDataSourcce[section]
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            stringPickerAction(tag: indexPath.row)
        }
        else if indexPath.section == 1 {
            imagePickerAction(tag: indexPath.row)
        }
        else if indexPath.section == 2 {
            addressPickerAction(tag: indexPath.row)
        }
        else if indexPath.section == 3 {
            datePickerAction(tag: indexPath.row)
        }
        else if indexPath.section == 4 {
            contactTableAction(tag: indexPath.row)
        }
        else if indexPath.section == 5 {
            mapAction(tag: indexPath.row)
        }
        else if indexPath.section == 6 {
            photosAction(tag: indexPath.row)
        }
    }
    
    /// String
    func stringPickerAction(tag: Int) {
        if tag == 0 {
            let data = ["男", "女", "保密"]
            SFStringPickerView.showStringPickerWithTitle("单列(类方法)", appearance: nil, dataSource: data, defaultIndex: 1, config: nil) { (index, value) in
                print("index：\(index)")
                print("value：\(value ?? "")")
            }
        }
        else if tag == 1 {
            let data = [["i", "ii", "iii"],["低", "中", "高"]]
            SFStringPickerView.showStringPickerWithTitle("多列(类方法)", appearance: nil, dataSource: data, defaultIndexs: nil, config: nil) { (indexs, values) in
                print("indexs：\(indexs)")
                print("values：\(values)")
            }
        }
        else if tag == 2 {
            let model00 = SFPickerModel()
            model00.value = "0"
            let model10 = SFPickerModel()
            model10.value = "1"
            
            let model01 = SFPickerModel()
            model01.value = "A"
            let model02 = SFPickerModel()
            model02.value = "B"
            model00.nextList = [model01, model02]
            
            let model11 = SFPickerModel()
            model11.value = "♣️"
            let model12 = SFPickerModel()
            model12.value = "♥️"
            let model13 = SFPickerModel()
            model13.value = "♠️"
            let model14 = SFPickerModel()
            model14.value = "♦️"
            model10.nextList = [model11, model12, model13, model14]
            
            let data = [model00, model10]
            SFStringPickerView.showStringPickerWithTitle("联动(类方法)", appearance: nil, dataSource: data, defaultIndexs: nil, config: nil) { (indexs, models, values) in
                print("indexs：\(indexs)")
                print("models：\(models)")
                print("values：\(values)")
            }
        }
    }
    
    /// Image
    func imagePickerAction(tag: Int) {
        if tag == 0 {
            let data = ["avatar-0", "avatar-1", "avatar-2", "avatar-3", "avatar-4", "avatar-5"]
            SFImagePickerView.showImagePickerWithTitle("单列(类方法)", appearance: nil, dataSource: data, defaultIndex: 1, config: nil) { (index, value) in
                print("index：\(index)")
                print("value：\(value)")
            }
        }
        else if tag == 1 {
            let data = [["avatar-0", "avatar-1", "avatar-2", "avatar-3", "avatar-4", "avatar-5"],["download-0", "download-1", "download-2", "download-3", "download-4", "download-5"]]
            SFImagePickerView.showImagePickerWithTitle("多列(类方法)", appearance: nil, dataSource: data, defaultIndexs: nil, config: nil) { (indexs, values) in
                print("indexs：\(indexs)")
                print("values：\(values)")
            }
        }
        else if tag == 2 {
            let model00 = SFPickerModel()
            model00.value = "avatar-0"
            let model10 = SFPickerModel()
            model10.value = "avatar-1"
            
            let model01 = SFPickerModel()
            model01.value = "download-0"
            let model02 = SFPickerModel()
            model02.value = "download-1"
            model00.nextList = [model01, model02]
            
            let model11 = SFPickerModel()
            model11.value = "download-0"
            let model12 = SFPickerModel()
            model12.value = "download-1"
            let model13 = SFPickerModel()
            model13.value = "download-2"
            let model14 = SFPickerModel()
            model14.value = "download-3"
            let model15 = SFPickerModel()
            model15.value = "download-4"
            let model16 = SFPickerModel()
            model16.value = "download-5"
            model10.nextList = [model11, model12, model13, model14, model15, model16]
            
            let data = [model00, model10]
            SFImagePickerView.showImagePickerWithTitle("联动(类方法)", appearance: nil, dataSource: data, defaultIndexs: nil, config: nil) { (indexs, models, values) in
                print("indexs：\(indexs)")
                print("models：\(models)")
                print("values：\(values)")
            }
        }
    }
    
    /// Address
    func addressPickerAction(tag: Int) {
        SFAddressPickerView.showAddressPickerWithTitle("地址", appearance: nil, defaultIndexs: nil, config: nil) { (provinceModel, cityModel, areaModel) in
            print("province：\(String(describing: provinceModel?.name))")
            print("city：\(String(describing: cityModel?.name))")
            print("area：\(String(describing: areaModel?.name))")
        }
    }
    
    /// Date
    func datePickerAction(tag: Int) {
        let mode = SFDateMode.YMDhms
        let minDate = Date.init(timeInterval: -24*3600, since: Date())
        let maxDate = Date.init(timeInterval: 24*3600, since: Date())
        let selDate = Date.init(timeInterval: 0, since: Date())
        SFDatePickerView.showDatePickerWithTitle("时间", appearance: nil, mode: mode, minDate: minDate, maxDate: maxDate, selDate: selDate, format: nil, config: nil) { (date, value) in
            print("date：\(date)")
            print("value：\(value)")
        }
    }
    
    /// Contact
    func contactTableAction(tag: Int) {
        SFContactsTableView.showContactsTableWithTitle("联系人", config: nil) { (model) in
            print(model?.name ?? "")
        }
    }
    
    /// Map
    func mapAction(tag: Int) {
        var config = SFConfig.init()
        config.isCallbackWhenSelecting = true
        SFBaseMapView.showMapWithTitle("地图选点", config: config) { (coordinate, address) in
            print("地址：\(String(describing: address))")
            print("精度：\(String(describing: coordinate?.longitude))")
            print("维度：\(String(describing: coordinate?.latitude))")
        }
    }
    
    /// Photos
    func photosAction(tag: Int) {
        SFPhotosCollectionView.showPhotosCollectionWithTitle("选照片", mediaType: .imageAndVideo, selectMode: .mul(max: 3), config: nil) { (model) in
            
        }
    }
}


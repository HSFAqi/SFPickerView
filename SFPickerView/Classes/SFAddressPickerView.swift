//
//  SFAddressPickerView.swift
//  LuckyMascot
//
//  Created by 黄山锋 on 2019/12/30.
//  Copyright © 2019 黄山锋. All rights reserved.
//

import UIKit

// TODO:
// 1，模式选择（省，市，区，省市，市区，省市区）
// 2，支持外部传入数据源（本地文件）
// 3，模型自定义


public class SFAddressPickerView: SFPickerView {
        
    // MARK: - Model
    public struct ProvinceModel {
        var code: String?
        public var name: String?
        var index: Int?
        var citylist: [CityModel]?
    }
    public struct CityModel {
        var code: String?
        public var name: String?
        var index: Int?
        var arealist: [AreaModel]?
    }
    public struct AreaModel {
        var code: String?
        public var name: String?
        var index: Int?
    }

    // MARK: - Property(private)
    private lazy var pickerView: UIPickerView = {
        let view = UIPickerView()
        view.delegate = self
        view.dataSource = self
        return view
    }()
    private(set) var addressDataSource: Any?
    private(set) var provinceDataSource = [ProvinceModel]()
    private(set) var cityDataSource = [CityModel]()
    private(set) var areaDataSource = [AreaModel]()
    private(set) var selectedProvinceModel: ProvinceModel?
    private(set) var selectedCityModel: CityModel?
    private(set) var selectedAreaModel: AreaModel?
    private(set) var defaultIndexs: [Int]?
    
    // MARK: - ConfigUI
    override func configUI() {
        super.configUI()
        alertView.contentView = pickerView
        loadAddressData()
    }
    public override var config: SFPickerConfig{
        didSet{
            /** 说明：
             * UIPickerView的代理方法rowHeightForComponent，只有在UIPickerView在绘制时才会调用
             * pickerView.reloadAllComponents()并不会刷新rowHeight
             */
            pickerView.frame = CGRect.zero
            alertView.contentView = pickerView
        }
    }
    
    /// 从本地plist文件读取地址数据
    private func loadAddressData() {
        do {
            guard let bundle = Bundle.getBundle(forClass: SFPickerView.self as AnyClass, resource: "SFPickerView") else {
                assertionFailure("获取外层bundle失败")
                return
            }
            guard let data = Bundle.getBundleData(bundle: bundle, name: "SFCity", type: "json") else {
                assertionFailure("读取bundle中的数据失败")
                return
            }
            let jsonData = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            addressDataSource = jsonData
            addressDataToModel()
        } catch let error {
            assertionFailure(error.localizedDescription)
        }
        
    }
    
    /// 转模型
    private func addressDataToModel() {
        guard let provinceList = addressDataSource as? [[String: Any]] else {
            return
        }
        var provinceModelArr = [ProvinceModel]()
        var provinceIndex = 0
        var cityIndex = 0
        var areaIndex = 0
        for provinceDic in provinceList {
            var provinceModel = ProvinceModel()
            provinceModel.code = provinceDic["code"] as? String
            provinceModel.name = provinceDic["name"] as? String
            provinceModel.index = provinceIndex
            guard let cityList = provinceDic["cityList"] as? [[String: Any]] else {
                provinceModel.citylist = []
                continue
            }
            var cityModelArr = [CityModel]()
            for cityDic in cityList {
                var cityModel = CityModel()
                cityModel.code = cityDic["code"] as? String
                cityModel.name = cityDic["name"] as? String
                cityModel.index = cityIndex
                guard let areaList = cityDic["areaList"] as? [[String: Any]] else {
                    cityModel.arealist = []
                    continue
                }
                var areaModelArr = [AreaModel]()
                for areaDic in areaList {
                    var areaModel = AreaModel()
                    areaModel.code = areaDic["code"] as? String
                    areaModel.name = areaDic["name"] as? String
                    areaModel.index = areaIndex
                    areaModelArr.append(areaModel)
                    areaIndex += 1
                }
                cityModel.arealist = areaModelArr
                cityModelArr.append(cityModel)
                cityIndex += 1
            }
            provinceModel.citylist = cityModelArr
            provinceModelArr.append(provinceModel)
            provinceIndex += 1
        }
        provinceDataSource = provinceModelArr
    }
    
    // MARK: - Func
    
    /// show（对象方法）
    /// - Parameters:
    ///   - title: 标题
    ///   - dataSource: 数据源
    public func showPickerWithTitle(_ title: String?, defaultIndexs: [Int]?,  completed: @escaping (ProvinceModel?, CityModel?, AreaModel?) -> Void) {
        self.title = title
        self.defaultIndexs = defaultIndexs
        configSeletedIndexAndValues()
        show()
        self.alertView.sureBlock = {
            [weak self] in
            guard let weakSelf = self else {
                return
            }
            completed(weakSelf.selectedProvinceModel, weakSelf.selectedCityModel, weakSelf.selectedAreaModel)
            weakSelf.dismiss()
        }
    }
    
    /// show（类方法）
    /// - Parameters:
    ///   - title: 标题
    ///   - dataSource: 数据源
    @discardableResult
    public class func showPickerWithTitle(_ title: String?, defaultIndexs: [Int]?, completed: @escaping (ProvinceModel?, CityModel?, AreaModel?) -> Void) -> SFAddressPickerView {
        let pickerView = SFAddressPickerView(frame: CGRect.zero)
        pickerView.showPickerWithTitle(title, defaultIndexs: defaultIndexs, completed: completed)
        return pickerView
    }
    
    /// 默认选中值
    private func configSeletedIndexAndValues() {
        pickerView.reloadAllComponents()
        let provinceIndex = defaultIndexs?[0] ?? 0
        let cityIndex = defaultIndexs?[1] ?? 0
        let areaIndex = defaultIndexs?[2] ?? 0
        selectedProvinceModel = provinceDataSource[provinceIndex]
        cityDataSource = selectedProvinceModel?.citylist ?? []
        selectedCityModel = cityDataSource[cityIndex]
        areaDataSource = selectedCityModel?.arealist ?? []
        selectedAreaModel = areaDataSource[areaIndex]
        pickerView.reloadAllComponents()
        pickerView.selectRow(provinceIndex, inComponent: 0, animated: true)
        pickerView.selectRow(cityIndex, inComponent: 1, animated: true)
        pickerView.selectRow(areaIndex, inComponent: 2, animated: true)
    }
}

// MARK: - UIPickerViewDataSource
extension SFAddressPickerView: UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return provinceDataSource.count
        }
        else if component == 1 {
            return cityDataSource.count
        }
        else{
            return areaDataSource.count
        }
    }
    
}

// MARK: - UIPickerViewDelegate
extension SFAddressPickerView: UIPickerViewDelegate {

    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return config.rowHeight
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor.black
        if component == 0 {
            let provinceModel = provinceDataSource[row]
            label.text = provinceModel.name
        }
        else if component == 1 {
            let cityModel = cityDataSource[row]
            label.text = cityModel.name
        }
        else{
            let areaModel = areaDataSource[row]
            label.text = areaModel.name
        }
        return label
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectedProvinceModel = provinceDataSource[row]
            cityDataSource = selectedProvinceModel?.citylist ?? []
            selectedCityModel = cityDataSource.first
            areaDataSource = selectedCityModel?.arealist ?? []
            selectedAreaModel = areaDataSource.first
            pickerView.reloadComponent(1)
            pickerView.selectRow(0, inComponent: 1, animated: true)
            pickerView.reloadComponent(2)
            pickerView.selectRow(0, inComponent: 2, animated: true)
        }
        else if component == 1 {
            selectedCityModel = cityDataSource[row]
            areaDataSource = selectedCityModel?.arealist ?? []
            selectedAreaModel = areaDataSource.first
            pickerView.reloadComponent(2)
            pickerView.selectRow(0, inComponent: 2, animated: true)
        }
        else{
            selectedAreaModel = areaDataSource[row]
        }
        
    }
}

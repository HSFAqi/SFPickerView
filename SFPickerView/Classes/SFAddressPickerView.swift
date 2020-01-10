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

public class SFAddressPickerView: SFStringPickerView {
//        
//    // MARK: - Model
//    public struct SFProvinceModel: SFPickerModelProtocol {
//        public var code: String?
//        public var name: String?
//        public var index: Int?
//        public var citylist: [SFCityModel]?
//        public var value: SFPickerDataProtocol? {
//            get{
//                return name
//            }
//            set{
//                name = newValue as? String
//            }
//        }
//        public var nextList: [Any]? {
//            get{
//                return citylist
//            }
//            set{
//                citylist = newValue as? [SFCityModel]
//            }
//        }
//    }
//    public struct SFCityModel: SFPickerModelProtocol {
//        public var code: String?
//        public var name: String?
//        public var index: Int?
//        public var arealist: [SFAreaModel]?
//        public var value: SFPickerDataProtocol? {
//            get{
//                return name
//            }
//            set{
//                name = newValue as? String
//            }
//        }
//        public var nextList: [Any]? {
//            get{
//                return arealist
//            }
//            set{
//                arealist = newValue as? [SFAreaModel]
//            }
//        }
//    }
//    public struct SFAreaModel: SFPickerModelProtocol {
//        public var code: String?
//        public var name: String?
//        public var index: Int?
//        public var value: SFPickerDataProtocol? {
//            get{
//                return name
//            }
//            set{
//                name = newValue as? String
//            }
//        }
//        public var nextList: [Any]?
//    }
//
//    // MARK: - Property(private)
//    private lazy var pickerView: UIPickerView = {
//        let view = UIPickerView()
//        view.delegate = self
//        view.dataSource = self
//        return view
//    }()
//    private(set) var addressDataSource: Any?
//    public var provinceDataSource = [SFProvinceModel]()
//    private(set) var cityDataSource = [SFCityModel]()
//    private(set) var areaDataSource = [SFAreaModel]()
//    private(set) var selectedProvinceModel: SFProvinceModel?
//    private(set) var selectedCityModel: SFCityModel?
//    private(set) var selectedAreaModel: SFAreaModel?
//    private(set) var defaultIndexs: [Int]?
//    
//    // MARK: - ConfigUI
//    override func configUI() {
//        super.configUI()
//        alertView.contentView = pickerView
//        loadAddressData()
//    }
//    public override var config: SFConfig{
//        didSet{
//            /** 说明：
//             * UIPickerView的代理方法rowHeightForComponent，只有在UIPickerView在绘制时才会调用
//             * pickerView.reloadAllComponents()并不会刷新rowHeight
//             */
//            pickerView.frame = CGRect.zero
//            alertView.contentView = pickerView
//        }
//    }
//    
//    /// 从本地plist文件读取地址数据
//    private func loadAddressData() {
//        do {
//            guard let bundle = Bundle.getBundle(forClass: SFBaseView.self as AnyClass, resource: "SFPickerView") else {
//                assertionFailure("获取外层bundle失败")
//                return
//            }
//            guard let data = Bundle.getBundleData(bundle: bundle, name: "SFCity", type: "json") else {
//                assertionFailure("读取bundle中的数据失败")
//                return
//            }
//            let jsonData = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
//            addressDataSource = jsonData
//            addressDataToModel()
//        } catch let error {
//            assertionFailure(error.localizedDescription)
//        }
//    }
//    
//    /// 转模型
//    private func addressDataToModel() {
//        guard let provinceList = addressDataSource as? [[String: Any]] else {
//            return
//        }
//        var provinceModelArr = [SFProvinceModel]()
//        var provinceIndex = 0
//        var cityIndex = 0
//        var areaIndex = 0
//        for provinceDic in provinceList {
//            var provinceModel = SFProvinceModel()
//            provinceModel.code = provinceDic["code"] as? String
//            provinceModel.name = provinceDic["name"] as? String
//            provinceModel.index = provinceIndex
//            guard let cityList = provinceDic["cityList"] as? [[String: Any]] else {
//                provinceModel.citylist = []
//                continue
//            }
//            var cityModelArr = [SFCityModel]()
//            for cityDic in cityList {
//                var cityModel = SFCityModel()
//                cityModel.code = cityDic["code"] as? String
//                cityModel.name = cityDic["name"] as? String
//                cityModel.index = cityIndex
//                guard let areaList = cityDic["areaList"] as? [[String: Any]] else {
//                    cityModel.arealist = []
//                    continue
//                }
//                var areaModelArr = [SFAreaModel]()
//                for areaDic in areaList {
//                    var areaModel = SFAreaModel()
//                    areaModel.code = areaDic["code"] as? String
//                    areaModel.name = areaDic["name"] as? String
//                    areaModel.index = areaIndex
//                    areaModelArr.append(areaModel)
//                    areaIndex += 1
//                }
//                cityModel.arealist = areaModelArr
//                cityModelArr.append(cityModel)
//                cityIndex += 1
//            }
//            provinceModel.citylist = cityModelArr
//            provinceModelArr.append(provinceModel)
//            provinceIndex += 1
//        }
//        provinceDataSource = provinceModelArr
//    }
//    
//    // MARK: - Func
//    
//    @discardableResult
//    public final class func showPickerWithTitle(_ title: String?, appearance: SFPickerLabelAppearance?, mode: SFPickerDataMode, defaultIndexs: [Int]?, config: SFConfig?, callback: @escaping ((SFProvinceModel?, SFCityModel?, SFAreaModel?) -> Void)) -> SFBasePickerView{
//        
//    }
//    
//    public final func showPickerWithTitle(_ title: String?, appearance: SFPickerLabelAppearance?, mode: SFPickerDataMode, defaultIndexs: [Int]?, config: SFConfig?, callback: @escaping (SFProvinceModel?, SFCityModel?, SFAreaModel?) -> Void) {
//        self.showPickerWithTitle(title, appearance: appearance, mode: mode, defaultIndexs: defaultIndexs, config: config) { (indexs, values) in
//            let provinceModel: SFProvinceModel?
//            let cityModel: SFCityModel?
//            let areaModel: SFAreaModel?
//            
//        }
//    }
//    
//    
}

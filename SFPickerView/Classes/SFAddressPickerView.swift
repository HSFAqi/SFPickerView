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

public class SFAddressPickerView: SFBasePickerView {
    
    
    /// 模式
    /// "p" = "province", "c" == "city", "a" == "area"
    public enum SFAddressPickerMode {
        case pca                                   // 省市区
        case pc                                    // 省市
        case ca(p: SFProvinceModel)                // 市区
        case p                                     // 省
        case c(p: SFProvinceModel)                 // 市
        case a(p: SFProvinceModel, c: SFCityModel) // 区
    }
    
    // MARK: - Property(private)
    private var addressDataSource = [SFPickerModel?]()
    
    // MARK: - ConfigUI
    override func configUI() {
        super.configUI()
        loadAddressData()
    }
    
    /// 从本地plist文件读取地址数据
    private func loadAddressData() {
        do {
            guard let bundle = Bundle.getBundle(forClass: SFBaseView.self as AnyClass, resource: "SFPickerView") else {
                assertionFailure("获取外层bundle失败")
                return
            }
            guard let data = Bundle.getBundleData(bundle: bundle, name: "SFCity", type: "json") else {
                assertionFailure("读取bundle中的数据失败")
                return
            }
            let jsonData = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            addressDataToModel(with: jsonData)
        } catch let error {
            assertionFailure(error.localizedDescription)
        }
    }
    
    /// 转模型
    private func addressDataToModel(with data: Any) {
        guard let provinceList = data as? [[String: Any]] else {
            return
        }
        var provinceModelArr = [SFProvinceModel]()
        var provinceIndex = 0
        var cityIndex = 0
        var areaIndex = 0
        for provinceDic in provinceList {
            let provinceModel = SFProvinceModel()
            provinceModel.code = provinceDic["code"] as? String
            provinceModel.name = provinceDic["name"] as? String
            provinceModel.index = provinceIndex
            guard let cityList = provinceDic["cityList"] as? [[String: Any]] else {
                provinceModel.citylist = []
                continue
            }
            var cityModelArr = [SFCityModel]()
            for cityDic in cityList {
                let cityModel = SFCityModel()
                cityModel.code = cityDic["code"] as? String
                cityModel.name = cityDic["name"] as? String
                cityModel.index = cityIndex
                guard let areaList = cityDic["areaList"] as? [[String: Any]] else {
                    cityModel.arealist = []
                    continue
                }
                var areaModelArr = [SFAreaModel]()
                for areaDic in areaList {
                    let areaModel = SFAreaModel()
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
        addressDataSource = provinceModelArr
    }
    
    // MARK: - Func
    
    /// 【Address】类方法
    /// - Parameters:
    ///   - title: 标题
    ///   - appearance: 自定义外观
    ///   - defaultIndexs: 默认选中项
    ///   - config: 配置
    ///   - callback: 回调
    @discardableResult
    public final class func showPickerWithTitle(_ title: String?, mode: SFAddressPickerMode, appearance: SFPickerLabelAppearance?, defaultIndexs: [Int]?, config: SFConfig?, callback: @escaping ((SFProvinceModel?, SFCityModel?, SFAreaModel?) -> Void)) -> SFBasePickerView{
        let pickerView = SFAddressPickerView(frame: CGRect.zero)
        pickerView.showPickerWithTitle(title, mode: mode, appearance: appearance, defaultIndexs: defaultIndexs, config: config, callback: callback)
        return pickerView
    }
    /// 【Address】对象方法
    /// - Parameters:
    ///   - title: 标题
    ///   - appearance: 自定义外观
    ///   - defaultIndexs: 默认选中项
    ///   - config: 配置
    ///   - callback: 回调
    public final func showPickerWithTitle(_ title: String?, mode: SFAddressPickerMode, appearance: SFPickerLabelAppearance?, defaultIndexs: [Int]?, config: SFConfig?, callback: @escaping (SFProvinceModel?, SFCityModel?, SFAreaModel?) -> Void) {
        switch mode {
        case .pca:
            
            break
        case .pc:
            break
        case .ca(p: let provinceModel):
            break
        case .p:
            break
        case .c(p: let provinceModel):
            break
        case .a(p: let provinceModel, c: let cityModel):
            break
        }
        self.showPickerWithTitle(title, style: .label(appearance: appearance), dataType: .linkge(data: self.addressDataSource), defaultIndexs: defaultIndexs, config: config) { (indexs, values) in
            let provinceModel = values[0] as? SFProvinceModel
            let cityModel = values[1] as? SFCityModel
            let areaModel = values[2] as? SFAreaModel
            callback(provinceModel, cityModel, areaModel)
        }
    }
    
    
}

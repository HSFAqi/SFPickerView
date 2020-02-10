//
//  SFBaseTableView.swift
//  SFPickerView_Example
//
//  Created by 黄山锋 on 2020/2/3.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import Contacts

// TODO:
// 1，联系人多选
// 2，打电话功能

public class SFContactsTableView: SFBaseTableView {
    
    // MARK: - Property(private)
    private var isGranted: Bool = false
    private var sectionTitles = [String]()
    private var contactsModels = [SFContactsModel]()
    private var sortedContactsModels = [[SFContactsModel]]()
    private var filtedSectionTitles = [String]()
    private var filtedContactsModels = [SFContactsModel]()
    private var sortedFiltedContactsModels = [[SFContactsModel]]()
    private var isFilted: Bool = false
    
    // MARK: - ConfigUI
    override func configUI() {
        super.configUI()
        self.config.alertViewHeight = 0.9 * UIScreen.main.bounds.height
        if #available(iOS 9.0, *) {
            let status = CNContactStore.authorizationStatus(for: .contacts)
            switch status {
            case .notDetermined:
                let store = CNContactStore()
                store.requestAccess(for: .contacts) { [weak self] (granted, error) in
                    if granted {
                        self?.isGranted = true
                    }else{
                        self?.isGranted = false
                        self?.showGrantAlert()
                    }
                }
                break
            case .restricted:
                self.isGranted = false
                showGrantAlert()
                break
            case .denied:
                self.isGranted = false
                showGrantAlert()
                break
            case .authorized:
                self.isGranted = true
                break
            @unknown default:
                print("系统预留值")
                showGrantAlert()
                break
            }
        } else {
            
        }
        // 搜索框
        configSearchUI()
    }
    
    /// 配置搜索框
    private func configSearchUI() {
        let searchView = SFSearchView(frame: CGRect(x: 0, y: 0, width: 0, height: 60))
        searchView.backgroundColor = UIColor.white
        searchView.didBeginSearch = {
            self.isFilted = true
            self.updateWithDataSource(self.sortedFiltedContactsModels)
        }
        searchView.didEndSearch = {
            self.isFilted = false
            self.updateWithDataSource(self.sortedContactsModels)
        }
        searchView.didSearching = { (searchText) in
            DispatchQueue.global().async {
                let predicate = NSPredicate.init(format: "SELF CONTAINS[cd] %@", searchText)
                self.filtedContactsModels = self.contactsModels.filter { (model) -> Bool in
                    return predicate.evaluate(with: model.name)
                }
                self.sortContactsDataSource()
                DispatchQueue.main.async {
                    self.updateWithDataSource(self.sortedFiltedContactsModels)
                }
            }
        }
        headerView = searchView
    }
    
    /// 授权提示
    private func showGrantAlert() {
        SFAlertView.showAlert(title: "访问失败", message: "请授权通讯录权限", sureTitle: "好的") { (action) in
//            let url = URL.init(string: UIApplication.openSettingsURLString)
//            if UIApplication.shared.canOpenURL(url!) {
//                UIApplication.shared.openURL(url!)
//            }
        }
    }
    
    /// 获取通讯录数据
    private func getContactsDataSource() {
        var modelArray = [SFContactsModel]()
        if #available(iOS 9.0, *) {
            let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
            let fetchRequest = CNContactFetchRequest.init(keysToFetch: keysToFetch as [CNKeyDescriptor])
            let contactStore = CNContactStore()
            do {
                try contactStore.enumerateContacts(with: fetchRequest, usingBlock: { (contact: CNContact, stop: UnsafeMutablePointer<ObjCBool>) in
                    let model = SFContactsModel()
                    let lastName = contact.familyName
                    let firstName = contact.givenName
                    model.name = "\(lastName)\(firstName)"
                    let phoneNumbers = contact.phoneNumbers
                    for phoneNumber in phoneNumbers {
                        model.tel = phoneNumber.value.stringValue
                    }
                    //去掉联系人姓名为空或者 电话为空的数据
                    if(model.name == "" || model.tel == ""){
                        
                    }else{
                        modelArray.append(model)
                    }
                })
                contactsModels = modelArray
            } catch {
                print("读取通讯录出错")
            }
        } else {
            
        }
    }
    
    /// 给通讯录数据排序
    private func sortContactsDataSource() {
        let collation = UILocalizedIndexedCollation.current()
        let highSection = collation.sectionTitles.count
        var sectionsArr: [[SFContactsModel]] = Array.init(repeating: [], count: highSection)
        let selector = #selector(getter: SFContactsModel.collationString)
        let contacts = isFilted ? filtedContactsModels : contactsModels
        for model in contacts {
            let sectionIndex = collation.section(for: model, collationStringSelector: selector)
            var modelArr = sectionsArr[sectionIndex]
            modelArr.append(model)
            sectionsArr[sectionIndex] = modelArr
        }
        var shouldRemoveSectionTitles = [String]()
        var sortedSectionsArr = [[SFContactsModel]]()
        for (idx, modelArr) in sectionsArr.enumerated() {
            guard modelArr.count > 0 else {
                let sectionTitle = collation.sectionTitles[idx]
                shouldRemoveSectionTitles.append(sectionTitle)
                continue
            }
            let sortedModelArr = collation.sortedArray(from: modelArr, collationStringSelector: selector)
            sortedSectionsArr.append(sortedModelArr as! [SFContactsModel])
        }
        var curSectionTitles = collation.sectionTitles
        curSectionTitles.removeAll { (title) -> Bool in
            return shouldRemoveSectionTitles.contains(title)
        }
        if isFilted {
            self.filtedSectionTitles = curSectionTitles
            self.sortedFiltedContactsModels = sortedSectionsArr
        }else{
            self.sectionTitles = curSectionTitles
            self.sortedContactsModels = sortedSectionsArr
        }
    }

    /// 【Contacts】类方法
    /// - Parameters:
    ///   - title: 标题
    ///   - config: 配置
    ///   - callback: 回调
    @discardableResult
    public final class func showContactsTableWithTitle(_ title: String?, config: SFConfig?, callback: @escaping ((SFContactsModel?) -> Void)) -> SFBaseTableView{
        let tableView = SFContactsTableView(frame: CGRect.zero)
        tableView.showContactsTableWithTitle(title, config: config, callback: callback)
        return tableView
    }
    
    /// 【Contacts】对象方法
    /// - Parameters:
    ///   - title: 标题
    ///   - config: 配置
    ///   - callback: 回调
    public final func showContactsTableWithTitle(_ title: String?, config: SFConfig?, callback: @escaping ((SFContactsModel?) -> Void)) {
        if isGranted {
            isFilted = false
            showTableWithTitle(title, style: .grouped, dataSource: sortedContactsModels, config: config, cellType: SFContactsCell.self, configCell: { (cell, data) in
                if let c = cell as? SFContactsCell, let d = data as? SFContactsModel {
                    c.name = d.name
                }
            }) { (value) in
                if let model = value as? SFContactsModel? {
                    callback(model)
                }
            }
            DispatchQueue.global().async {
                self.getContactsDataSource()
                self.sortContactsDataSource()
                DispatchQueue.main.async {
                    self.updateWithDataSource(self.sortedContactsModels)
                }
            }
        }else{
            self.removeFromSuperview()
        }
    }
}

extension SFContactsTableView {
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return isFilted ? filtedSectionTitles[section] : sectionTitles[section]
    }
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return isFilted ? filtedSectionTitles : sectionTitles
    }
    public func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        let titles = isFilted ? filtedSectionTitles : sectionTitles
        return titles.firstIndex(of: title)!
    }
}




//
//  SFBaseTableView.swift
//  SFPickerView_Example
//
//  Created by 黄山锋 on 2020/2/3.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import Contacts

public class SFContactsTableView: SFBaseTableView {
    
    private var isGranted: Bool = false
    private var sectionTitles = [String]()
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
                    if let _ = error {
                        self?.isGranted = false
                        self?.showGrantAlert()
                    }else{
                        self?.isGranted = true
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
    }
    
    /// 授权提示
    private func showGrantAlert() {
        let alertVC = UIAlertController(title: "请授权通讯录权限", message: "请在iPhone的\"设置-隐私-通讯录\"选项中,允许花解解访问你的通讯录", preferredStyle: .alert)
        let ok = UIAlertAction(title: "好的", style: .default, handler: nil)
        alertVC.addAction(ok)
        UIViewController.topVC?.present(alertVC, animated: true, completion: nil)
    }
    
    /// 获取通讯录数据
    private func getContactsDataSource(success: @escaping ([SFContactsModel]) -> Void) {
        var contactsModelArray = [SFContactsModel]()
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
                        contactsModelArray.append(model)
                    }
                })
                //在主线程中刷新数据
                DispatchQueue.main.async(execute: {
                    success(contactsModelArray)
                })
            } catch {
                success(contactsModelArray)
                print("读取通讯录出错")
            }
        } else {
            success(contactsModelArray)
        }
    }
    
    /// 给通讯录数据排序
    func sortContactsDataSource(_ contacts: [SFContactsModel]) -> [[SFContactsModel]] {
        let collation = UILocalizedIndexedCollation.current()
        let highSection = collation.sectionTitles.count
        var sectionsArr: [[SFContactsModel]] = Array.init(repeating: [], count: highSection)
        let selector = #selector(getter: SFContactsModel.collationString)
        for model in contacts {
            let sectionIndex = collation.section(for: model, collationStringSelector: selector)
            var modelArr = sectionsArr[sectionIndex]
            modelArr.append(model)
            sectionsArr[sectionIndex] = modelArr
        }
        self.sectionTitles = collation.sectionTitles
        var sortedSectionsArr = [[SFContactsModel]]()
        for (idx, modelArr) in sectionsArr.enumerated() {
            guard modelArr.count > 0 else {
                let sectionTitle = collation.sectionTitles[idx]
                self.sectionTitles = self.sectionTitles.filter({$0 != sectionTitle})
                continue
            }
            let sortedModelArr = collation.sortedArray(from: modelArr, collationStringSelector: selector)
            sortedSectionsArr.append(sortedModelArr as! [SFContactsModel])
        }
        return sortedSectionsArr
    }

    /// 【Contacts】类方法
    /// - Parameters:
    ///   - title: 标题
    ///   - dataSource: 数据源
    ///   - config: 配置
    ///   - callback: 回调
    @discardableResult
    public final class func showContactsTableWithTitle(_ title: String?, config: SFConfig?, callback: @escaping ((Any?) -> Void)) -> SFBaseTableView{
        let tableView = SFContactsTableView(frame: CGRect.zero)
        tableView.showContactsTableWithTitle(title, config: config, callback: callback)
        return tableView
    }
    
    
    /// 【Contacts】对象方法
    /// - Parameters:
    ///   - title: 标题
    ///   - dataSource: 数据源
    ///   - config: 配置
    ///   - callback: 回调
    public final func showContactsTableWithTitle(_ title: String?, config: SFConfig?, callback: @escaping ((Any?) -> Void)) {
        if isGranted {
            getContactsDataSource { [weak self] (dataSource) in
                guard let ws = self else {
                    return
                }
                let sortedDataSource = ws.sortContactsDataSource(dataSource)
                ws.showTableWithTitle(title, style: .grouped, dataSource: sortedDataSource, config: config, cellType: SFContactsCell.self, configCell: { (cell, data) in
                    if let c = cell as? SFContactsCell, let d = data as? SFContactsModel {
                        c.name = d.name
                    }
                }, callback: callback)
            }
        }else{
            self.removeFromSuperview()
        }
    }
}

extension SFContactsTableView {
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionTitles[section]
    }
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.sectionTitles
    }
    public func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return self.sectionTitles.firstIndex(of: title)!
    }
}




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
    // MARK: - ConfigUI
    override func configUI() {
        super.configUI()
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
                    var model = SFContactsModel()
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
                    //在主线程中刷新数据
                    DispatchQueue.main.async(execute: {
                        success(contactsModelArray)
                    })
                })
            } catch {
                success(contactsModelArray)
                print("读取通讯录出错")
            }
        } else {
            success(contactsModelArray)
        }
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
                self?.showTableWithTitle(title, dataSource: dataSource, config: config, cellType: SFContactsCell.self, configCell: { (cell, data) in
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




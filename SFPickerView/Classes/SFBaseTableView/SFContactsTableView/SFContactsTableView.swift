//
//  SFBaseTableView.swift
//  SFPickerView_Example
//
//  Created by 黄山锋 on 2020/2/3.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

public class SFContactsTableView: SFBaseTableView {

    /// 【Contacts】类方法
    /// - Parameters:
    ///   - title: 标题
    ///   - dataSource: 数据源
    ///   - config: 配置
    ///   - callback: 回调
    @discardableResult
    public final class func showContactsTableWithTitle(_ title: String?, dataSource: [Any?], config: SFConfig?, callback: @escaping ((Any?) -> Void)) -> SFBaseTableView{
        let tableView = SFContactsTableView(frame: CGRect.zero)
        tableView.showContactsTableWithTitle(title, dataSource: dataSource, config: config, callback: callback)
        return tableView
    }
    
    
    /// 【Contacts】对象方法
    /// - Parameters:
    ///   - title: 标题
    ///   - dataSource: 数据源
    ///   - config: 配置
    ///   - callback: 回调
    public final func showContactsTableWithTitle(_ title: String?, dataSource: [Any?], config: SFConfig?, callback: @escaping ((Any?) -> Void)) {
        self.showTableWithTitle(title, dataSource: dataSource, config: config, cellType: SFContactsCell.self, configCell: { (cell, data) in
            if let c = cell as? SFContactsCell, let d = data as? SFContactsModel {
                c.name = d.name
            }
        }, callback: callback)
    }
}




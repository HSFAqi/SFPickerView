//
//  SFBaseTableView.swift
//  SFPickerView_Example
//
//  Created by 黄山锋 on 2020/2/3.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

public class SFBaseTableView: SFBaseView {

    // MARK: - Property(internal)
    var tableView: UITableView!
    // MARK: - Property(private)
    private(set) var cellType: UITableViewCell.Type? {
        willSet{
            if let type = newValue {
                tableView.register(newValue, forCellReuseIdentifier: NSStringFromClass(type))
            }
        }
    }
    // 外部传入的数据源
    private(set) var dataSource = [Any?]() {
        willSet{
            if let data = newValue as? [[Any?]] {
                usefulDataSource = data
            }else{
                usefulDataSource = [newValue]
            }
        }
    }
    // 内部使用的数据源
    private(set) var usefulDataSource = [[Any?]]()
    private var selData: Any?
    // 给cell赋值
    private var configCellBlock: ((UITableViewCell, Any?) -> Void)?
    // 点击确定回调
    private var callbackBlock: ((Any?) -> Void)?
    
    public override var config: SFConfig {
        willSet{
            if newValue.rowHeight != config.rowHeight {
                tableView.frame = CGRect.zero
                alertView.contentView = tableView
            }
        }
    }
    
    /// 【Base】类方法
    @discardableResult
    public final class func showTableWithTitle(_ title: String?, style: UITableView.Style, dataSource: [Any?], config: SFConfig?, cellType: UITableViewCell.Type?, configCell: ((UITableViewCell, Any?) -> Void)?, callback: @escaping ((Any?) -> Void)) -> SFBaseTableView{
        let tableView = SFBaseTableView(frame: CGRect.zero)
        tableView.showTableWithTitle(title, style: style, dataSource: dataSource, config: config, cellType: cellType, configCell: configCell, callback: callback)
        return tableView
    }
    /// 【Base】对象方法
    public final func showTableWithTitle(_ title: String?, style: UITableView.Style, dataSource: [Any?], config: SFConfig?, cellType: UITableViewCell.Type?, configCell: ((UITableViewCell, Any?) -> Void)?, callback: @escaping ((Any?) -> Void)) {
        self.title = title
        self.tableView = UITableView.init(frame: CGRect.zero, style: style)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.alertView.contentView = tableView
        self.dataSource = dataSource
        if let c = config {
            self.config = c
        }
        self.cellType = cellType
        self.configCellBlock = configCell
        self.callbackBlock = callback
        self.tableView.reloadData()
        show()
        self.alertView.sureBlock = {
            [weak self] in
            guard let ws = self else {
                return
            }
            if let callback = ws.callbackBlock {
                callback(ws.selData)
            }
            ws.dismiss()
        }
    }
}

extension SFBaseTableView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return usefulDataSource.count
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usefulDataSource[section].count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if let type = cellType {
            cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(type), for: indexPath)
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        if let block = configCellBlock {
            let data = usefulDataSource[indexPath.section][indexPath.row]
            block(cell, data)
        }
        return cell
    }
}

extension SFBaseTableView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selData = usefulDataSource[indexPath.section][indexPath.row]
    }
}



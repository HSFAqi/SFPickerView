//
//  SFBaseTableView.swift
//  SFPickerView_Example
//
//  Created by 黄山锋 on 2020/2/3.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

private let reuseIdentifier: String = "collectionViewCell"
private let minimumLineSpacing: CGFloat = 2
private let minimumInteritemSpacing: CGFloat = 2
public class SFBaseCollectionView: SFBaseView {
    
    // MARK: - Property(internal)
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = minimumLineSpacing
        layout.minimumInteritemSpacing = minimumInteritemSpacing
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.dataSource = self
        view.delegate = self
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        return view
    }()
    private(set) var itemSize: CGSize = CGSize.zero
    // MARK: - Property(private)
    private(set) var cellType: UICollectionViewCell.Type? {
        willSet{
            if let type = newValue {
                collectionView.register(type, forCellWithReuseIdentifier: String(describing: type))
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
    private var configCellBlock: ((UICollectionViewCell, Any?) -> Void)?
    // 点击确定回调
    private var callbackBlock: ((Any?) -> Void)?
    
    // MARK: - ConfigUI
    override func configUI() {
        super.configUI()
        alertView.contentView = collectionView
    }
    public override var config: SFConfig {
        didSet{
            collectionView.reloadData()
        }
    }
    
    /// 【Base】类方法
    @discardableResult
    public final class func showCollectionWithTitle(_ title: String?, dataSource: [Any?], config: SFConfig?, cellType: UICollectionViewCell.Type?, configCell: ((UICollectionViewCell, Any?) -> Void)?, callback: @escaping ((Any?) -> Void)) -> SFBaseCollectionView {
        let collectionView = SFBaseCollectionView(frame: CGRect.zero)
        collectionView.showCollectionWithTitle(title, dataSource: dataSource, config: config, cellType: cellType, configCell: configCell, callback: callback)
        return collectionView
    }
    /// 【Base】对象方法
    public final func showCollectionWithTitle(_ title: String?, dataSource: [Any?], config: SFConfig?, cellType: UICollectionViewCell.Type?, configCell: ((UICollectionViewCell, Any?) -> Void)?, callback: @escaping ((Any?) -> Void)) {
        self.title = title
        self.dataSource = dataSource
        if let c = config {
            self.config = c
        }
        self.cellType = cellType
        self.configCellBlock = configCell
        self.callbackBlock = callback
        isChanged = false
        self.collectionView.reloadData()
        show()
        self.alertView.sureBlock = {
            [weak self] in
            guard let ws = self else {
                return
            }
            if !ws.isChanged || !ws.config.isCallbackWhenSelecting {
                if let callback = ws.callbackBlock {
                    callback(ws.selData)
                }
            }
            ws.dismiss()
        }
    }
    
    /// 刷新
    func updateWithDataSource(_ dataSource: [Any?]) {
        self.dataSource = dataSource
        collectionView.reloadData()
    }
}
extension SFBaseCollectionView: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return usefulDataSource.count
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return usefulDataSource[section].count
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell
        if let type = cellType {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: type), for: indexPath)
        }else{
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        }
        if let block = configCellBlock {
            let data = usefulDataSource[indexPath.section][indexPath.row]
            block(cell, data)
        }
        return cell
    }
    
}
extension SFBaseCollectionView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isChanged = true
        selData = usefulDataSource[indexPath.section][indexPath.row]
        if let callback = callbackBlock, config.isCallbackWhenSelecting == true {
            callback(selData)
        }
    }
}
extension SFBaseCollectionView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = (collectionView.frame.size.width - minimumInteritemSpacing*CGFloat(config.column+2))/CGFloat(config.column)
        itemSize = CGSize(width: w, height: w)
        return itemSize
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: minimumLineSpacing, left: minimumInteritemSpacing, bottom: minimumLineSpacing, right: minimumInteritemSpacing)
    }
}




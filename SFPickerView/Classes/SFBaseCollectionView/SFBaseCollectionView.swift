//
//  SFBaseTableView.swift
//  SFPickerView_Example
//
//  Created by 黄山锋 on 2020/2/3.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

private let reuseIdentifier : String = "collectionViewCell"
public class SFBaseCollectionView: SFBaseView {
    
    // MARK: - Property(internal)
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.dataSource = self
        view.delegate = self
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        return view
    }()
    // MARK: - Property(private)
    private(set) var cellType: UITableViewCell.Type? {
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
    // 给cell赋值
    private var configCellBlock: ((UICollectionViewCell, Any?) -> Void)?
    
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
    
}




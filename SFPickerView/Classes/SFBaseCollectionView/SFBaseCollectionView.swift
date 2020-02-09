//
//  SFBaseTableView.swift
//  SFPickerView_Example
//
//  Created by 黄山锋 on 2020/2/3.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

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
        return view
    }()
}
extension SFBaseCollectionView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
extension SFBaseCollectionView: UICollectionViewDelegate {
    
}




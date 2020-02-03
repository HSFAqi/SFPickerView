//
//  SFBaseTableView.swift
//  SFPickerView_Example
//
//  Created by 黄山锋 on 2020/2/3.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

class SFBaseTableView: SFBaseView {

    // MARK: - Property(internal)
    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
//        view.dataSource = self
//        view.delegate = self
        return view
    }()
    

    // MARK: - ConfigUI
    override func configUI() {
        super.configUI()
        alertView.contentView = tableView
    }
    public override var config: SFConfig {
        willSet{
            if newValue.rowHeight != config.rowHeight {
                tableView.frame = CGRect.zero
                alertView.contentView = tableView
            }
        }
    }
    
    
}

//extension SFBaseTableView: UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//    }
//}

//extension SFBaseTableView: UITableViewDelegate {
//    
//}



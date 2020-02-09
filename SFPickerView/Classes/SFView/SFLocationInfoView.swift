//
//  SFLocationInfoView.swift
//  SFPickerView_Example
//
//  Created by 黄山锋 on 2020/2/8.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

public class SFLocationInfoView: UIView {

    var location: String? {
        willSet {
            locationLabel.text = newValue
        }
    }
    var longitude: String? {
        willSet{
            longitudeLabel.text = newValue
        }
    }
    var latitude: String? {
        willSet{
            latitudeLabel.text = newValue
        }
    }
    
    // MARK: - Property(private)
    @IBOutlet weak private var locationLabel: UILabel!
    @IBOutlet weak private var longitudeLabel: UILabel!
    @IBOutlet weak private var latitudeLabel: UILabel!
    

}

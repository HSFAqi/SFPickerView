//
//  SFArrayExtension.swift
//  SFPickerView_Example
//
//  Created by 黄山锋 on 2020/2/11.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

public extension Array where Element: Equatable {
    mutating func remove(_ object: Element) {
        if let index = firstIndex(of: object) {
            remove(at: index)
        }
    }
}

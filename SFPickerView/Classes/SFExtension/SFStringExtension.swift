//
//  SFStringExtension.swift
//  SFPickerView_Example
//
//  Created by 黄山锋 on 2020/2/4.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

public extension String {
    
    /// 子字符串
    func subStringFrom(index: Int)-> String {
        let tempString: String = self
        let tempIndex = tempString.index(tempString.startIndex, offsetBy: index)
        return String(tempString[tempIndex...])
    }
    
    /// 子字符串
    func subStringTo(index: Int) -> String {
        let tempString = self
        let tempIndex = tempString.index(tempString.startIndex, offsetBy: index)
        return String(tempString[...tempIndex])
    }
    
    /// 判断字符串中是否有中文
    func isIncludeChinese() -> Bool {
        for ch in self.unicodeScalars {
            // 中文字符范围：0x4e00 ~ 0x9fff
            if (0x4e00 < ch.value  && ch.value < 0x9fff) { return true }
        }
        return false
    }
    
    /// 将中文字符串转换为拼音
    /// - Parameter hasBlank: 是否带空格（默认不带空格）
    func transformToPinyin(hasBlank: Bool = false) -> String {
        let stringRef = NSMutableString(string: self) as CFMutableString
        CFStringTransform(stringRef,nil, kCFStringTransformToLatin, false) // 转换为带音标的拼音
        CFStringTransform(stringRef, nil, kCFStringTransformStripCombiningMarks, false) // 去掉音标
        let pinyin = stringRef as String
        return hasBlank ? pinyin : pinyin.replacingOccurrences(of: " ", with: "")
    }
}

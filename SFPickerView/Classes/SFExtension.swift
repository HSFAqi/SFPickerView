//
//  SFExtension.swift
//  SFPickerView_Example
//
//  Created by 黄山锋 on 2020/1/9.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation


public extension Bundle {
    
    /// 获取bundle
    /// 先拿到最外面的 bundle。 对 framework 链接方式来说就是 framework 的 bundle 根目录，对静态库链接方式来说就是 target client 的 main bundle，然后再去找下面的 bundle 对象。
    class func getBundle(forClass: AnyClass, resource: String) -> Bundle? {
        let bundle = Bundle.init(for: forClass)
        guard let url = bundle.url(forResource: resource, withExtension: "bundle") else { return nil }
        return Bundle.init(url: url)
    }
    
    /// 获取bundle里的文件
    /// - Parameters:
    ///   - bundle: bundle
    ///   - name: 文件名
    ///   - type: 扩展名
    class func getBundleData(bundle: Bundle, name: String, type: String) -> Data? {
        do {
            guard let path = bundle.path(forResource: name, ofType: type) else {
                assertionFailure("不存在该文件")
                return nil
            }
            let url = URL(fileURLWithPath: path)
            let data = try Data(contentsOf: url)
            return data
        } catch let error {
            assertionFailure(error.localizedDescription)
            return nil
        }
    }
    
}

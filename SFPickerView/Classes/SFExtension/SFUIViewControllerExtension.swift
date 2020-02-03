//
//  SFUIViewControllerExtension.swift
//  SFPickerView_Example
//
//  Created by 黄山锋 on 2020/2/3.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    /// 最顶端控制器(类属性)
    class var topVC: UIViewController? {
        var resultVC: UIViewController?
        resultVC = Self._topVC(UIApplication.shared.keyWindow?.rootViewController)
        while resultVC?.presentedViewController != nil {
            resultVC = Self._topVC(resultVC?.presentedViewController)
        }
        return resultVC
    }
    
    /// 最顶端控制器(对象属性)
    var topVC: UIViewController? {
        var resultVC: UIViewController?
        resultVC = Self._topVC(UIApplication.shared.keyWindow?.rootViewController)
        while resultVC?.presentedViewController != nil {
            resultVC = Self._topVC(resultVC?.presentedViewController)
        }
        return resultVC
    }
    
    /// 递归调用获取最顶部的控制器
    /// - Parameter vc: 控制器
    private class func _topVC(_ vc: UIViewController?) -> UIViewController? {
        if vc is UINavigationController {
            return _topVC((vc as? UINavigationController)?.topViewController)
        } else if vc is UITabBarController {
            return _topVC((vc as? UITabBarController)?.selectedViewController)
        } else {
            return vc
        }
    }
}

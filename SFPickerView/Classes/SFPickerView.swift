//
//  SFPickerView.swift
//  LuckyMascot
//
//  Created by 黄山锋 on 2019/12/30.
//  Copyright © 2019 黄山锋. All rights reserved.
//

import UIKit

// TODO:
// 1，外观配置
// 2，降低依赖：移除Snap，改用frame布局

public class SFPickerView: UIView {
    
    // MARK: - Property(internal)
    public lazy var alertView: SFPickerAlertView = {
        let view = SFPickerAlertView(frame: self.bounds)
        return view
    }()
    public var title: String? {
        willSet{
            alertView.title = newValue
        }
    }    

    // MARK: - Property(private)
    private let during = 0.3
    private let alertViewHeight: CGFloat = 300
    private lazy var maskBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapMaskAction))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
        view.alpha = 0
        return view
    }()
    
    // MARK: - Initial
    public override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        configUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        self.removeFromSuperview()
    }
    func configUI() {
        addToView(nil)
        addSubview(maskBackgroundView)
        addSubview(alertView)
        maskBackgroundView.frame = self.bounds
        alertView.frame = CGRect(x: 0, y: self.frame.size.height, width: self.frame.size.width, height: alertViewHeight)
    }
    
    // MARK: - Func
    /// 点击mask
    @objc func tapMaskAction() {
        dismiss()
    }
    
    /// show
    public func show() {
        addToView(nil)
        UIView.animate(withDuration: during) {
            [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.maskBackgroundView.alpha = 1
            weakSelf.alertView.frame = CGRect(x: 0, y: weakSelf.frame.size.height-weakSelf.alertViewHeight, width: weakSelf.frame.size.width, height: weakSelf.alertViewHeight)
        }
    }
    
    /// dismiss
    public func dismiss() {
        UIView.animate(withDuration: during, animations: {
            [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.maskBackgroundView.alpha = 0
            weakSelf.alertView.frame = CGRect(x: 0, y: weakSelf.frame.size.height, width: weakSelf.frame.size.width, height: weakSelf.alertViewHeight)
        }) {
            [weak self] (isFinished) in
            self?.removeFromSuperview()
        }
    }
    
    /// 父视图
    public func addToView(_ view: UIView?) {
        if let v = view {
            self.frame = v.bounds
            v.addSubview(self)
        }else{
            self.frame = UIScreen.main.bounds
            let keyWindow = UIApplication.shared.keyWindow
            keyWindow?.addSubview(self)
        }
    }
}

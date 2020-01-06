//
//  SFPickerView.swift
//  LuckyMascot
//
//  Created by 黄山锋 on 2019/12/30.
//  Copyright © 2019 黄山锋. All rights reserved.
//

import UIKit

// TODO:

public class SFPickerConfig {
    public var superView: UIView?
    public var appearance: SFPickerAlertViewAppearance = SFPickerAlertViewAppearance()
    public var maskBackgroundColor: UIColor = UIColor.black.withAlphaComponent(0.3)
    public var isMaskEnabled: Bool = true
    public var isAnimated: Bool = true
    public var during: TimeInterval = 0.3
    public var alertViewHeight: CGFloat = 300
    
    //public var rowHeight: CGFloat = 50
    
    public init() { }
}

public class SFPickerView: UIView {    

    // MARK: - Property(public)
    public var config: SFPickerConfig = SFPickerConfig() {
        willSet{
            configUI()
        }
    }
    
    // MARK: - Property(internal)
    lazy var alertView: SFPickerAlertView = {
        let view = SFPickerAlertView(frame: self.bounds)
        return view
    }()
    var title: String? {
        willSet{
            alertView.title = newValue
        }
    }    

    // MARK: - Property(private)
    private lazy var maskBackgroundView: UIView = {
        let view = UIView()
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
        maskBackgroundView.backgroundColor = config.maskBackgroundColor
        maskBackgroundView.isUserInteractionEnabled = config.isMaskEnabled
        maskBackgroundView.frame = self.bounds
        alertView.appearance = config.appearance
        alertView.frame = CGRect(x: 0, y: self.frame.size.height, width: self.frame.size.width, height: config.alertViewHeight)
        alertView.cancelBlock = {
            [weak self] in
            self?.dismiss()
        }
    }
    
    // MARK: - Func
    /// 点击mask
    @objc func tapMaskAction() {
        dismiss()
    }
    
    /// show
    public func show() {
        addToView(config.superView)
        if config.isAnimated {
            UIView.animate(withDuration: config.during) {
                [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.maskBackgroundView.alpha = 1
                weakSelf.alertView.frame = CGRect(x: 0, y: weakSelf.frame.size.height-weakSelf.config.alertViewHeight, width: weakSelf.frame.size.width, height: weakSelf.config.alertViewHeight)
            }
        }else{
            self.maskBackgroundView.alpha = 1
            self.alertView.frame = CGRect(x: 0, y: self.frame.size.height-self.config.alertViewHeight, width: self.frame.size.width, height: self.config.alertViewHeight)
        }
    }
    
    /// dismiss
    public func dismiss() {
        if config.isAnimated {
            UIView.animate(withDuration: config.during, animations: {
                [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.maskBackgroundView.alpha = 0
                weakSelf.alertView.frame = CGRect(x: 0, y: weakSelf.frame.size.height, width: weakSelf.frame.size.width, height: weakSelf.config.alertViewHeight)
            }) {
                [weak self] (isFinished) in
                self?.removeFromSuperview()
            }
        }else{
            self.maskBackgroundView.alpha = 0
            self.alertView.frame = CGRect(x: 0, y: self.frame.size.height, width: self.frame.size.width, height: self.config.alertViewHeight)
            self.removeFromSuperview()
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

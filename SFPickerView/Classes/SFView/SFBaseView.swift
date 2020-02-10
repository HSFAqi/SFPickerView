//
//  SFBaseView.swift
//  SFPickerView_Example
//
//  Created by 黄山锋 on 2020/1/9.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

public struct SFConfig {
    public var superView: UIView?
    public var appearance: SFAlertViewAppearance = SFAlertViewAppearance()
    public var maskBackgroundColor: UIColor = UIColor.black.withAlphaComponent(0.3)
    public var isMaskEnabled: Bool = true
    public var isAnimated: Bool = true
    public var during: TimeInterval = 0.3
    public var alertViewHeight: CGFloat = 300
    public var isCallbackWhenSelecting: Bool = false
    public var rowHeight: CGFloat = 50
    // SFBaseCollectionView
    public var column: Int = 3
    public init() { }
}

public class SFBaseView: UIView {

    // MARK: - Property(public)
    public var config: SFConfig = SFConfig() {
        willSet{
            if newValue.alertViewHeight != config.alertViewHeight {
                alertView.frame = CGRect(x: 0, y: self.frame.size.height, width: self.frame.size.width, height: newValue.alertViewHeight)
                let contentView = alertView.contentView
                alertView.contentView = contentView
            }
        }
        didSet{
            customAppearanceSubviews()
        }
    }
    
    // MARK: - Property(internal)
    lazy var alertView: SFAlertView = {
        let view = SFAlertView(frame: self.bounds)
        return view
    }()
    var title: String? {
        willSet{
            alertView.title = newValue
        }
    }
    var isChanged: Bool = false // 是否有更改

    // MARK: - Property(private)
    private lazy var maskBackgroundView: UIView = {
        let view = UIView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapMaskAction))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
        view.alpha = 0
        return view
    }()
    public var isShow: Bool = false
    
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
        customFrameSubviews()
        customAppearanceSubviews()
        alertView.cancelBlock = {
            [weak self] in
            self?.dismiss()
        }
    }
    private func customFrameSubviews() {
        maskBackgroundView.frame = self.bounds
        alertView.frame = CGRect(x: 0, y: self.frame.size.height, width: self.frame.size.width, height: config.alertViewHeight)
    }
    private func customAppearanceSubviews() {
        maskBackgroundView.backgroundColor = config.maskBackgroundColor
        maskBackgroundView.isUserInteractionEnabled = config.isMaskEnabled
        alertView.appearance = config.appearance
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
                self?.updateFrameForAlertView(isShow: false)
            }
        }else{
            updateFrameForAlertView(isShow: false)
        }
        isShow = true
    }
    
    /// dismiss
    public func dismiss() {
        if config.isAnimated {
            UIView.animate(withDuration: config.during, animations: {
                [weak self] in
                self?.updateFrameForAlertView(isShow: true)
            }) {
                [weak self] (isFinished) in
                self?.removeFromSuperview()
            }
        }else{
            updateFrameForAlertView(isShow: true)
            self.removeFromSuperview()
        }
        isShow = false
    }
    
    /// 更新frame
    func updateFrameForAlertView(isShow: Bool) {
        if isShow {
            self.maskBackgroundView.alpha = 0
            self.alertView.frame = CGRect(x: 0, y: self.frame.size.height, width: self.frame.size.width, height: self.config.alertViewHeight)
        }else{
            self.maskBackgroundView.alpha = 1
            self.alertView.frame = CGRect(x: 0, y: self.frame.size.height-self.config.alertViewHeight, width: self.frame.size.width, height: self.config.alertViewHeight)
        }
    }
    
    /// 父视图
    private func addToView(_ view: UIView?) {
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

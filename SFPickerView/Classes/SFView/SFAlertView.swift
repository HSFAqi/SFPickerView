//
//  SFAlertView.swift
//  SFPickerView_Example
//
//  Created by 黄山锋 on 2020/1/9.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

public struct SFAlertViewAppearance {
    public var isCornerTop: Bool = true
    public var topViewBackgroundColor: UIColor = UIColor.white
    public var lineViewBackgroundColor: UIColor = UIColor(red: 230.00/255.00, green: 230.00/255.00, blue: 230.00/255.00, alpha: 1)
    public var contentViewBackgroundColor: UIColor = UIColor.white
    public var cancelBtnBackgroundColor: UIColor = UIColor.white
    public var cancelBtnTextColor: UIColor = UIColor.darkGray
    public var cancleBtnFont: UIFont = UIFont.systemFont(ofSize: 14)
    public var cancelBtnText: String = "取消"
    public var sureBtnBackgroundColor: UIColor = UIColor.white
    public var sureBtnTextColor: UIColor = UIColor.darkGray
    public var sureBtnFont: UIFont = UIFont.systemFont(ofSize: 14)
    public var sureBtnText: String = "确定"
    public var titleTextColor: UIColor = UIColor.darkGray
    public var titleFont: UIFont = UIFont.systemFont(ofSize: 14)
    // 也可传入自定义的button
    public var customCancleBtn: UIButton?
    public var customSureBtn: UIButton?
    public init() { }
}

public enum SFAlertStyle {
    case sheet
    case alert
}

public class SFAlertView: UIView {
    
    // MARK: - Property(internal)
    var contentView: UIView! = UIView(){
        willSet{
            contentView.removeFromSuperview()
            addSubview(newValue)
            newValue.frame = CGRect(x: 0, y: self.lineView.frame.maxY, width: self.frame.size.width, height: self.frame.size.height-self.lineView.frame.maxY)
        }
    }
    var title: String? {
        willSet{
            titleLabel.text = newValue
        }
    }
    var sureBlock: (() -> Void)?
    var cancelBlock: (() -> Void)?
    var appearance: SFAlertViewAppearance = SFAlertViewAppearance() {
        didSet{
            customAppearanceSubviews()
        }
    }

    // MARK: - Property(private)
    private lazy var cancelBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 8
        return btn
    }()
    private lazy var sureBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.addTarget(self, action: #selector(sureAction), for: .touchUpInside)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 8
        return btn
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    private lazy var topView: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var lineView: UIView = {
        let view = UIView()
        return view
    }()
    
    
    // MARK: - Initial
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override var frame: CGRect{
        didSet{
            customFrameSubviews()
        }
    }
    private func configUI() {
        backgroundColor = UIColor.white
        topView.addSubview(cancelBtn)
        topView.addSubview(sureBtn)
        topView.addSubview(titleLabel)
        addSubview(topView)
        addSubview(lineView)
        addSubview(contentView)
        customFrameSubviews()
        customAppearanceSubviews()
    }
    private func customFrameSubviews() {
        let topViewHeight: CGFloat = 40
        let padding: CGFloat = 5
        let btnWidth: CGFloat = 50
        topView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: topViewHeight)
        cancelBtn.frame = CGRect(x: padding, y: padding, width: btnWidth, height: topView.frame.size.height-padding*2)
        titleLabel.frame = CGRect(x: cancelBtn.frame.maxX+padding, y: padding, width: topView.frame.size.width-(btnWidth+2*padding)*2, height: topView.frame.size.height-padding*2)
        sureBtn.frame = CGRect(x: titleLabel.frame.maxX+padding, y: padding, width: btnWidth, height: topView.frame.size.height-padding*2)
        lineView.frame = CGRect(x: 0, y: topView.frame.maxY, width: self.frame.size.width, height: 1)
    }
    private func customAppearanceSubviews() {
        if appearance.isCornerTop {
            let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii:CGSize(width:10, height:10))
            let masklayer = CAShapeLayer()
            masklayer.frame = topView.bounds
            masklayer.path = maskPath.cgPath
            self.layer.mask = masklayer
        }else{
            self.layer.mask = nil
        }
        
        topView.backgroundColor = appearance.topViewBackgroundColor
        lineView.backgroundColor = appearance.lineViewBackgroundColor
        contentView.backgroundColor = appearance.contentViewBackgroundColor
        
        cancelBtn.backgroundColor = appearance.cancelBtnBackgroundColor
        cancelBtn.setTitleColor(appearance.cancelBtnTextColor, for: .normal)
        cancelBtn.titleLabel?.font = appearance.cancleBtnFont
        cancelBtn.setTitle(appearance.cancelBtnText, for: .normal)
        
        sureBtn.backgroundColor = appearance.sureBtnBackgroundColor
        sureBtn.setTitleColor(appearance.sureBtnTextColor, for: .normal)
        sureBtn.titleLabel?.font = appearance.sureBtnFont
        sureBtn.setTitle(appearance.sureBtnText, for: .normal)
        
        titleLabel.textColor = appearance.titleTextColor
        titleLabel.font = appearance.titleFont
        
        if let btn = appearance.customCancleBtn {
            let frame = cancelBtn.frame
            cancelBtn.removeFromSuperview()
            addSubview(btn)
            btn.frame = frame
            cancelBtn = btn
        }
        if let btn = appearance.customSureBtn {
            let frame = sureBtn.frame
            sureBtn.removeFromSuperview()
            addSubview(btn)
            btn.frame = frame
            sureBtn = btn
        }
    }
    
    // MARK: - Func
    
    /// 点击取消
    @objc private func cancelAction() {
        guard let block = cancelBlock else {
            return
        }
        block()
    }
    
    /// 点击确认
    @objc private func sureAction() {
        guard let block = sureBlock else {
            return
        }
        block()
    }

}

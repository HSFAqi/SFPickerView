//
//  SFPickerAlertView.swift
//  LuckyMascot
//
//  Created by 黄山锋 on 2019/12/30.
//  Copyright © 2019 黄山锋. All rights reserved.
//

import UIKit

public class SFPickerAlertView: UIView {
    
    // MARK: - Property
    public var contentView: UIView! = UIView(){
        willSet{
            contentView.removeFromSuperview()
            addSubview(newValue)
            newValue.frame = CGRect(x: 0, y: self.lineView.frame.maxY, width: self.frame.size.width, height: self.frame.size.height-self.lineView.frame.maxY)
        }
    }
    public var title: String? {
        willSet{
            titleLabel.text = newValue
        }
    }
    public var sureBlock: (() -> Void)?
    public var cancelBlock: (() -> Void)?

    // MARK: - Property(private)
    private lazy var cancelBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("取消", for: .normal)
        btn.setTitleColor(UIColor.darkGray, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        return btn
    }()
    private lazy var sureBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("确定", for: .normal)
        btn.setTitleColor(UIColor.darkGray, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(sureAction), for: .touchUpInside)
        return btn
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    private lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 240, green: 240, blue: 240, alpha: 1)
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
    private func configUI() {
        backgroundColor = UIColor.white
        topView.addSubview(cancelBtn)
        topView.addSubview(sureBtn)
        topView.addSubview(titleLabel)
        addSubview(topView)
        addSubview(lineView)
        addSubview(contentView)
        customFrameSubviews()
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

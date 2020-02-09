//
//  SFSearchView.swift
//  SFPickerView_Example
//
//  Created by 黄山锋 on 2020/2/6.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

public class SFSearchView: UIView {

    // MARK: - Property(internal)
    var didBeginSearch: (() -> Void)?
    var didSearching: ((String) -> Void)?
    var didEndSearch: (() -> Void)?
    
    // MARK: - Property(private)
    private(set) var isEditing: Bool = false
    private lazy var searchTextField: UITextField = {
        let textfield = UITextField()
        textfield.delegate = self
        textfield.backgroundColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1)
        textfield.returnKeyType = .search
        textfield.clearButtonMode = .whileEditing
        let attributedPlaceholder = NSAttributedString.init(string: "请输入关键字", attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        textfield.attributedPlaceholder = attributedPlaceholder
        textfield.leftViewMode = .always
        let image = UIImage.bundleImageWithName("sf_search")
        let imgView = UIImageView(image: image)
        imgView.contentMode = .scaleAspectFit
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        imgView.frame = CGRect(x: 8, y: 0, width: 20, height: 20)
        leftView.addSubview(imgView)
        textfield.leftView = leftView
        textfield.layer.masksToBounds = true
        textfield.layer.cornerRadius = 10
        return textfield
    }()
    private lazy var cancelBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("取消", for: .normal)
        btn.setTitleColor(UIColor.darkGray, for: .normal)
        btn.addTarget(self, action: #selector(cancelBtnAction), for: .touchUpInside)
        return btn
    }()
    

    // MARK: - Initial
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var frame: CGRect {
        didSet{
            configUI()
        }
    }
    
    // MARK: - ConfigUI
    func configUI() {
        addSubview(searchTextField)
        addSubview(cancelBtn)
        changeEditingStatus(false)
    }
    
    /// 更改编辑状态
    func changeEditingStatus(_ isEditing: Bool) {
        self.isEditing = isEditing
        UIView.animate(withDuration: 0.3) {
            [weak self] in
            guard let ws = self else {
                return
            }
            if isEditing {
                ws.cancelBtn.frame = CGRect(x: ws.frame.size.width-60-10, y: 0, width: 60, height: ws.frame.size.height)
                ws.searchTextField.frame = CGRect(x: 10, y: 10, width: ws.frame.size.width-60-20, height: ws.frame.size.height-20)
                ws.cancelBtn.alpha = 1
            }else{
                ws.cancelBtn.frame = CGRect(x: ws.frame.size.width, y: 0, width: 60, height: ws.frame.size.height)
                ws.searchTextField.frame = CGRect(x: 10, y: 10, width: ws.frame.size.width-20, height: ws.frame.size.height-20)
                ws.cancelBtn.alpha = 0
            }
        }
    }
    
    @objc func cancelBtnAction() {
        self.searchTextField.text = nil
        self.searchTextField.resignFirstResponder()
        changeEditingStatus(false)
        if let block = didEndSearch {
            block()
        }
    }
}

extension SFSearchView: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        changeEditingStatus(true)
        if let block = didBeginSearch {
            block()
        }
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let block = didSearching {
            block(textField.text ?? "")
        }
        return true
    }
}

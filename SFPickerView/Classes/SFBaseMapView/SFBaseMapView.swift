//
//  SFBaseTableView.swift
//  SFPickerView_Example
//
//  Created by 黄山锋 on 2020/2/3.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

public class SFBaseMapView: SFBaseView {
    
    // MARK: - Property(private)
    private lazy var mapView: MKMapView = {
        let view = MKMapView()
        view.mapType = .standard
        view.userTrackingMode = .follow
        view.showsUserLocation = true
        let span = MKCoordinateSpan.init(latitudeDelta: 0.021251, longitudeDelta: 0.016093)
        let region = MKCoordinateRegion.init(center: view.userLocation.coordinate, span: span)
        view.setRegion(region, animated: true)
        return view
    }()
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 5.0
        return manager
    }()
    
    // 外部传入的数据源
    private(set) var dataSource: Any?
    // 点击确定回调
    private var callbackBlock: ((Any?) -> Void)?
    
    public override var config: SFConfig {
        willSet{
            if newValue.rowHeight != config.rowHeight {
                mapView.frame = CGRect.zero
                alertView.contentView = mapView
            }
        }
    }
    override func configUI() {
        super.configUI()
        alertView.contentView = mapView
        getLocationAuthorization()
    }
    
    /// 授权定位权限
    func getLocationAuthorization() {
        guard CLLocationManager.locationServicesEnabled() else {
            SFAlertView.showAlert(title: "定位失败", message: "请开启定位服务", sureTitle: "好的") { (action) in
                let url = URL.init(string: UIApplication.openSettingsURLString)
                if UIApplication.shared.canOpenURL(url!) {
                    UIApplication.shared.openURL(url!)
                }
            }
            return
        }
        locationManager.requestWhenInUseAuthorization()
    }
    
    /// 授权提示
    private func showGrantAlert() {
        SFAlertView.showAlert(title: "定位失败", message: "请授权定位权限", sureTitle: "好的") { (action) in
            let url = URL.init(string: UIApplication.openSettingsURLString)
            if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.openURL(url!)
            }
        }
    }
    
    /// 【Base】类方法
    @discardableResult
    public final class func showMapWithTitle(_ title: String, dataSource: Any?, config: SFConfig?, callback: @escaping ((Any?) -> Void)) -> SFBaseMapView{
        let mapView = SFBaseMapView(frame: CGRect.zero)
        mapView.showMapWithTitle(title, dataSource: dataSource, config: config, callback: callback)
        return mapView
    }
    /// 【Base】对象方法
    public final func showMapWithTitle(_ title: String?, dataSource: Any?, config: SFConfig?, callback: @escaping ((Any?) -> Void)) {
        self.title = title
        self.dataSource = dataSource
        if let c = config {
            self.config = c
        }
        self.callbackBlock = callback
        show()
        self.alertView.sureBlock = {
            [weak self] in
            guard let ws = self else {
                return
            }
            if let callback = ws.callbackBlock {
                //callback(ws.selData)
            }
            ws.dismiss()
        }
    }
}

extension SFBaseMapView: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == .denied) {
            showGrantAlert()
        }else{
            locationManager.startUpdatingLocation()
        }
    }
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        SFAlertView.showAlert(title: "定位失败", message: nil, sureTitle: "重新定位") { (_) in
            self.locationManager.startUpdatingLocation()
        }
    }
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        let location = locations.last
        mapView.setCenter(location?.coordinate ?? mapView.userLocation.coordinate, animated: true)
    }
}



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

private let annotationId : String = "annotationId"
public class SFBaseMapView: SFBaseView {
    
    // MARK: - Property(private)
    private lazy var mapView: MKMapView = {
        let view = MKMapView(frame: CGRect.zero)
        view.mapType = .standard
        view.userTrackingMode = .follow
        view.showsUserLocation = true
        let span = MKCoordinateSpan.init(latitudeDelta: 0.021251, longitudeDelta: 0.016093)
        let region = MKCoordinateRegion.init(center: view.userLocation.coordinate, span: span)
        view.setRegion(region, animated: false)
        view.delegate = self
        return view
    }()
    private lazy var infoView: SFLocationInfoView = {
        let view = SFLocationInfoView.createViewFromNib()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        return view
    }()
    private lazy var locationBtn: UIButton = {
        let btn = UIButton(type: .custom)
        let bundle = Bundle.getBundle(forClass: SFBaseView.self as AnyClass, resource: "SFPickerView")
        let filePath = bundle?.path(forResource: "sf_location", ofType: ".png")
        let image = UIImage(contentsOfFile: filePath ?? "")
        btn.setImage(image, for: .normal)
        btn.addTarget(self, action: #selector(locationBtnAction), for: .touchUpInside)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 8
        btn.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        return btn
    }()
    private lazy var annotation : MKPointAnnotation = {
        let annot = MKPointAnnotation()
        annot.coordinate = self.mapView.userLocation.coordinate
        annot.title = "我在这里"
        return annot
    }()
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 5.0
        return manager
    }()
    private var callbackBlock: ((CLLocationCoordinate2D?, String?) -> Void)?
    private var coordinate: CLLocationCoordinate2D?
    private var address: String?
    
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
        self.config.alertViewHeight = 0.9 * UIScreen.main.bounds.height
        alertView.contentView = mapView
        mapView.addSubview(infoView)
        mapView.addSubview(locationBtn)
        infoView.frame = CGRect(x: 0, y: mapView.frame.size.height-120, width: mapView.frame.size.width, height: 120)
        locationBtn.frame = CGRect(x: mapView.frame.size.width-50, y: mapView.frame.size.height-120-50, width: 40, height: 40)
        getLocationAuthorization()
        mapView.addAnnotation(annotation)
    }
    
    /// 授权定位权限
    private func getLocationAuthorization() {
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
    
    /// 重新定位到当前位置
    @objc private func locationBtnAction() {
        mapView.setCenter(mapView.userLocation.coordinate, animated: false)
        let span = MKCoordinateSpan.init(latitudeDelta: 0.021251, longitudeDelta: 0.016093)
        let region = MKCoordinateRegion.init(center: mapView.userLocation.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    /// 【Base】类方法
    @discardableResult
    public final class func showMapWithTitle(_ title: String, config: SFConfig?, callback: @escaping ((CLLocationCoordinate2D?, String?) -> Void)) -> SFBaseMapView{
        let mapView = SFBaseMapView(frame: CGRect.zero)
        mapView.showMapWithTitle(title, config: config, callback: callback)
        return mapView
    }
    /// 【Base】对象方法
    public final func showMapWithTitle(_ title: String?, config: SFConfig?, callback: @escaping ((CLLocationCoordinate2D?, String?) -> Void)) {
        self.title = title
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
                callback(self?.coordinate, self?.address)
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
        if let location = locations.last {
            mapView.setCenter(location.coordinate, animated: false)
            getLocationInfos(location: location)
        }
    }
    private func getLocationInfos(location: CLLocation) {
        self.coordinate = location.coordinate
        self.infoView.longitude = String(location.coordinate.longitude)
        self.infoView.latitude = String(location.coordinate.latitude)
        // 地理位置编码
        let geo = CLGeocoder()
        geo.reverseGeocodeLocation(location) { (placemarks, error) in
            if let mark = placemarks?.first {
                let address = String(format: "%@%@%@%@", mark.administrativeArea ?? "", mark.locality ?? "", mark.subLocality ?? "", mark.name ?? "")
                self.infoView.location = address
                self.annotation.title = address
                self.address = address
            }
        }
    }
}
extension SFBaseMapView: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView: MKPinAnnotationView
        let reuseView: MKPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: annotationId) as? MKPinAnnotationView
        if let view = reuseView {
            annotationView = view
        }else{
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationId)
        }
        annotationView.pinColor = .red
        annotationView.animatesDrop = true
        annotationView.canShowCallout = true
        annotationView.calloutOffset = CGPoint.zero
        annotationView.contentMode = .scaleToFill
        return annotationView
    }
    
    public func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        annotation.coordinate = mapView.centerCoordinate
    }
    public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let location = CLLocation.init(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        getLocationInfos(location: location)
        mapView.selectAnnotation(annotation, animated: true)
    }
}



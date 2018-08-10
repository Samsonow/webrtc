//
//  LocationViewController.swift
//  SimpleWebRTC
//
//  Created by Evgen on 04.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import UIKit
import YandexMapKit
import KYDrawerController
import CoreLocation
import IQKeyboardManager

class LocationViewController: BaseViewController {

    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var mapView: YMKMapView!
    
    var centerLatitude: Double = 0
    var centerLongitude: Double = 0
    let networkService = NetworkService()

    let locationManager = CLLocationManager()
    
    var params: [String : Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLeftMenuButton()

        evo_drawerController?.screenEdgePanGestureEnabled = false
 
        
        isAuthorizedtoGetUserLocation()
        
        addressTextField.delegate = self
        
        mapView.mapWindow.map!.addCameraListener(with: self)
        
        if Storage.shared.user?.lat == 0 || Storage.shared.user?.lat == nil {
            if (CLLocationManager.locationServicesEnabled())
            {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.requestAlwaysAuthorization()
                locationManager.startUpdatingLocation()
                
            }
        } else {
            guard let lat = Storage.shared.user?.lat, let long = Storage.shared.user?.long else { return }
            
            let target = YMKPoint(latitude:  lat, longitude: long)
            let position = YMKCameraPosition.init(target: target, zoom: 15, azimuth: 0, tilt: 0)
            let animation = YMKAnimation(type: YMKAnimationType.smooth, duration: 0)
            
            mapView.mapWindow.map!.move(with: position, animationType: animation, cameraCallback: nil)
        }
        
        if let address = Storage.shared.user?.address1 {
            addressTextField.text = address
        }

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        evo_drawerController?.screenEdgePanGestureEnabled = true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -150 // Move view 150 points upward
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }
    
    //if we have no permission to access user location, then ask user for permission.
    func isAuthorizedtoGetUserLocation() {
        
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse     {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
 
    }
    @IBAction func setLocation(_ sender: Any) {
//        token: 42 # Авторизационный идентификатор пользователя
//        address1: "Москва, ул. Никольская, д. 15"
//        address2: "Рыжая дверь напротив туалета в левом крыле, стучать 3 раза"
//        lat: 12.1239
//        long: 14.1443
        guard let addressMain = addressTextField.text else {
            return
        }
        
        params = ["address1": addressMain, "address2": "", "lat": centerLatitude, "long": centerLongitude ]
        requst()

    }
    
    func requst() {
        networkService.setAddress(parameters: params).done { result in
            
            DispatchQueue.main.async {
                Storage.shared.user?.address1 = result.result.address1
                Storage.shared.user?.lat = result.result.lat
                Storage.shared.user?.long = result.result.long
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "MarketsViewController")
                let nav = UINavigationController(rootViewController: controller)
                evo_drawerController?.mainViewController = nav
                 evo_drawerController?.setDrawerState(.closed, animated: false)
            }
            
        }.catch { error in
            self.handleError(error: error, retry: self.requst)
        }
    }
    
}

extension LocationViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last! as CLLocation
        
        centerLatitude = location.coordinate.latitude
        centerLongitude = location.coordinate.longitude

        let target = YMKPoint(latitude:  location.coordinate.latitude, longitude: location.coordinate.longitude)
        let position = YMKCameraPosition.init(target: target, zoom: 15, azimuth: 0, tilt: 0)
        let animation = YMKAnimation(type: YMKAnimationType.smooth, duration: 0)
        
        mapView.mapWindow.map!.move(with: position, animationType: animation, cameraCallback: nil)
        locationManager.stopUpdatingLocation()
      
    }
    
}

extension LocationViewController: YMKMapCameraListener {
    
    func onCameraPositionChanged(with map: YMKMap?, cameraPosition: YMKCameraPosition, cameraUpdateSource: YMKCameraUpdateSource, finished: Bool) {
        
        //print(cameraPosition)
        print(centerLatitude)
        print(centerLongitude)
        print("///////")
        
        centerLatitude = cameraPosition.target.latitude
        centerLongitude = cameraPosition.target.longitude
    
    }
    
}

extension LocationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
}











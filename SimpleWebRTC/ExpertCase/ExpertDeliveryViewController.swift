//
//  ExpertDeliveryViewController.swift
//  SimpleWebRTC
//
//  Created by Evgen on 07.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import UIKit
import CoreLocation

class ExpertDeliveryViewController: BaseViewController {

    @IBOutlet weak var infoLable: UILabel!
    var timer: Timer?
    
    var channelId: Int = 0
    
    var centerLatitude: Double = 0
    var centerLongitude: Double = 0
    
    var network = NetworkService()
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        evo_drawerController?.screenEdgePanGestureEnabled = false
        //self.evo_drawerController?.openDrawerGestureModeMask = .panningNavigationBar
        self.navigationController?.isNavigationBarHidden = true
        if timer == nil {
            updateData()
            self.timer = Timer.scheduledTimer(timeInterval: 5, target: self,
                                              selector: #selector(self.updateData), userInfo: nil, repeats: true)
        }
        
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            
        }
        

    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        evo_drawerController?.screenEdgePanGestureEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @objc func updateData() {

        network.setPositionExpert(parameters: ["lat":centerLatitude, "long": centerLongitude])
        
        
        network.getChannelExpert(parameters: ["channel_id": self.channelId]).done { result in
            self.handelChangeChannel(chanel: result.result)
            
            self.infoLable.text = result.result.delivery_address
        }
    }
    
    private func handelChangeChannel(chanel: ChannelGet ) {
        switch chanel.state {
            
        case .REQUESTED:
            
            print("REQUESTED")
            
        case .REJECTED:
            
            print("REJECTED")
            
        case .CANCELLED:
            //я отменил
            print("CANCELLED")
            
        case .OPENED:
            print("OPENED")
            
        case .DELIVERY:
            print("DELIVERY")
            
        case .COMPLETED:
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ExpertMainViewController")
            let nav = UINavigationController(rootViewController: controller)
            evo_drawerController?.mainViewController = nav
            evo_drawerController?.setDrawerState(.closed, animated: true)

            print("COMPLETED")
            
        case .REFUSED:

            print("REFUSED")
            
        case .ARCHIVED:
            print("ARCHIVED")
            
        }
    }

}

extension ExpertDeliveryViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last! as CLLocation
        
        centerLatitude = location.coordinate.latitude
        centerLongitude = location.coordinate.longitude
        
        locationManager.stopUpdatingLocation()
        
    }
    
}


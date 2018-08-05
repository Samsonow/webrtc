//
//  MapClientViewController.swift
//  SimpleWebRTC
//
//  Created by Evgen on 06.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import UIKit
import YandexMapKit

class MapClientViewController: UIViewController {

    let networkService = NetworkService()
    var timer = Timer()
    var channel: ChannelGet!
     @IBOutlet weak var mapView: YMKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let target = YMKPoint(latitude:  channel.lat, longitude: channel.long)
        let position = YMKCameraPosition.init(target: target, zoom: 15, azimuth: 0, tilt: 0)
        let animation = YMKAnimation(type: YMKAnimationType.smooth, duration: 0)
        let pont = YMKPoint(latitude: channel.lat, longitude: channel.long)

        

        
        
        mapView.mapWindow.map!.move(with: position, animationType: animation, cameraCallback: nil)
        
        mapView.mapWindow.map!.mapObjects?.addPlacemark(with: pont)
        
        mapView.mapWindow.map!.addCameraListener(with: self)
        
        timer = Timer.scheduledTimer(timeInterval: 5, target: self,
                                        selector: #selector(self.timerAction), userInfo: nil, repeats: true)
        

        // Do any additional setup after loading the view.
    }
    
    @objc func timerAction() {
        networkService.getChannel(parameters: ["channel_id":channel.id]).done { result in
            self.channel = result.result
            
            let target = YMKPoint(latitude:  result.result.lat, longitude: result.result.long)
            let position = YMKCameraPosition.init(target: target, zoom: 15, azimuth: 0, tilt: 0)
            let animation = YMKAnimation(type: YMKAnimationType.smooth, duration: 0)
            let pont = YMKPoint(latitude: result.result.lat, longitude: result.result.long)
            
            
            //self.mapView.mapWindow.map!.mapObjects?.addPlacemark(with: pont)
            let image = UIImage(named: "marker")
            
            self.mapView.mapWindow.map!.mapObjects?.addPlacemark(with: pont, image: image)
            
            self.mapView.mapWindow.map!.move(with: position, animationType: animation, cameraCallback: nil)
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func okAction(_ sender: Any) {
        networkService.completeChannel(parameters: ["channel_id":channel.id]).done {
             self.performSegue(withIdentifier: "unwindSegueToVC1", sender: self)
        }
        
    }


}

extension MapClientViewController: YMKMapCameraListener {
    
    func onCameraPositionChanged(with map: YMKMap?, cameraPosition: YMKCameraPosition, cameraUpdateSource: YMKCameraUpdateSource, finished: Bool) {
        
  
        
    }
    
}



//
//  AppDelegate.swift
//  SimpleWebRTC
//
//  Created by Erdi Tunçalp on 21.01.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import UIKit
import DrawerController
import YandexMapKit
import IQKeyboardManager
import AlamofireNetworkActivityLogger

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let mapKitKey: String = "80c9b836-c8bb-40e5-a490-dacd8d2f4a8b"

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        YMKMapKit.setApiKey(mapKitKey)
        NetworkActivityLogger.shared.startLogging()
        
        NetworkActivityLogger.shared.level = .debug

        return true
    }
    
    func replaceWindow(_ newWindow: UIWindow) {
        if let oldWindow = window {
            newWindow.frame = oldWindow.frame
            newWindow.windowLevel = oldWindow.windowLevel
            newWindow.screen = oldWindow.screen
            newWindow.isHidden = false
            window = newWindow
            oldWindow.removeFromSuperview()
        }
    }
    


}


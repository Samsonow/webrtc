//
//  AppDelegate.swift
//  SimpleWebRTC
//
//  Created by Erdi Tunçalp on 21.01.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import UIKit
import KYDrawerController
import YandexMapKit
import IQKeyboardManager
import AlamofireNetworkActivityLogger

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let mapKitKey: String = "80c9b836-c8bb-40e5-a490-dacd8d2f4a8b"

    var window: UIWindow?
    let barAppearance = UIBarButtonItem.appearance()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        YMKMapKit.setApiKey(mapKitKey)
        NetworkActivityLogger.shared.startLogging()
        
        NetworkActivityLogger.shared.level = .debug
        
        let isFirst = Storage.shared.isFirstLaunch
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let startController: UIViewController
        print(isFirst)
        if isFirst {
            
            let storyboard = UIStoryboard(name: "PageControl", bundle: nil)
            startController = storyboard.instantiateInitialViewController()!
        } else {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            startController = storyboard.instantiateInitialViewController()!
        }
        
        self.window?.rootViewController = startController
        self.window?.makeKeyAndVisible()
        
//        let backImage = UIImage(named: "backIcon")
//        let backButtomImage = backImage?.stretchableImage(withLeftCapWidth: 0, topCapHeight: 5)
//        barAppearance.setBackButtonBackgroundImage(backButtomImage, for: .normal, barMetrics: .default)
        return true
    }
    
    func replaceWindow(_ new: UIViewController) {
        
//        UIView.transition(with: window!, duration: 0.5, options: .transitionFlipFromLeft, animations: {
//            let oldState: Bool = UIView.areAnimationsEnabled
//            UIView.setAnimationsEnabled(false)
//            self.window!.rootViewController = new
//            UIView.setAnimationsEnabled(oldState)
//
//        }, completion: { (finished: Bool) -> () in
//            self.window!.rootViewController = new
//            self.window?.makeKeyAndVisible()
//        })
       

        UIView.transition(from: window!.rootViewController!.view, to: new.view, duration: 0.6, options: [.curveEaseIn, .transitionFlipFromLeft], completion: {
            _ in
            self.window?.rootViewController = new
            self.window?.makeKeyAndVisible()

        })
//
        
//        var storyboard = UIStoryboard(name: "Main", bundle: nil)
//        var test = storyboard.instantiateViewController(withIdentifier: "MarketsViewController")
//
//        let mainViewController   = test
//
//
//        var droweViewController = storyboard.instantiateViewController(withIdentifier: "DroweViewControllerTest")
//
//        let drawerViewController = droweViewController
//        let drawerController     = KYDrawerController(drawerDirection: .left, drawerWidth: 300)
//        drawerController.mainViewController = UINavigationController(
//            rootViewController: mainViewController
//        )
//        drawerController.drawerViewController = drawerViewController
//
//
//
//
//        window = UIWindow(frame: UIScreen.main.bounds)
//        window?.rootViewController = drawerController
//        drawerController.setDrawerState(.opened, animated: false)
//        window?.makeKeyAndVisible()

    }
    
    
//    func replaceWindow(_ newWindow: UIWindow) {
//        if let oldWindow = window {
//            newWindow.frame = oldWindow.frame
//            newWindow.windowLevel = oldWindow.windowLevel
//            newWindow.screen = oldWindow.screen
//            newWindow.isHidden = false
//            window = newWindow
//            oldWindow.removeFromSuperview()
//        }
//    }
    


}


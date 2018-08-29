//
//  DroweViewController.swift
//  SimpleWebRTC
//
//  Created by Evgen on 04.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import UIKit
import KYDrawerController

class DroweViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var items: [String] = ["Set delivery address", "Market list", "Shoping list", "My orders", "Exit account"]
    let droweCellId: String = "DrawerCell"
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor.clear

        tableView.register(UINib(nibName: droweCellId, bundle: nil), forCellReuseIdentifier: droweCellId)

        self.navigationController?.isNavigationBarHidden = true
        evo_drawerController = self.parent as? KYDrawerController
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // change 2 to desired number of seconds
            self.handelDrawer()
        }
    }
    
    func handelDrawer() {
        if Storage.shared.user?.type == .expert {
            var storyboard = UIStoryboard(name: "Main", bundle: nil)
            var controller = storyboard.instantiateViewController(withIdentifier: "ExpertMainViewController")
            if let chanel = channelStart {
                
                if chanel.state == .DELIVERY {
                    controller = storyboard.instantiateViewController(withIdentifier: "ExpertDeliveryViewController")
                    (controller as! ExpertDeliveryViewController).channelId = chanel.id
                }
                
                if chanel.state == .OPENED {
                    controller = storyboard.instantiateViewController(withIdentifier: "ExpertWebRTCViewController")
                    (controller as! ExpertWebRTCViewController).channelId = chanel.id
                }
                
                if chanel.state == .REQUESTED {
                    controller = storyboard.instantiateViewController(withIdentifier: "ExpertChooseViewController")
                    (controller as! ExpertChooseViewController).channelId = chanel.id
                    
                }
            }
            
            let nav = UINavigationController(rootViewController: controller)
            evo_drawerController?.mainViewController = nav
            evo_drawerController?.mainSegueIdentifier = nil
        
            items =  ["Home page", "Set market" , "Exit account"]
            
        }
        
        if Storage.shared.user?.type == .seller {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "SelllerViewController")
            let nav = UINavigationController(rootViewController: controller)
            evo_drawerController?.mainViewController = nav
            
            
            items =  ["Exit account"]
        }
        
        if Storage.shared.user?.type == .client {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            var controller = storyboard.instantiateViewController(withIdentifier: "MarketsViewController")
            if let chanel = channelStart {
                
                if chanel.state == .DELIVERY {
                    controller = storyboard.instantiateViewController(withIdentifier: "MapClientViewController")
                    (controller as! MapClientViewController).channel = chanel
                }
                
                if chanel.state == .OPENED {
                    controller = storyboard.instantiateViewController(withIdentifier: "ViewController")
                    (controller as! ViewController).channelId = chanel.id
                }
                
                if chanel.state == .REQUESTED {
                    controller = storyboard.instantiateViewController(withIdentifier: "ChannelClientViewController")
                    (controller as! ChannelClientViewController).expertId = chanel.expert_id!
                    (controller as! ChannelClientViewController).channel = chanel
                }
            }
            
            let nav = UINavigationController(rootViewController: controller)
            
            evo_drawerController?.mainViewController = nav
            
        }

        evo_drawerController?.setDrawerState(.opened, animated: false)
        evo_drawerController?.setDrawerState(.closed, animated: false)
        tableView.reloadData()

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: droweCellId, for: indexPath) as! DrawerCell
        let index = indexPath.item
        cell.titleLabel.text = items[index]
        
        if items[index] == "Set delivery address" {
            cell.iconImage.image = UIImage(named: "addressIcon")
        }
        
        if items[index] == "Market list" || items[index] == "Set market" {
            cell.iconImage.image = UIImage(named: "marketIcon")
        }
        
        if items[index] == "Shoping list" {
            cell.iconImage.image = UIImage(named: "marketIcon")
        }
        
        if items[index] == "My orders" {
            cell.iconImage.image = UIImage(named: "myOrdersIcon")
        }
        
        if items[index] == "Exit account" {
            cell.iconImage.image = UIImage(named: "exitIcon")
        }

        return cell
    }
    
    //TODO: сделать один список с перечислениями
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if Storage.shared.user?.type == .seller {
            switch indexPath.row {
            case 0:
                Storage.shared.clearToken()
                self.gotoLogin()
                return
                
            default:
                return
            }
        }
        
        
        if Storage.shared.user?.type == .expert {
            switch indexPath.row {
            case 0:
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "ExpertMainViewController")
                let nav = UINavigationController(rootViewController: controller)
                evo_drawerController?.mainViewController = nav
                
                
                //self.evo_drawerController?.setCenter(nav, withCloseAnimation: true, completion: nil)
                return
                
            case 1:
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "MarketsViewController")
                let nav = UINavigationController(rootViewController: controller)
                evo_drawerController?.mainViewController = nav
                
            case 2:
                Storage.shared.clearToken()
                self.gotoLogin()
                return
                
            default:
                return
            }
            
            return
        }
        
        switch indexPath.row {
            
        case 0:
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "LocationViewController")
            let nav = UINavigationController(rootViewController: controller)
            evo_drawerController?.mainViewController = nav
            
            
        case 1:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "MarketsViewController")
            let nav = UINavigationController(rootViewController: controller)
            evo_drawerController?.mainViewController = nav
            
        case 2:
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ProductsViewController")
            let nav = UINavigationController(rootViewController: controller)
            evo_drawerController?.mainViewController = nav
            
            
        case 3:
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "OrdersViewController")
            let nav = UINavigationController(rootViewController: controller)
            evo_drawerController?.mainViewController = nav
            
            
        case 4:
            Storage.shared.clearToken()
            
            self.gotoLogin()
            
        default:
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "MarketsViewController")
            let nav = UINavigationController(rootViewController: controller)
            evo_drawerController?.mainViewController = nav
            
        }
        
        
        let currentCell = tableView.cellForRow(at: indexPath) as! DrawerCell
        currentCell.backgroundColor = UIColor.white
        currentCell.selectedView.isHidden = false

        evo_drawerController?.setDrawerState(.closed, animated: false)
    }
    
    func gotoLogin() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            
            let controller = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController()
            let newWindow = UIWindow()
            appDelegate.replaceWindow(controller!)
            newWindow.rootViewController = controller
        }
    }
    
    

    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let deselectedCell = tableView.cellForRow(at: indexPath) as! DrawerCell
        deselectedCell.backgroundColor = UIColor.clear
        deselectedCell.selectedView.isHidden = true
    }
    
    
    

    
}

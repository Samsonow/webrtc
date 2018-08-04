//
//  DroweViewController.swift
//  SimpleWebRTC
//
//  Created by Evgen on 04.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import UIKit
import DrawerController

class DroweViewController: UITableViewController {
    
    let items: [String] = ["Set delivery address", "Market list", "Shoping list", "My orders", "Exit account"]
    let droweCellId: String = "DrawerCell"
    
    override func viewDidLoad() {
        tableView.register(UINib(nibName: droweCellId, bundle: nil), forCellReuseIdentifier: droweCellId)
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        tableView.tableHeaderView = view
        self.navigationController?.isNavigationBarHidden = true
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: droweCellId, for: indexPath) as! DrawerCell
        let index = indexPath.item
        cell.titleLabel.text = items[index]
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 1:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "MarketsViewController")
            let nav = UINavigationController(rootViewController: controller)
            self.evo_drawerController?.setCenter(nav, withCloseAnimation: true, completion: nil)
        case 2:
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ProductsViewController")
            let nav = UINavigationController(rootViewController: controller)
            self.evo_drawerController?.setCenter(nav, withCloseAnimation: true, completion: nil)
            
        case 3:
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "OrdersViewController")
            let nav = UINavigationController(rootViewController: controller)
            self.evo_drawerController?.setCenter(nav, withCloseAnimation: true, completion: nil)

        default:
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "MarketsViewController")
            let nav = UINavigationController(rootViewController: controller)
            self.evo_drawerController?.setCenter(nav, withCloseAnimation: true, completion: nil)
        }
        
        
    }

    
}

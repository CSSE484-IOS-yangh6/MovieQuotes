//
//  SideNavViewController.swift
//  MovieQuotes
//
//  Created by Hanyu Yang on 2021/1/24.
//

import UIKit

class SideNavViewController: UIViewController {
    
    @IBAction func pressedGoToProfilePage(_ sender: Any) {
        
    }
    
    @IBAction func pressedShowAllQuotes(_ sender: Any) {
        tableViewController.isShowingAllQuotes = true
        tableViewController.startListening()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressedShowMyQuotes(_ sender: Any) {
        tableViewController.isShowingAllQuotes = false
        tableViewController.startListening()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressedDeleteQuotes(_ sender: Any) {
        
    }
    
    @IBAction func pressedSignOut(_ sender: Any) {
        
    }
    
    var tableViewController: MovieQuotesTableViewController {
        let navController = presentingViewController as! UINavigationController
        return navController.viewControllers.last as! MovieQuotesTableViewController
    }
}

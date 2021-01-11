//
//  TempViewController.swift
//  MovieQuotes
//
//  Created by Hanyu Yang on 2021/1/11.
//

import UIKit

class TempViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tempCellIdentifier = "TempCell"
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: tempCellIdentifier, for: indexPath)
        //Configure the cell
        cell.textLabel?.text = "This is row \(indexPath.row)"
        
    
        return cell
    }
    
    
}
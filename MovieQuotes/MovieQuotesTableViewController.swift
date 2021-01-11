//
//  MovieQuotesTableViewController.swift
//  MovieQuotes
//
//  Created by Hanyu Yang on 2021/1/11.
//

import UIKit

class MovieQuotesTableViewController: UITableViewController {
    let movieQuoteCellIdentifier = "MovieQuoteCell"
    var names = ["Dave", "Kristy", "McKinley", "Keegan", "Bowen", "Neala"]
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: movieQuoteCellIdentifier, for: indexPath)
        //Configure the cell
        cell.textLabel?.text = names[indexPath.row]
        return cell
    }
    
}

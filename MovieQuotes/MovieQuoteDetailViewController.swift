//
//  MovieQuoteDetailViewController.swift
//  MovieQuotes
//
//  Created by Hanyu Yang on 2021/1/11.
//

import UIKit
import Firebase

class MovieQuoteDetailViewController: UIViewController {
    
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var movieLabel: UILabel!
    
    var movieQuote: MovieQuote?
    var movieQuoteRef: DocumentReference!
    var movieQuoteListener: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @objc func showEditDialog() {
        let alertController = UIAlertController(title: "Edit this movie quote",
                                                message: "",
                                                preferredStyle: .alert)
        //Configure
        alertController.addTextField { (textField) in
            textField.placeholder = "Quote"
            textField.text = self.movieQuote?.quote
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Movie"
            textField.text = self.movieQuote?.movie
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel",
                                                style: .cancel,
                                                handler: nil))
        alertController.addAction(UIAlertAction(title: "Submit",
                                                style: .default)
        { (action) in
            let quoteTextField = alertController.textFields![0] as UITextField
            let movieTextField = alertController.textFields![1] as UITextField
//            self.movieQuote?.quote = quoteTextField.text!
//            self.movieQuote?.movie = movieTextField.text!
//            self.updateView()
            self.movieQuoteRef.updateData([
                "quote": quoteTextField.text!,
                "movie": movieTextField.text!
            ])
        })
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //updateView()
        movieQuoteListener = movieQuoteRef.addSnapshotListener { (documentSnapshot, error) in
            if let error = error {
                print("Error getting movie quote \(error)")
                return
            }
            if !documentSnapshot!.exists {
                print("Go Back")
                return
            }
            self.movieQuote = MovieQuote(documentSnapshot: documentSnapshot!)
            // Decide if we can edit or not!
            
            if Auth.auth().currentUser!.uid == self.movieQuote?.author {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                                    target: self,
                                                                    action: #selector(self.showEditDialog))
            } else {
                self.navigationItem.rightBarButtonItem = nil
            }
            self.updateView()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        movieQuoteListener.remove()
    }
    
    func updateView() {
        quoteLabel.text = movieQuote?.quote
        movieLabel.text = movieQuote?.movie
    }
    
}

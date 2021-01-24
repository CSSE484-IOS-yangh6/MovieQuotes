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
    
    @IBOutlet weak var authorBox: UIStackView!
    @IBOutlet weak var authorProfilePhotoImageView: UIImageView!
    
    @IBOutlet weak var authorNameLabel: UILabel!
    
    
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
        authorBox.isHidden = true
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
            
            // Get User Object
            UserManager.shared.beginListening(uid: self.movieQuote!.author, changeListener: self.updateAuthorBox)
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
    
    func updateAuthorBox() {
        authorBox.isHidden = UserManager.shared.name.isEmpty && UserManager.shared.photoUrl.isEmpty
        if (UserManager.shared.name.count > 0) {
            authorNameLabel.text = UserManager.shared.name
        } else {
            authorNameLabel.text = "unknown"
        }
        
        if (UserManager.shared.photoUrl.count > 0) {
            ImageUtils.load(imageView: authorProfilePhotoImageView, from: UserManager.shared.photoUrl)
        }
        authorNameLabel.text = UserManager.shared.name
    }
    
}

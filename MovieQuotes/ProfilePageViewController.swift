//
//  ProfilePageViewController.swift
//  MovieQuotes
//
//  Created by Hanyu Yang on 2021/1/24.
//

import UIKit
import Firebase

class ProfilePageViewController: UIViewController {
    
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    
    @IBOutlet weak var displayNameTextField: UITextField!
    
    
    override func viewDidLoad() {
        UserManager.shared.beginListening(uid: Auth.auth().currentUser!.uid, changeListener: updateView)
        displayNameTextField.addTarget(self, action: #selector(handleNameEdit), for: .editingChanged)
    }
    
    @objc func handleNameEdit(){
        if let name = displayNameTextField.text {
            UserManager.shared.updateName(name: name)
        }
    }
    
    @IBAction func pressedEditPhoto(_ sender: Any) {
        
    }
    
    func updateView() {
        displayNameTextField.text = UserManager.shared.name
    }
}

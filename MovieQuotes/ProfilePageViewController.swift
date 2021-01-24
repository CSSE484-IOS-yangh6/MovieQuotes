//
//  ProfilePageViewController.swift
//  MovieQuotes
//
//  Created by Hanyu Yang on 2021/1/24.
//

import UIKit

class ProfilePageViewController: UIViewController {
    
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    
    @IBOutlet weak var displayNameTextField: UITextField!
    
    
    override func viewDidLoad() {
        displayNameTextField.addTarget(self, action: #selector(handleNameEdit), for: .editingChanged)
    }
    
    @objc func handleNameEdit(){
        if let name = displayNameTextField.text {
            print(name)
        }
    }
    
    @IBAction func pressedEditPhoto(_ sender: Any) {
        
    }
}

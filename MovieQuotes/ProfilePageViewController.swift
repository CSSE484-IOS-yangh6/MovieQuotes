//
//  ProfilePageViewController.swift
//  MovieQuotes
//
//  Created by Hanyu Yang on 2021/1/24.
//

import UIKit
import Firebase
import FirebaseStorage

class ProfilePageViewController: UIViewController {
    
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    
    @IBOutlet weak var displayNameTextField: UITextField!
    
    override func viewDidLoad() {
        
        displayNameTextField.addTarget(self, action: #selector(handleNameEdit), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserManager.shared.beginListening(uid: Auth.auth().currentUser!.uid, changeListener: updateView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UserManager.shared.stopListening()
    }
    
    @objc func handleNameEdit(){
        if let name = displayNameTextField.text {
            UserManager.shared.updateName(name: name)
        }
    }
    
    @IBAction func pressedEditPhoto(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("On Real Device")
            imagePickerController.sourceType = .camera
        } else {
            print("Simulator")
            imagePickerController.sourceType = .photoLibrary
        }
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func updateView() {
        displayNameTextField.text = UserManager.shared.name
        if UserManager.shared.photoUrl.count > 0 {
            ImageUtils.load(imageView: profilePhotoImageView, from: UserManager.shared.photoUrl)
        }
    }
    
    func uploadImage(_ image: UIImage) {
        if let imageData = ImageUtils.resize(image: image) {
            
            let storageRef = Storage.storage().reference().child("Users").child(Auth.auth().currentUser!.uid)
            
            let uploadTask = storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                if let error = error {
                    print("Error Uploading Image: \(error)")
                    return
                }
                storageRef.downloadURL { (url, error) in
                    if let error = error {
                        print("error download URL: \(error)")
                        return
                    }
                    if let downloadUrl = url {
                        print("Got the download URL: \(downloadUrl)")
                        UserManager.shared.updatePhotoUrl(photoUrl: downloadUrl.absoluteString)
                    }
                }
            }
            
            uploadTask.observe(.progress) { (snapshot) in
                guard let progress = snapshot.progress else { return }
                print(progress)
            }
        } else {
            print("Error getting image data.")
        }
    }
}

extension ProfilePageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage? {
            //profilePhotoImageView.image = image
            uploadImage(image)
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage? {
            //profilePhotoImageView.image = image
            uploadImage(image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

//
//  ViewController.swift
//  Text me
//
//  Created by 서정 on 2021/01/18.
//

import UIKit
import MobileCoreServices

class MainViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var cameraBtn: UIButton!
    @IBOutlet var tableView: UITableView!
    
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    var captureImage: UIImage!
    var flagImgSave = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraBtn.layer.cornerRadius = 10
        tableView.layer.cornerRadius = 10
    }
    
    @IBAction func cameraCapture(_ sender: Any) {
        if(UIImagePickerController.isSourceTypeAvailable(.camera)){
            flagImgSave = true
            
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        } else {
            alertMsg("Camera inaccessable", message: "Application cannot access the camera")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info : [UIImagePickerController.InfoKey : Any]){
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
        
        if(mediaType.isEqual(to: kUTTypeImage as NSString as String)) {
            captureImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            
            if flagImgSave {
                UIImageWriteToSavedPhotosAlbum(captureImage, self, nil, nil)
            }
            
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    func alertMsg(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}


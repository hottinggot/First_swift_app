//
//  ViewController.swift
//  Text me
//
//  Created by 서정 on 2021/01/18.
//

import UIKit
import MobileCoreServices
import Vision

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var cameraBtn: UIBarButtonItem!
    
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    var captureImage: UIImage!
    var flagImgSave = false
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell){

            if let vc = segue.destination as? EditViewController {
                vc.memo = DataManager.shared.memoList[indexPath.row]
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    
        tableView.layer.cornerRadius = 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.memoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        let target = DataManager.shared.memoList[indexPath.row]
        
        cell.cellTitle.text = target.titleText
        cell.cellContents.text = target.titleText
        
        return cell
    }
    
    @IBAction func cameraCapture(_ sender: UIBarButtonItem) {
        if(UIImagePickerController.isSourceTypeAvailable(.camera)){
            flagImgSave = true
            
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = true
            
            present(imagePicker, animated: true, completion: nil)
        } else {
            alertMsg("Camera inaccessable", message: "Application cannot access the camera")
        }
    }
    
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info : [UIImagePickerController.InfoKey : Any]){
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
        if let editVc = storyboard?.instantiateViewController(identifier: "editView") {
            editVc.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
            self.present(editVc, animated: true, completion: nil)
        } else {
            alertMsg("Cannot do work", message: "problem was generated")
        }
        
        if(mediaType.isEqual(to: kUTTypeImage as NSString as String)) {
            captureImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            
//            if flagImgSave {
//
////                editViewController.refImage.image = captureImage
////                editViewController.detailTitle.text = "임시 제목"
//            }
            
        }
        
        self.dismiss(animated: true, completion: nil)
        //present(editViewController, animated: true, completion: nil)
        
    }
    
    
    func alertMsg(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}


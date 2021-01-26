//
//  ViewController.swift
//  Text me
//
//  Created by 서정 on 2021/01/18.
//

import UIKit
import MobileCoreServices

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var cameraBtn: UIBarButtonItem!
    
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    var flagImgSave = false
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell){
//
//            if let vc = segue.destination as? EditViewController {
//                vc.memo = DataManager.shared.memoList[indexPath.row]
//            }
//        }
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        getAllMemoList()
        tableView.reloadData()
    }
    
    var token: NSObjectProtocol?
    
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        token =  NotificationCenter.default.addObserver(forName: EditViewController.newMemoDidInsert, object: nil, queue: OperationQueue.main) {
            [weak self] (noti) in 
            self?.tableView.reloadData()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
    
        tableView.layer.cornerRadius = 10
    }
    
    func getAllMemoList() {
        DataManager.shared.fetchMemo()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.memoList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell

        let target = DataManager.shared.memoList
        cell.cellTitle.text = target[indexPath.row].titleText
        cell.cellContents.text = target[indexPath.row].mainText
        cell.cellImage.image = target[indexPath.row].refImage
        
        return cell

    }
    
    @IBAction func editing(_ sender: Any) {
        
    }
    @IBAction func cameraCapture(_ sender: UIBarButtonItem) {
        if(UIImagePickerController.isSourceTypeAvailable(.camera)){
            flagImgSave = true
            
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            //imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = true
            
            present(imagePicker, animated: true, completion: nil)
        } else {
            alertMsg("Camera inaccessable", message: "Application cannot access the camera")
        }
    }
    
    var captureImage: UIImage!
    
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info : [UIImagePickerController.InfoKey : Any]){
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
        
        guard let editVc = self.storyboard?.instantiateViewController(identifier: "editView") as? EditViewController else {
            return
        }
        
        
        if(mediaType.isEqual(to: kUTTypeImage as NSString as String)) {
            captureImage = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)!
            
           // save(captureImage)
            let newMemo = MemoVO()
            newMemo.refImage = captureImage
            newMemo.titleText = "새 메모"
            newMemo.mainText = ""
            newMemo.subText = ""
            
            editVc.memo = newMemo
            
            
        }
        
        self.dismiss(animated: true, completion: nil)
        self.present(editVc, animated: true, completion: nil)
        
    }
    
    
    func alertMsg(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}


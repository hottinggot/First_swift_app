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
    
    //Segueway
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell){

            if let editVc = segue.destination as? EditViewController {
                let detailMemo = MemoVO()
                let target = DataManager.shared.memoList[indexPath.row]
                detailMemo.isNew = false
                detailMemo.mainText = target.mainText
                detailMemo.subText = target.subText
                detailMemo.titleText = target.titleText
                detailMemo.upadateDate = target.updateDate
                if let image = target.refImage {
                    detailMemo.refImage = UIImage(data: image)
                }
                
                let indexNum = indexPath.row
                
                
                editVc.memo = detailMemo
                editVc.index = indexNum
            }
        }
    }
    
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
        
        //print("PRiNTSTRING : \(cell.cellContents.text as String?)")
        
        if let image = target[indexPath.row].refImage {
            cell.cellImage.image = UIImage(data: image)
        }
        
        return cell

    }
    
    //ios 11~
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title:  "삭제", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in

            DataManager.shared.deleteMemo(indexNum: indexPath.row)
            DataManager.shared.memoList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)

            success(true)

            })

        return UISwipeActionsConfiguration(actions:[deleteAction])

    }
    
    
    //~ios10 (deprecated)
    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//
//            let deleteAction = UITableViewRowAction(style: .destructive, title: "삭제") { action, index in
//
//                //하고싶은 작업
//
//            }
//
//            return [deleteAction]
//        }
    
    
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
            newMemo.isNew = true
            
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


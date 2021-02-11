//
//  SelectImageViewController.swift
//  Text me
//
//  Created by 서정 on 2021/02/02.
//

import UIKit

class SelectImageViewController: UIViewController {
    
    @IBOutlet var capturedImage: UIImageView!
    @IBOutlet var backBtn: UIButton!
    
    var receivedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        capturedImage.layer.cornerRadius = 5
        capturedImage.image = receivedImage
    }
    
    @IBAction func touchBackBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func touchSelectBtn(_ sender: Any) {
        guard let editVC = self.storyboard?.instantiateViewController(identifier: "editView") as? EditViewController else {
            return
        }
        
        let createdMemo = MemoVO()
        createdMemo.isNew = true
        createdMemo.refImage = receivedImage
        createdMemo.mainText = ""
        createdMemo.subText = ""
        
        editVC.memo = createdMemo
        
        present(editVC, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

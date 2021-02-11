//
//  EditViewController.swift
//  Text me
//
//  Created by 서정 on 2021/01/18.
//

import UIKit

class EditViewController: UIViewController, UITextViewDelegate{

    
    @IBOutlet var detailTitle: UITextField!
    @IBOutlet var mainTextView: UITextView!
    @IBOutlet var subTextView: UITextView!
    @IBOutlet var refImage: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var memo: MemoVO?
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTextView.layer.cornerRadius = 10
        subTextView.layer.cornerRadius = 10
        refImage.layer.cornerRadius = 5
        
        if let memo = memo {
            detailTitle.text = memo.titleText
            mainTextView.text = memo.mainText
            refImage.image = memo.refImage
            subTextView.text = memo.subText
            
            if(memo.isNew == true) {
                self.startAnimating()
                
            }
            
        }
        
        
        mainTextView.delegate = self
        //mainTextView.isEditable = false
        mainTextView.dataDetectorTypes = .link
        
        makeDoneAtToolbar()
        
    }
    
    private func makeDoneAtToolbar() {
        let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissMyKeyboard))
        
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        
        self.detailTitle.inputAccessoryView = toolbar
        self.mainTextView.inputAccessoryView = toolbar
        self.subTextView.inputAccessoryView = toolbar
        
    }
    
    @objc func dismissMyKeyboard() {
        view.endEditing(true)
        saveChanges()

    }
    
    private func saveChanges() {
        
        if let index = index {
            let target = DataManager.shared.memoList[index]
            target.mainText = mainTextView.text
            target.subText = subTextView.text
            target.titleText = detailTitle.text
            target.updateDate = Date()
            DataManager.shared.updateMemo()
            
        }
        memo?.mainText = mainTextView.text
        memo?.subText = subTextView.text
        memo?.titleText = detailTitle.text
    }
    
    private func startAnimating() {
        activityIndicator.startAnimating()
    }
    
    private func stopAnimating() {
        activityIndicator.stopAnimating()
    }
    
    
}
    


extension EditViewController {
    static let newMemoDidInsert = Notification.Name(rawValue: "newMemoDidInsert")
}



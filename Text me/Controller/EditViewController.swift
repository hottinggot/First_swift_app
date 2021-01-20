//
//  EditViewController.swift
//  Text me
//
//  Created by 서정 on 2021/01/18.
//

import UIKit

class EditViewController: UIViewController, UITextViewDelegate {

    
    @IBOutlet var detailTitle: UITextField!
    @IBOutlet var mainTextView: UITextView!
    @IBOutlet var subTextView: UITextView!
    @IBOutlet var refImage: UIImageView!
    @IBOutlet var navBackBtn: UINavigationItem!
    
    var memo: Memo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTextView.layer.cornerRadius = 10
        subTextView.layer.cornerRadius = 10
        refImage.layer.cornerRadius = 5
        //navBackBtn.backButtonTitle = "뒤로"
        
        detailTitle.text = memo?.titleText
        mainTextView.text = memo?.mainText
        
        //link
        //mainTextView.delegate = self
        //mainTextView.isEditable = false
        //mainTextView.dataDetectorTypes = .link
        
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

    }
    
    
    
    
}

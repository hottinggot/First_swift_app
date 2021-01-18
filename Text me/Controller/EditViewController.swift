//
//  EditViewController.swift
//  Text me
//
//  Created by 서정 on 2021/01/18.
//

import UIKit

class EditViewController: UIViewController {

    @IBOutlet var mainTextView: UITextView!
    @IBOutlet var subTextView: UITextView!
    @IBOutlet var refImage: UIImageView!
    @IBOutlet var navBackBtn: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTextView.layer.cornerRadius = 10
        subTextView.layer.cornerRadius = 10
        refImage.layer.cornerRadius = 5
        //navBackBtn.backButtonTitle = "뒤로"

    }
    
    
}

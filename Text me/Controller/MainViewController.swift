//
//  ViewController.swift
//  Text me
//
//  Created by 서정 on 2021/01/18.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet var cameraBtn: UIButton!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraBtn.layer.cornerRadius = 10
        tableView.layer.cornerRadius = 10
    }
}


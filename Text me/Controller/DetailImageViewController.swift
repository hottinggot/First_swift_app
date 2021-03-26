//
//  DetailImageViewController.swift
//  Text me
//
//  Created by 서정 on 2021/03/26.
//

import UIKit

class DetailImageViewController: UIViewController {
    
    var receivedImage: UIImage?
    var imageView  = UIImageView(frame: CGRect())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 0.4
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        
        view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        

        if let image = receivedImage {
            imageView.image = image
            imageView.widthAnchor.constraint(equalToConstant: image.size.width).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: image.size.height).isActive = true
        }
    }
    


}

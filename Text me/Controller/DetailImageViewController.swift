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
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        
        view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        

        if let image = receivedImage, let resizedImage = image.resize(targetSize: CGSize(width: view.frame.width - 40, height: view.frame.height - 110)) {
            imageView.image = resizedImage
            imageView.widthAnchor.constraint(equalToConstant: resizedImage.size.width).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: resizedImage.size.height).isActive = true
        }
    }
    


}

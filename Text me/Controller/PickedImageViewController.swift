//
//  PickedImageViewController.swift
//  Text me
//
//  Created by 서정 on 2021/03/02.
//

import UIKit

class PickedImageViewController: UIViewController {
    
    var pickedImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let outerView = UIView(frame: CGRect())
        view.addSubview(outerView)
        
        outerView.translatesAutoresizingMaskIntoConstraints = false
        
        
        if let pickedImage = pickedImage, let image = resize(image: pickedImage, to: CGSize(width: view.frame.size.width, height: view.frame.size.height-100) )  {
            outerView.heightAnchor.constraint(equalToConstant: image.size.height-40).isActive = true
            outerView.widthAnchor.constraint(equalToConstant: image.size.width-40).isActive = true
        }
        
        outerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        outerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        outerView.layer.shadowColor = UIColor.black.cgColor
        outerView.layer.shadowOpacity = 0.6
        outerView.layer.shadowRadius = 10
        outerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        outerView.layer.masksToBounds = false
        
        
       let  pickedImageView = UIImageView(image: pickedImage)
        pickedImageView.layer.cornerRadius = 10
        
        
        outerView.addSubview(pickedImageView)
        
        
        //constraint
        pickedImageView.translatesAutoresizingMaskIntoConstraints = false
        
        pickedImageView.centerXAnchor.constraint(equalTo: outerView.centerXAnchor).isActive = true
        pickedImageView.centerYAnchor.constraint(equalTo: outerView.centerYAnchor).isActive = true
        
        pickedImageView.heightAnchor.constraint(equalTo: outerView.heightAnchor).isActive = true
        pickedImageView.widthAnchor.constraint(equalTo: outerView.widthAnchor).isActive = true
        
        pickedImageView.layer.masksToBounds = true
        pickedImageView.layer.cornerRadius = 10
        
        
        
//        pickedImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        pickedImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
    }
    
    private func resize(image: UIImage, to targetSize: CGSize) -> UIImage? {
      let size = image.size

      let widthRatio  = targetSize.width  / size.width
      let heightRatio = targetSize.height / size.height

      // Figure out what our orientation is, and use that to form the rectangle.
      var newSize: CGSize
      if(widthRatio > heightRatio) {
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
      } else {
        newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
      }

      let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height + 1)

      UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
      image.draw(in: rect)
      let newImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()

      return newImage
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

//
//  PickedImageViewController.swift
//  Text me
//
//  Created by 서정 on 2021/03/02.
//

import UIKit
//import ImageIO
import Accelerate

class PickedImageViewController: UIViewController, ModalViewControllerDelegate {
    @IBOutlet var backBtn: UIButton!
    
    @IBOutlet var editBtn: UIButton!
    @IBOutlet var nextBtn: UIButton!
    
    var pickedImage: UIImage?
    let outerView = UIView(frame: CGRect())
    var pickedImageView: UIImageView!
    var scaledRatio: CGFloat!
    

    override func viewWillAppear(_ animated: Bool) {
        if let image = pickedImage {
            outerView.heightAnchor.constraint(equalToConstant: image.size.height).isActive = true
            outerView.widthAnchor.constraint(equalToConstant: image.size.width).isActive = true
            pickedImageView.heightAnchor.constraint(equalTo: outerView.heightAnchor).isActive = true
            pickedImageView.widthAnchor.constraint(equalTo: outerView.widthAnchor).isActive = true
            pickedImageView.image = pickedImage
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        editBtn.layer.cornerRadius = 8
        nextBtn.layer.cornerRadius = 8
        editBtn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        nextBtn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        view.addSubview(outerView)
        
        outerView.translatesAutoresizingMaskIntoConstraints = false
        
        
        if let pickedImage = pickedImage {
            
            if let image = pickedImage.resize(targetSize: CGSize(width: view.frame.size.width-40, height: view.frame.size.height-200)) {
                outerView.heightAnchor.constraint(equalToConstant: image.size.height).isActive = true
                outerView.widthAnchor.constraint(equalToConstant: image.size.width).isActive = true
                self.pickedImage = image
            }
            
        }
        
        outerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        outerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        outerView.layer.shadowColor = UIColor.black.cgColor
        outerView.layer.shadowOpacity = 0.6
        outerView.layer.shadowRadius = 10
        outerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        outerView.layer.masksToBounds = false
        
        
        pickedImageView = UIImageView(image: pickedImage)
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
        pickedImageView.contentMode = .scaleAspectFit
        
    }
    
    @IBAction func touchBackBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    var editingArea :UIView!
    var point1: UIView!
    var panGesture: UIPanGestureRecognizer!
    
    var currentMoveX: CGFloat!
    var currentMoveY: CGFloat!
    
    //var resizingArea: ResizingView!
    @IBAction func touchEditBtn(_ sender: Any) {
        
        guard let cropVC = self.storyboard?.instantiateViewController(identifier: "cropVC") as? CropViewController else {
            return
        }
        cropVC.delegate = self
        cropVC.modalPresentationStyle = .fullScreen
        cropVC.receivedImage = pickedImage
        
        present(cropVC, animated: true, completion: nil)


            
    }
    
    
    @IBAction func touchNextBtn(_ sender: Any) {
        guard let selectVC = self.storyboard?.instantiateViewController(identifier: "selectImageView") as? SelectImageViewController else {
            return
        }
        selectVC.receivedImage = pickedImage
        present(selectVC, animated: true, completion: nil)
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
    
    private func resizeImage(_ imageSize: CGSize, image: UIImage) -> Data {
        UIGraphicsBeginImageContext(imageSize)
        image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let resizedImage = newImage!.pngData()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    func sendData(image: UIImage) {
        self.pickedImage = image
    }
    
}

protocol ModalViewControllerDelegate
{
    func sendData(image: UIImage)
}

extension UIImage {

//    func resize(targetSize: CGSize) -> Data {
//
//        let widthRatio  = targetSize.width  / size.width
//        let heightRatio = targetSize.height / size.height
//
//        // Figure out what our orientation is, and use that to form the rectangle.
//        var newSize: CGSize
//        if(widthRatio > heightRatio) {
//          newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
//        } else {
//          newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
//        }
//
//        UIGraphicsBeginImageContext(newSize)
//        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        let resizedImage = newImage!.pngData()
//        UIGraphicsEndImageContext()
//        return resizedImage!
//    }
    
    func resize(targetSize: CGSize) -> UIImage? {

            let widthRatio  = targetSize.width  / size.width
            let heightRatio = targetSize.height / size.height

            // Figure out what our orientation is, and use that to form the rectangle.
            var newSize: CGSize
            if(widthRatio > heightRatio) {
              newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
            } else {
              newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
            }

            return UIGraphicsImageRenderer(size:newSize).image { _ in
                self.draw(in: CGRect(origin: .zero, size: newSize))
            }
        }

}

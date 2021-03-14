//
//  PickedImageViewController.swift
//  Text me
//
//  Created by 서정 on 2021/03/02.
//

import UIKit
import MetalKit

class PickedImageViewController: UIViewController {
    @IBOutlet var backBtn: UIButton!
    
    @IBOutlet var editBtn: UIButton!
    @IBOutlet var nextBtn: UIButton!
    
    var pickedImage: UIImage?
    let outerView = UIView(frame: CGRect())
    var pickedImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.addSubview(outerView)
        
        outerView.translatesAutoresizingMaskIntoConstraints = false
        
        
        if let pickedImage = pickedImage, let image = resize(image: pickedImage, to: CGSize(width: view.frame.size.width-40, height: view.frame.size.height-190) )  {
            outerView.heightAnchor.constraint(equalToConstant: image.size.height).isActive = true
            outerView.widthAnchor.constraint(equalToConstant: image.size.width).isActive = true
            self.pickedImage = image
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
        pickedImageView.layer.cornerRadius = 0;
            
//        editingArea = UIView(frame: CGRect())
//        editingArea.layer.borderColor = UIColor.red.cgColor
//        editingArea.layer.borderWidth = 2
//
//        pickedImageView.addSubview(editingArea)
//
//        editingArea.translatesAutoresizingMaskIntoConstraints = false
////        editingArea.leadingAnchor.constraint(equalTo: pickedImageView.leadingAnchor).isActive = true
////        editingArea.topAnchor.constraint(equalTo: pickedImageView.topAnchor).isActive = true
////        editingArea.trailingAnchor.constraint(equalTo: pickedImageView.trailingAnchor).isActive = true
////        editingArea.bottomAnchor.constraint(equalTo: pickedImageView.bottomAnchor).isActive = true
//
//        editingArea.widthAnchor.constraint(equalToConstant: pickedImageView.frame.width).isActive = true
//        editingArea.heightAnchor.constraint(equalToConstant: pickedImageView.frame.height).isActive = true
//        editingArea.centerXAnchor.constraint(equalTo: pickedImageView.centerXAnchor).isActive = true
//        editingArea.centerYAnchor.constraint(equalTo: pickedImageView.centerYAnchor).isActive = true
//
//
//        point1 = UIView(frame: CGRect())
//        point1.layer.cornerRadius = 20*0.5
//        point1.layer.backgroundColor = UIColor.black.cgColor
//        point1.isUserInteractionEnabled = true
//
//        view.addSubview(point1)
//
//        point1.translatesAutoresizingMaskIntoConstraints = false
//        point1.widthAnchor.constraint(equalToConstant: 20).isActive =  true
//        point1.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        point1.centerXAnchor.constraint(greaterThanOrEqualTo: outerView.centerXAnchor, constant: outerView.frame.width/2).isActive = true
//        point1.centerYAnchor.constraint(greaterThanOrEqualTo: outerView.centerYAnchor, constant: -outerView.frame.height/2 ).isActive = true
        
        
        let resizingArea = ResizingView(width: outerView.frame.width, height: outerView.frame.height, circleRadius: 20)
        
        outerView.addSubview(resizingArea)

//        resizingArea.translatesAutoresizingMaskIntoConstraints = false
//        resizingArea.centerXAnchor.constraint(equalTo: outerView.centerXAnchor).isActive = true
//        resizingArea.centerYAnchor.constraint(equalTo: outerView.centerYAnchor).isActive = true
        
//        panGesture = UIPanGestureRecognizer(target: self, action: #selector(cropAction))
//        panGesture.minimumNumberOfTouches = 1
//        panGesture.maximumNumberOfTouches = 1
//
//
//
//        point1.addGestureRecognizer(panGesture)
        
            
    }
    
    @objc func cropAction() {

        let translation = panGesture.translation(in: point1)
        point1.center = CGPoint(x: point1.center.x + translation.x, y: point1.center.y + translation.y)
        
        editingArea.center = CGPoint(x: editingArea.center.x + translation.x, y: editingArea.center.y + translation.y)
        
        if(panGesture.state == .began) {
            
        } else if (panGesture.state == .changed) {
            
        }
        
        panGesture.setTranslation(CGPoint.zero, in: point1)
        panGesture.setTranslation(CGPoint.zero, in: editingArea)

        
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
    
}

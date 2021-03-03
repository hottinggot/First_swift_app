//
//  SelectImageViewController.swift
//  Text me
//
//  Created by 서정 on 2021/02/02.
//

import UIKit

class SelectImageViewController: UIViewController {
       
    @IBOutlet var backBtn: UIButton!
    
    var receivedImage: UIImage?
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let outerView = UIView(frame: CGRect())
        view.addSubview(outerView)
        
        //outerView constraint
        outerView.translatesAutoresizingMaskIntoConstraints = false
        
        if let image = receivedImage {
            outerView.widthAnchor.constraint(equalToConstant: image.size.width-40).isActive = true
            outerView.heightAnchor.constraint(equalToConstant: image.size.height-40).isActive = true
        }
        
        outerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        outerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        outerView.layer.masksToBounds = false
        
        outerView.layer.shadowColor = UIColor.black.cgColor
        outerView.layer.shadowOpacity = 0.6
        outerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        outerView.layer.shadowRadius = 10
        
        let selectedImageView = UIImageView(image: receivedImage)
        outerView.addSubview(selectedImageView)
        
        selectedImageView.layer.masksToBounds = true
        selectedImageView.layer.cornerRadius = 10
         
        selectedImageView.translatesAutoresizingMaskIntoConstraints = false
        selectedImageView.centerXAnchor.constraint(equalTo: outerView.centerXAnchor).isActive = true
        selectedImageView.centerYAnchor.constraint(equalTo: outerView.centerYAnchor).isActive = true
        selectedImageView.heightAnchor.constraint(equalTo: outerView.heightAnchor).isActive = true
        selectedImageView.widthAnchor.constraint(equalTo: outerView.widthAnchor).isActive = true
        
        setUpActivityIndicator()
        
        
        if let image = receivedImage {
            detectBoundingBoxes(for: image)
            
        }
        
        
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
    
    private func detectBoundingBoxes(for image: UIImage) {
        GoogleCloudOCR().detect(from: image) { ocrResult in
            self.activityIndicator.stopAnimating()
            guard let ocrResult = ocrResult else {
                fatalError("Did not recognize any text int this message.")
            }
            //print("Found \(ocrResult.annotations.count) bounding box annotations in the image!")
            self.displayBoundingBoxes(for: ocrResult)
        }
    }
    
    private func setUpActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = UIColor.white
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.startAnimating()
    }
    
//    private func resize(image: UIImage, to targetSize: CGSize) -> UIImage? {
//      let size = image.size
//
//      let widthRatio  = targetSize.width  / size.width
//      let heightRatio = targetSize.height / size.height
//
//      // Figure out what our orientation is, and use that to form the rectangle.
//      var newSize: CGSize
//      if(widthRatio > heightRatio) {
//        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
//      } else {
//        newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
//      }
//
//      let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height + 1)
//
//      UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
//      image.draw(in: rect)
//      let newImage = UIGraphicsGetImageFromCurrentImageContext()
//      UIGraphicsEndImageContext()
//
//      return newImage
//    }
    
    private func displayBoundingBoxes(for ocrResult: OCRResult) {
      for annotation in ocrResult.annotations[1...] {
        let path = createBoundingBoxPath(along: annotation.boundingBox.vertices)
        let shape = shapeForBoundingBox(path: path)
        view.layer.addSublayer(shape)
      }
    }
    
    private func createBoundingBoxPath(along vertices: [Vertex]) -> UIBezierPath {
      let path = UIBezierPath()
      path.move(to: vertices[0].toCGPoint())
      for vertex in vertices[1...] {
        path.addLine(to: vertex.toCGPoint())
      }
      path.close()
      return path
    }

    private func shapeForBoundingBox(path: UIBezierPath) -> CAShapeLayer {
      let shape = CAShapeLayer()
      shape.lineWidth = 1
        shape.strokeColor = UIColor.purple.cgColor
      shape.fillColor = UIColor.purple.withAlphaComponent(0.1).cgColor
      shape.path = path.cgPath
      return shape
    }

}

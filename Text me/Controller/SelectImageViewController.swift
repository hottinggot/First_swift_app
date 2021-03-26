//
//  SelectImageViewController.swift
//  Text me
//
//  Created by 서정 on 2021/02/02.
//

import UIKit

class SelectImageViewController: UIViewController {
       
    @IBOutlet var backBtn: UIButton!
    
    var compressedImage: UIImage?
    var receivedImage: UIImage?
    var activityIndicator: UIActivityIndicatorView!
    let outerView = UIView(frame: CGRect())
    let selectedImageView = UIImageView(frame: CGRect())
    @IBOutlet var selectButton: UIButton!
    
    var memo = MemoVO()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        selectButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        selectButton.layer.cornerRadius = 8
        selectButton.isEnabled = false
        
        view.addSubview(outerView)
        
        //outerView constraint
        outerView.translatesAutoresizingMaskIntoConstraints = false
        
        if let image = receivedImage {
            //print("width: \(image.size.width), height: \(image.size.height)")
            outerView.widthAnchor.constraint(equalToConstant: image.size.width).isActive = true
            outerView.heightAnchor.constraint(equalToConstant: image.size.height).isActive = true
        }
        
        outerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        outerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        outerView.layer.masksToBounds = false
        
        outerView.layer.shadowColor = UIColor.black.cgColor
        outerView.layer.shadowOpacity = 0.6
        outerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        outerView.layer.shadowRadius = 10
        
        selectedImageView.image = receivedImage
        outerView.addSubview(selectedImageView)
        
        selectedImageView.layer.masksToBounds = true
        selectedImageView.layer.cornerRadius = 10
         
        selectedImageView.translatesAutoresizingMaskIntoConstraints = false
        selectedImageView.centerXAnchor.constraint(equalTo: outerView.centerXAnchor).isActive = true
        selectedImageView.centerYAnchor.constraint(equalTo: outerView.centerYAnchor).isActive = true
        selectedImageView.heightAnchor.constraint(equalTo: outerView.heightAnchor).isActive = true
        selectedImageView.widthAnchor.constraint(equalTo: outerView.widthAnchor).isActive = true
        
        setUpActivityIndicator()
        
        
        if let image = compressedImage {
            
//            print("view width: \(view.frame.size.width), view height: \(view.frame.size.height)")
//            print("width: \(image.size.width), height: \(image.size.height)")
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
        
        editVC.memo = self.memo
        
        present(editVC, animated: true, completion: nil)
    }
    
    private func detectBoundingBoxes(for image: UIImage) {
        GoogleCloudOCR().detect(from: image) { ocrResult in
            self.activityIndicator.stopAnimating()
            self.selectButton.isEnabled = true
            guard let ocrResult = ocrResult else {
                //fatalError("Did not recognize any text int this message.")
                //alert meaasge and dismiss
                return self.dismiss(animated: true, completion: nil)
                
            }
            //print("Found \(ocrResult.annotations.count) bounding box annotations in the image!")
            self.displayBoundingBoxes(for: ocrResult)
            self.memo = self.createMemoVO(for: ocrResult)
        }
    }
    
    private func setUpActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = UIColor.black
        outerView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.startAnimating()
    }

    
    private func displayBoundingBoxes(for ocrResult: OCRResult) {
      for annotation in ocrResult.annotations[1...] {
        let path = createBoundingBoxPath(along: annotation.boundingBox.vertices)
        let shape = shapeForBoundingBox(path: path)
        outerView.layer.addSublayer(shape)
        //selectedImageView.layer.addSublayer(shape)
      }
    }
    
    private func createBoundingBoxPath(along vertices: [Vertex]) -> UIBezierPath {
      let path = UIBezierPath()
//        if let scale = scale {
//            let to0 = CGPoint(x: vertices[0].x! * scale, y: vertices[0].y! * scale)
//        }
        
        print(vertices[0])
    
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
    
    private func createMemoVO(for ocrResult: OCRResult) -> MemoVO {
        
        let createdMemo = MemoVO()
        createdMemo.isNew = true
        createdMemo.mainText = ocrResult.annotations[0].text
        
        if let image = receivedImage {
            createdMemo.refImage = image
        }
        createdMemo.subText = ""
        
        return createdMemo
    }

}

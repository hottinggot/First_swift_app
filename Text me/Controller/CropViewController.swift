//
//  CropViewController.swift
//  Text me
//
//  Created by 서정 on 2021/03/15.
//

import UIKit



class CropViewController: UIViewController {
    
    var receivedImage: UIImage?
    let outerView = UIView(frame: CGRect())
    var imageView: UIImageView!
    var resizingArea: ResizingView!
   
    var okayBtn: UIButton!
    var restoreBtn: UIButton!
    
    var delegate: ModalViewControllerDelegate?


    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(outerView)
        outerView.translatesAutoresizingMaskIntoConstraints = false
        if let image = receivedImage {

            outerView.heightAnchor.constraint(equalToConstant: image.size.height).isActive = true
            outerView.widthAnchor.constraint(equalToConstant: image.size.width).isActive = true
            resizingArea = ResizingView(width: image.size.width, height: image.size.height, circleRadius: 20)
        }
        outerView.layer.masksToBounds = false
        outerView.layer.shadowColor = UIColor.black.cgColor
        outerView.layer.shadowOpacity = 0.6
        outerView.layer.shadowRadius = 10
        outerView.layer.shadowOffset = CGSize(width: 0, height: 0)

        outerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        outerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        imageView = UIImageView(image: receivedImage)
        imageView.layer.masksToBounds = true
        outerView.addSubview(imageView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: outerView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: outerView.centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: outerView.heightAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: outerView.widthAnchor).isActive = true
        
        outerView.addSubview(resizingArea)
        

//        cancelBtn = UIButton(frame: CGRect())
//        view.addSubview(cancelBtn)
        
        
    }
   
    @IBAction func touchBackBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func touchRestoreBtn(_ sender: Any) {
        resizingArea.removeFromSuperview()
        if let image = receivedImage {
            resizingArea = ResizingView(width: image.size.width, height: image.size.height, circleRadius: 20)
        }
        
        outerView.addSubview(resizingArea)
    }
    
    @IBAction func touchSelectBtn(_ sender: Any) {
        let rect: CGRect = CGRect(x: resizingArea.mainRect.frame.origin.x, y: resizingArea.mainRect.frame.origin.y, width: resizingArea.mainRect.frame.width, height: resizingArea.mainRect.frame.height)
        
        if let receivedImage = receivedImage {
            let image = cropImage(image: receivedImage, to: rect)
            if let delegate = self.delegate {
                delegate.sendData(image: image)
            }
            dismiss(animated: true, completion: nil)

        }
        
        
        
    }
    
    private func cropImage(image: UIImage, to rect: CGRect) -> UIImage {
            
        let cgCroppedImage = image.cgImage!.cropping(to: rect)!
        
        let croppedImage = UIImage(cgImage: cgCroppedImage)
        
        return croppedImage
    
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

//
//  CameraViewController.swift
//  Text me
//
//  Created by 서정 on 2021/02/01.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var previewView: UIView!
    @IBOutlet var photoLibraryBtn: UIButton!
    
    @IBOutlet var closeBtn: UIButton!
    
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    
    
    var previewViewMode: Int = 0
    
    var captureSession: AVCaptureSession!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var stillImageOutput: AVCapturePhotoOutput!
    
    var capturedImage: UIImage!
    
    override func viewDidAppear(_ animated: Bool) {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high
        
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
        else {
            print("Unable to access back camera!")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            
            stillImageOutput = AVCapturePhotoOutput()
            
            if(captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput)) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
            }
        } catch let error {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stackView.distribution = .fillProportionally
        
        closeBtn.setTitle("✕", for: .normal)
        closeBtn.setTitleColor(UIColor.white, for: .normal)
        closeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        
        
        
        
        let captureButton = UIButton(type: .custom)
        captureButton.frame = CGRect()
        captureButton.layer.cornerRadius = 0.5 * 70
        captureButton.clipsToBounds = true
        captureButton.layer.borderColor = UIColor.white.cgColor
        captureButton.layer.borderWidth = 3
        captureButton.addTarget(self, action: #selector(touchCaptureButton), for: .touchUpInside)
        
        
        view.addSubview(captureButton)
        
        //constraint(superview 에 붙인 후 작성)
        captureButton.translatesAutoresizingMaskIntoConstraints = false
        captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        captureButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        captureButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        captureButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        
        photoLibraryBtn.centerYAnchor.constraint(equalTo: captureButton.centerYAnchor).isActive = true
        
        
        //intrinsic(본질적인) 크기 설정
        
        let tempHeight = self.view.frame.height*2/3
        previewView.heightAnchor.constraint(equalToConstant: tempHeight).isActive = true
        
        switch previewViewMode {
        case 0:
            //downSubView.isHidden = true
            previewView.frame.size.height = self.view.frame.height
            
        case 1:
            //downSubView.isHidden = false
            previewView.frame.size.height = self.view.frame.height * 3/4
        default:
            previewView.frame.size.height = self.view.frame.height
        }

    }
    
    
    
    @IBAction func touchPhotoAlbumBtn(_ sender: Any) {
        if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("cannot access to photo album.")
        }
        
    }
    
    @IBAction func touchChangeRatioBtn(_ sender: Any) {
        
        if(previewViewMode == 0) {
            
            let downSubView = UIView()
            downSubView.layer.backgroundColor = UIColor.white.cgColor
//            downSubView.frame.size.height = (self.view.frame.height) - (self.view.frame.width * 4/3)
            
            //intrinsic(본질적인) 크기 설정
            
            let tempHeight = self.view.frame.width*4/3
            downSubView.heightAnchor.constraint(equalToConstant: tempHeight).isActive = true
            downSubView.isHidden = true
            previewViewMode = 1
            
            //previewView.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh+1, for: .vertical)
            
            stackView.addArrangedSubview(downSubView)
            UIView.animate(withDuration: 0.25, delay: 0, options: [], animations: {
                //self.previewView.frame.size.height = (self.view.frame.height) - (self.downSubView.frame.height)
                
                downSubView.isHidden = false
            })
            
            print("ratio button touched1")
        } else if (previewViewMode == 1) {
            
            if stackView.arrangedSubviews.count == 0 {
                return
            }
            
            let target = stackView.arrangedSubviews[stackView.arrangedSubviews.count-1]
            
            previewViewMode = 0
            
            UIView.animate(withDuration: 0.25, animations: {
                self.previewView.frame.size.height = self.view.frame.height
                target.isHidden = true
            }, completion: {_ in
                target.removeFromSuperview()
            })
            
        
            print("ratio button touched2")
            
        }
        
    }
    @IBAction func touchCloseBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    
    @objc func touchCaptureButton() {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
        
    }
    
   
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation()
        else {
            return
        }
        
        let image = UIImage(data: imageData)
        self.capturedImage = image
        
//        guard let pickedImageVC = self.storyboard?.instantiateViewController(identifier: "pickedImageView") as? PickedImageViewController else {
//            return
//        }
        
        
        fixOrientation(image: capturedImage, completion: { fixedImage -> Void in
            self.cropImage(image: fixedImage, to: 3/4, completion: { image -> Void in
                DispatchQueue.main.async {
                    let pickedImageVC = self.storyboard?.instantiateViewController(identifier: "pickedImageView") as? PickedImageViewController
                    
                    pickedImageVC?.pickedImage = image
                    self.present(pickedImageVC!, animated: true, completion: nil)
                }
            })
            
        })

        
    }
    
    private func setupLivePreview() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        previewView.layer.addSublayer(videoPreviewLayer)
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
            
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.previewView.bounds
            }
        }
    }
    
    private func changeView() {
        guard let selectVC = self.storyboard?.instantiateViewController(identifier: "selectImageView") as? SelectImageViewController else {
            return
        }
        selectVC.receivedImage = capturedImage
        self.captureSession.stopRunning()
        self.present(selectVC, animated: true, completion: nil)
        
    }
    
    private func fixOrientation(image: UIImage, completion: @escaping (UIImage) -> ()) {
        DispatchQueue.global(qos: .background).async {
            if(image.imageOrientation == .up) {
                completion(image)
            }
            UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
            
            let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
            
            image.draw(in: rect)
            let normalSizedImage = UIGraphicsGetImageFromCurrentImageContext()!
            
            UIGraphicsEndImageContext()
            completion(normalSizedImage)
        }
    }
   
    private func cropImage(image: UIImage, to aspectRatio: CGFloat, completion: @escaping (UIImage) -> ()) {
        
        DispatchQueue.global(qos: .background).async {
            let imageAspectRatio = image.size.height/image.size.width
            var newSize = image.size
            
            if imageAspectRatio > aspectRatio {
                newSize.height = image.size.height * aspectRatio
            } else {
                completion(image)
            }
            
            let cgCroppedImage = image.cgImage!.cropping(to: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: newSize.width, height: newSize.height)))!
            
            let croppedImage = UIImage(cgImage: cgCroppedImage)
            
            completion(croppedImage)
        }
    
    }

}

extension CameraViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        capturedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        guard let pickedImageVC = self.storyboard?.instantiateViewController(identifier: "pickedImageView") as? PickedImageViewController else {
            return
        }
        pickedImageVC.pickedImage = capturedImage
        
        self.dismiss(animated: true, completion: nil)
        
        self.present(pickedImageVC, animated: true, completion: nil)
    }
}

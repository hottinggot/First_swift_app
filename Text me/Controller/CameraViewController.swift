//
//  CameraViewController.swift
//  Text me
//
//  Created by 서정 on 2021/02/01.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {

    
    enum Ratio {
        case ratio9per16, ratio3per4, ratio1per1, ratio2per1
    }
    
    var constraintArray:[Ratio:[NSLayoutConstraint]] = [:]
    
    @IBOutlet var photoLibraryBtn: UIButton!
    @IBOutlet var cameraSwitchBtn: UIButton!
    
    @IBOutlet var closeBtn: UIButton!
    
    @IBOutlet var ratioButton: UIButton!
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    
    var beforePreviewViewMode: Ratio?
    var previewViewMode: Ratio = .ratio3per4
    var camera: Bool = true
    
    var captureSession: AVCaptureSession!
    var cameraDevice: AVCaptureDevice!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var stillImageOutput: AVCapturePhotoOutput!
    
    var capturedImage: UIImage!
    var previewView: UIView!
    
    override func viewDidAppear(_ animated: Bool) {
        reloadCamera()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        previewView = UIView()
        
        previewView.isHidden = false
        view.insertSubview(previewView, at: 0)
        previewView.translatesAutoresizingMaskIntoConstraints = false
        initializeConstaintDic()
        //print("DICTIONARY: \(constraintArray)")
        NSLayoutConstraint.activate(constraintArray[previewViewMode]!)
        ratioButton.setImage(UIImage(named: "ratio9per16_"), for: .normal)
        ratioButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        ratioButton.tintColor = UIColor.white

        
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
        cameraSwitchBtn.centerYAnchor.constraint(equalTo: captureButton.centerYAnchor).isActive = true
        
        
        
        //view.layoutIfNeeded()

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
    
    @IBAction func touchCameraSwitchBtn(_ sender: Any) {
        camera = !camera
        reloadCamera()
    }
    
    @IBAction func touchChangeRatioBtn(_ sender: Any) {
        switch previewViewMode {
        case .ratio9per16:
            beforePreviewViewMode = .ratio9per16
            previewViewMode = .ratio3per4
            //ratioButton.setImage(UIImage(named: "ratio9per16_"), for: .normal)
            ratioButton.setImage(UIImage(named: "ratio3per4_"), for: .normal)
            //setPreviewConstraint(before: .ratio9per16, ratio: .ratio3per4)
            
        case .ratio3per4:
            beforePreviewViewMode = .ratio3per4
            previewViewMode = .ratio1per1
            //ratioButton.setImage(UIImage(named: "ratio3per4_"), for: .normal)
            ratioButton.setImage(UIImage(named: "ratio1per1_"), for: .normal)
            //setPreviewConstraint(before: .ratio3per4, ratio: .ratio1per1)
            
        case .ratio1per1:
            beforePreviewViewMode = .ratio1per1
            previewViewMode = .ratio2per1
            //ratioButton.setImage(UIImage(named: "ratio1per1_"), for: .normal)
            ratioButton.setImage(UIImage(named: "ratio2per1_"), for: .normal)
            //setPreviewConstraint(before: .ratio1per1, ratio: .ratio2per1)
            
        case .ratio2per1:
            beforePreviewViewMode = .ratio2per1
            previewViewMode = .ratio9per16
            //ratioButton.setImage(UIImage(named: "ratio2per1_"), for: .normal)
            ratioButton.setImage(UIImage(named: "ratio9per16_"), for: .normal)
            //setPreviewConstraint(before: .ratio2per1, ratio: .ratio9per16)
            
        }
        setPreviewConstraint()
        
        
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
    
    private func reloadCamera() {
        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high
        
        if(camera == false) {
            guard let videoDevices = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
                print("Unable to access front camera!")
                return
            }
            self.cameraDevice = videoDevices
        } else {
            guard let videoDevices = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
                print("Unable to access front camera!")
                return
            }
            self.cameraDevice = videoDevices
        }
        
        
        do {
            let input = try AVCaptureDeviceInput(device: cameraDevice)
            
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
    
    private func initializeConstaintDic() {
        
        
        let width: NSLayoutConstraint = previewView.widthAnchor.constraint(equalTo: view.widthAnchor)
        let xAnchor: NSLayoutConstraint = previewView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        
        //9per16
        let height1 = previewView.heightAnchor.constraint(equalToConstant: view.frame.height)
        let top1 = previewView.topAnchor.constraint(equalTo: view.topAnchor)
        constraintArray.updateValue([top1, xAnchor, height1, width], forKey: .ratio9per16)
        
        //3per4
        let height2 = previewView.heightAnchor.constraint(equalToConstant: view.frame.width * 4/3)
        let top2 = previewView.topAnchor.constraint(equalTo: view.topAnchor)
        
        constraintArray.updateValue([top2, xAnchor, height2, width], forKey: .ratio3per4)
        
        //1per1
        let height3 = previewView.heightAnchor.constraint(equalToConstant: view.frame.width)
        let top3 = previewView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 1/8)
        constraintArray.updateValue([top3, xAnchor, height3, width], forKey: .ratio1per1)
        
        //2per1
        let height4 = previewView.heightAnchor.constraint(equalToConstant: view.frame.width/2)
        let top4 = previewView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 1/8)
       
        constraintArray.updateValue([top4, xAnchor, height4, width], forKey: .ratio2per1)
        
        
    }
    
    private func setPreviewConstraint() {

       
        if let before = beforePreviewViewMode, let constraint = constraintArray[before] {
            //print("BEFORE: \(constraint)")
            NSLayoutConstraint.deactivate(constraint)
            
        }
        
        
        NSLayoutConstraint.activate(self.constraintArray[previewViewMode]!)
           
        let constraints: [NSLayoutConstraint] = self.constraintArray[previewViewMode]!
        self.videoPreviewLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: constraints[2].constant)
        
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

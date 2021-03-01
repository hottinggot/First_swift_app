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
    
    @IBOutlet var downSubView: UIView!
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
    
    @IBAction func touchChangeRatioBtn(_ sender: Any) {
        
        if(previewViewMode == 0) {
            
            let downSubView = UIView()
            downSubView.layer.backgroundColor = UIColor.white.cgColor
//            downSubView.frame.size.height = (self.view.frame.height) - (self.view.frame.width * 4/3)
            
            //intrinsic(본질적인) 크기 설정
            
            let tempHeight = self.view.frame.height/3
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

    @IBAction func takePhoto(_ sender: Any) {
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
        
        changeView()
        
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

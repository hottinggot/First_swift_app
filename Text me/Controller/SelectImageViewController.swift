//
//  SelectImageViewController.swift
//  Text me
//
//  Created by 서정 on 2021/02/02.
//

import UIKit

class SelectImageViewController: UIViewController {
    
    @IBOutlet var capturedImage: UIImageView!
    @IBOutlet var backBtn: UIButton!
    
    var receivedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        capturedImage.layer.cornerRadius = 5
        capturedImage.image = receivedImage
        
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
            guard let ocrResult = ocrResult else {
                fatalError("Did not recognize any text int this message.")
            }
            print(ocrResult)
        }
    }
    
    func downsample(imageAt imageURL: URL,
                    to pointSize: CGSize,
                    scale: CGFloat = UIScreen.main.scale) -> UIImage? {

        // Create an CGImageSource that represent an image
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions) else {
            return nil
        }
        
        // Calculate the desired dimension
        let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
        
        // Perform downsampling
        let downsampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
        ] as CFDictionary
        guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
            return nil
        }
        
        // Return the downsampled image as UIImage
        return UIImage(cgImage: downsampledImage)
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

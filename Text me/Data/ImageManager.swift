//
//  ImageController.swift
//  Text me
//
//  Created by 서정 on 2021/02/07.
//

import Foundation
import UIKit
import ImageIO

class ImageManager {
    static let shared = ImageManager()
    
    let fileManager = FileManager.default
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    func saveImage(image: UIImage) -> String? {
        let date = String(Date.timeIntervalSinceReferenceDate)
        let imageName = date.replacingOccurrences(of: ".", with: "-") + ".png"
        
        if let imageData = image.pngData() {
            do {
                let filePath = documentsPath.appendingPathComponent(imageName)
                
                try imageData.write(to: filePath)
                
                print("\(imageName) was saved.")
                
                return imageName
                
            } catch let error as NSError {
                print("\(imageName) could not be saved : \(error)")
                
                return nil
            }
        } else {
            print("Could not convert UIImage to png data.")
            return nil
        }
    }
    
    func fetchImage(imageName:String, to pointSize: CGSize,
                    scale: CGFloat = UIScreen.main.scale) -> UIImage? {
        let imagePath = documentsPath.appendingPathComponent(imageName).path
        
    
        guard fileManager.fileExists(atPath: imagePath) else {
            print("Image does not exist at path: \(imagePath)")
            
            return nil
            
        }
        
//        if let imageData = UIImage(contentsOfFile: imagePath) {
//            return imageData
//        } else {
//            print("UIImage could not be created.")
//            return nil
//        }
        
        
        
        
            if let resizedImage = downsample(imageAt:  URL(fileURLWithPath: imagePath), to: pointSize){
                print("Returned downSample Image.")
                return resizedImage
            }
            else {
                print("Cannot downSample Image.")
                return nil
            }
        
    }
    
    func deleteImage(imageName: String) {
        let imagePath = documentsPath.appendingPathComponent(imageName)
        
        guard fileManager.fileExists(atPath: imagePath.path) else {
            print("Image does not exist at path: \(imagePath)")
            
            return
        }
        
        do {
            try fileManager.removeItem(at: imagePath)
            
            print("\(imageName) was deleted.")
        } catch let error as NSError {
            print("Could not delete \(imageName): \(error)")
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
        
    
}

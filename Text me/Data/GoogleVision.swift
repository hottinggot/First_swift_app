//
//  GoogleVision.swift
//  Text me
//
//  Created by 서정 on 2021/02/11.
//

import Foundation
import UIKit
import Alamofire

class GoogleCloudOCR {
    private let apiKey = "API KEY"
    private var apiURL: URL {
        return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(apiKey)")!
    }
    
    func detect(from image: UIImage, completion: @escaping (OCRResult?) -> Void) {
        
        guard let resizedImage = downsample(image: image, to: CGSize(width: image.size.width, height: image.size.height)) else {
            return
        }
        
        print("RS: \(image.size.width) \(image.size.height) \(resizedImage.size.width), \(resizedImage.size.height)")
        guard let base64Image = base64EncodeImage(resizedImage) else {
          print("Error while base64 encoding image")
          completion(nil)
          return
        }
        callGoogleVisionAPI(with: base64Image, completion: completion)
        
    }
    
    private func callGoogleVisionAPI(with base64EncodeImage: String, completion: @escaping (OCRResult?) -> Void) {
        let parameters: Parameters = [
            "requests" : [
                "image" : [
                    "content" : base64EncodeImage
                ],
                "features" : [
                    [
                        "type" : "TEXT_DETECTION"
                    ]
                ]
            ]
        ]
        
        let headers: HTTPHeaders = [
            "X-Ios-Bundle-Identifier" : Bundle.main.bundleIdentifier ?? "",
        ]
        
        AF.request(
            apiURL,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        ).responseData {response in
            
            switch response.result {
            case .success(let data):
                
                let ocrResponse = try? JSONDecoder().decode(GoogleCloudOCRResponse.self, from: data)
                
                completion(ocrResponse?.responses[0])
                
            case .failure(let error):
                print(error)
                completion(nil)
                return
            }
        
        }
    }
    
    private func base64EncodeImage(_ image: UIImage) -> String? {
        return image.pngData()?.base64EncodedString(options: .endLineWithCarriageReturn)
    }
    
    private func downsample(image : UIImage,
                    to pointSize: CGSize,
                    scale: CGFloat = UIScreen.main.scale) -> UIImage? {

        // Create an CGImageSource that represent an image
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithData(image.pngData()! as CFData, imageSourceOptions) else {
            return nil
        }
        
        // Calculate the desired dimension
        let maxDimensionInPixels = max(pointSize.width, pointSize.height)
        
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



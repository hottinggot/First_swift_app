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
    private let apiKey = "AIzaSyDpXgFeqpoWUqO0Ob4ASuFXK1F8uIdDDaQ"
    private var apiURL: URL {
        return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(apiKey)")!
    }
    
    func detect(from image: UIImage, completion: @escaping (OCRResult?) -> Void) {
        guard let base64Image = base64EncodeImage(image) else {
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

}



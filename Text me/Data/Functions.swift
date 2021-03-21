//
//  File.swift
//  Text me
//
//  Created by 서정 on 2021/03/21.
//

import Foundation
import UIKit

class Functions {
    func alertMsg(_ title: String, message: String, from: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        
        alert.addAction(action)
        from.present(alert, animated: true, completion: nil)
    }
}

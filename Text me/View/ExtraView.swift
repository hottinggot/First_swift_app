//
//  ExtraView.swift
//  Text me
//
//  Created by 서정 on 2021/03/15.
//

import UIKit

class ExtraView: UIView {
    
    init(originX: CGFloat, originY: CGFloat, width: CGFloat, height: CGFloat) {
        super.init(frame: CGRect(x: originX, y: originY, width: width, height: height))
        
        self.layer.backgroundColor = UIColor.init(displayP3Red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

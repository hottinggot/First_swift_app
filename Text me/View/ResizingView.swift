//
//  resizingView.swift
//  Text me
//
//  Created by 서정 on 2021/03/14.
//

import UIKit

class ResizingView: UIView {

    static var kResizeThumbSize:CGFloat = 44.0
    private typealias `Self` = ResizingView

    var rect: UIView!
    var point1: UIView!

    var isResizingLeftEdge:Bool = false
    var isResizingRightEdge:Bool = false
    var isResizingTopEdge:Bool = false
    var isResizingBottomEdge:Bool = false

    var isResizingBottomRightCorner:Bool = false
    var isResizingLeftCorner:Bool = false
    var isResizingRightCorner:Bool = false
    var isResizingBottomLeftCorner:Bool = false


        //Define your initialisers here
    
    init(width: CGFloat, height:CGFloat, circleRadius:CGFloat ) {
        
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        
        rect = UIView(frame: CGRect())
        point1 = UIView(frame: CGRect())
        


        
        self.rect.frame.size.width = width
        self.rect.frame.size.height = height
        self.rect.layer.borderWidth = 2
        self.rect.layer.borderColor = UIColor.red.cgColor
        
        self.point1.frame.size.width = circleRadius
        self.point1.frame.size.height = circleRadius
        self.point1.layer.cornerRadius = 0.5 * circleRadius
        self.point1.layer.backgroundColor = UIColor.black.cgColor
        
        self.addSubview(rect)
        self.addSubview(point1)
        
        self.isHidden = false
        
    }
    

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)

            isResizingBottomRightCorner = (self.bounds.size.width - currentPoint.x < Self.kResizeThumbSize && self.bounds.size.height - currentPoint.y < Self.kResizeThumbSize);
            isResizingLeftCorner = (currentPoint.x < Self.kResizeThumbSize && currentPoint.y < Self.kResizeThumbSize);
            isResizingRightCorner = (self.bounds.size.width-currentPoint.x < Self.kResizeThumbSize && currentPoint.y < Self.kResizeThumbSize);
            isResizingBottomLeftCorner = (currentPoint.x < Self.kResizeThumbSize && self.bounds.size.height - currentPoint.y < Self.kResizeThumbSize);

            isResizingLeftEdge = (currentPoint.x < Self.kResizeThumbSize)
            isResizingTopEdge = (currentPoint.y < Self.kResizeThumbSize)
            isResizingRightEdge = (self.bounds.size.width - currentPoint.x < Self.kResizeThumbSize)

            isResizingBottomEdge = (self.bounds.size.height - currentPoint.y < Self.kResizeThumbSize)

            // do something with your currentPoint
            

        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            // do something with your currentPoint
            
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            // do something with your currentPoint


            isResizingLeftEdge = false
             isResizingRightEdge = false
             isResizingTopEdge = false
             isResizingBottomEdge = false

             isResizingBottomRightCorner = false
             isResizingLeftCorner = false
             isResizingRightCorner = false
             isResizingBottomLeftCorner = false

        }
    }
//
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}



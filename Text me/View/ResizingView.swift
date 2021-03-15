//
//  resizingView.swift
//  Text me
//
//  Created by 서정 on 2021/03/14.
//

import UIKit

class ResizingView: UIView {

    static var kResizeThumbSize:CGFloat = 40.0
    private typealias `Self` = ResizingView
    
    var defaultHeight : CGFloat!
    var defaultwidth: CGFloat!
    var mainRect: UIView!
    var upExtra: ExtraView!
    var downExtra: ExtraView!
    var leftExtra: ExtraView!
    var rightExtra: ExtraView!

    enum Edge {
        case topLeft, topRight, bottomLeft, bottomRight, none, bottom, top, right, left
    }
    
    var currentEdge: Edge = .none


        //Define your initialisers here
    
    init(width: CGFloat, height:CGFloat, circleRadius:CGFloat ) {
        
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        
        mainRect = UIView(frame: CGRect())
        upExtra = ExtraView(originX: 0, originY: 0, width: 0, height: 0)
        downExtra = ExtraView(originX: 0, originY: 0, width: 0, height: 0)
        leftExtra = ExtraView(originX: 0, originY: 0, width: 0, height: 0)
        rightExtra = ExtraView(originX: 0, originY: 0, width: 0, height: 0)

        self.defaultwidth = width
        self.defaultHeight = height
        
        self.mainRect.frame.size.width = width
        self.mainRect.frame.size.height = height
        self.mainRect.layer.borderWidth = 2
        self.mainRect.layer.borderColor = UIColor.red.cgColor
        
        self.mainRect.isHidden = false
        
        
        self.addSubview(mainRect)
        self.addSubview(upExtra)
        self.addSubview(downExtra)
        self.addSubview(leftExtra)
        self.addSubview(rightExtra)
        
    }
    

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: self.mainRect)

            // do something with your currentPoint
            
            currentEdge = {
                if(self.mainRect.bounds.size.width - currentPoint.x < Self.kResizeThumbSize && self.mainRect.bounds.size.height - currentPoint.y < Self.kResizeThumbSize) {
                    return .bottomRight
                } else if (currentPoint.x < Self.kResizeThumbSize && self.mainRect.bounds.size.height - currentPoint.y < Self.kResizeThumbSize) {
                    return .bottomLeft
                } else if (currentPoint.x < Self.kResizeThumbSize && currentPoint.y < Self.kResizeThumbSize) {
                    return .topLeft
                } else if (self.mainRect.bounds.size.width - currentPoint.x < Self.kResizeThumbSize && currentPoint.y < Self.kResizeThumbSize) {
                    return .topRight
                } else if(self.mainRect.bounds.size.width - currentPoint.x < Self.kResizeThumbSize) {
                    return .right
                } else if(currentPoint.x < Self.kResizeThumbSize) {
                    return .left
                } else if(currentPoint.y < Self.kResizeThumbSize) {
                    return .top
                } else if (self.mainRect.bounds.size.height - currentPoint.y < Self.kResizeThumbSize) {
                    return .bottom
                } else {
                    return .none
                }
            }()
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            let previousPoint = touch.previousLocation(in: self)
            // do something with your currentPoint
            
            let originX = self.mainRect.frame.origin.x
            let originY = self.mainRect.frame.origin.y
            
            let deltaWidth = currentPoint.x - previousPoint.x
            let deltaHeight = currentPoint.y - previousPoint.y
            
            let width = self.mainRect.frame.size.width
            let height = self.mainRect.frame.size.height
            
            var newInfo: FrameInfo!
            
            switch currentEdge {
            case .bottomRight:
                newInfo = calOriginPoint(originX: originX, originY: originY, width: width + deltaWidth, height: height + deltaHeight, moving: false)
                self.mainRect.frame = CGRect(x: newInfo.originX , y: newInfo.originY , width: newInfo.width, height: newInfo.height)
                
            case .bottomLeft:
                newInfo = calOriginPoint(originX: originX + deltaWidth, originY: originY, width: width - deltaWidth, height: height + deltaHeight, moving: false)
                self.mainRect.frame = CGRect(x: newInfo.originX , y: newInfo.originY , width: newInfo.width, height: newInfo.height)
                
            case .topLeft:
                newInfo = calOriginPoint(originX: originX + deltaWidth, originY: originY + deltaHeight, width: width - deltaWidth, height: height - deltaHeight, moving: false)
                self.mainRect.frame = CGRect(x: newInfo.originX , y: newInfo.originY , width: newInfo.width, height: newInfo.height)
                
            case .topRight:
                newInfo = calOriginPoint(originX: originX, originY: originY + deltaHeight, width: width + deltaWidth, height: height - deltaHeight, moving: false)
                self.mainRect.frame = CGRect(x: newInfo.originX , y: newInfo.originY , width: newInfo.width, height: newInfo.height)
                
            case .top:
                newInfo = calOriginPoint(originX: originX, originY: originY + deltaHeight, width: width, height: height - deltaHeight, moving: false)
                self.mainRect.frame = CGRect(x: newInfo.originX , y: newInfo.originY , width: newInfo.width, height: newInfo.height)
                
            case .bottom:
                newInfo = calOriginPoint(originX: originX, originY: originY, width: width, height: height + deltaHeight, moving: false)
                self.mainRect.frame = CGRect(x: newInfo.originX , y: newInfo.originY , width: newInfo.width, height: newInfo.height)
                
            case .left:
                newInfo = calOriginPoint(originX: originX + deltaWidth, originY: originY, width: width - deltaWidth, height: height, moving: false)
                self.mainRect.frame = CGRect(x: newInfo.originX , y: newInfo.originY , width: newInfo.width, height: newInfo.height)
                
            case .right:
                newInfo = calOriginPoint(originX: originX, originY: originY, width: width + deltaWidth, height: height, moving: false)
                self.mainRect.frame = CGRect(x: newInfo.originX , y: newInfo.originY , width: newInfo.width, height: newInfo.height)
            default:
                newInfo = calOriginPoint(originX: originX + deltaWidth, originY: originY + deltaHeight, width: width , height: height, moving: true)
                self.mainRect.frame = CGRect(x: newInfo.originX , y: newInfo.originY , width: newInfo.width, height: newInfo.height)
            }
            
            self.upExtra.frame = CGRect(x: newInfo.originX, y: 0, width: newInfo.width, height: newInfo.originY)
            self.downExtra.frame = CGRect(x: newInfo.originX, y: newInfo.originY + newInfo.height , width: newInfo.width, height: self.defaultHeight - (newInfo.originY + newInfo.height))
            self.rightExtra.frame = CGRect(x: newInfo.originX + newInfo.width, y: 0, width: self.defaultwidth - (newInfo.originX + newInfo.width), height: self.defaultHeight)
            self.leftExtra.frame = CGRect(x: 0, y: 0, width: newInfo.originX, height: self.defaultHeight)
        
            
            
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let touch = touches.first {
//
//        }
        currentEdge = .none
    }
    
    private func calOriginPoint(originX: CGFloat, originY: CGFloat, width: CGFloat, height: CGFloat, moving: Bool) -> FrameInfo {
        var newInfo: FrameInfo = FrameInfo(originX: 0, originY: 0, height: 0, width: 0)
        
        if(moving == true) {
            if(originX < 0) {
                newInfo.originX = 0
            } else if(originX + width > self.defaultwidth) {
                newInfo.originX = self.defaultwidth - width
            } else {
                newInfo.originX = originX
            }
            newInfo.width = width
            
            if(originY < 0) {
                newInfo.originY = 0
            } else if(originY + height > self.defaultHeight) {
                newInfo.originY = self.defaultHeight - height
            } else {
                newInfo.originY = originY
            }
            
            newInfo.height = height
        } else {
            if(originX < 0) {
                newInfo.originX = 0
                newInfo.width = width + originX
            } else if (originX + width > self.defaultwidth) {
                newInfo.originX = originX
                newInfo.width = self.defaultwidth - originX
            } else {
                newInfo.originX = originX
                newInfo.width = width
            }
            
            if(originY < 0) {
                newInfo.originY = 0
                newInfo.height = height + originY
            } else if (originY + height > self.defaultHeight) {
                newInfo.originY = originY
                newInfo.height = self.defaultHeight - originY
            } else {
                newInfo.originY = originY
                newInfo.height = height
            }
        }
        
        
        return newInfo
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

struct FrameInfo {
    var originX: CGFloat
    var originY: CGFloat
    var height: CGFloat
    var width: CGFloat
    var moving: Bool = false
}


//
//  MMSlidingButton.swift
//  MMSlidingButton
//
//  Created by Mohamed Maail on 6/7/16.
//  Copyright © 2016 Mohamed Maail. All rights reserved.
//

import Foundation
import UIKit

protocol SlideButtonDelegate: class {
    func buttonStatus(_ status:String, sender:MMSlidingButton)
}

@IBDesignable class MMSlidingButton: UIView{
    
    weak var delegate: SlideButtonDelegate?
    
    @IBInspectable var dragPointWidth: CGFloat = 70 {
        didSet{
            dragPoint.frame.size.width = dragPointWidth
        }
    }
    
    @IBInspectable var dragPointColor: UIColor = UIColor.darkGray {
        didSet{
            dragPoint.backgroundColor = dragPointColor
        }
    }
    
    @IBInspectable var buttonColor: UIColor = UIColor.gray {
        didSet{
            backgroundColor = buttonColor
        }
    }
    
    @IBInspectable var buttonText: String = "UNLOCK" {
        didSet{
            dragPointButtonLabel.text = buttonText
            buttonLabel.text = buttonText
        }
    }
    
    @IBInspectable var imageName: UIImage = UIImage() {
        didSet {
            imageView.image = imageName
        }
    }
    
    @IBInspectable var buttonTextColor: UIColor = UIColor.white {
        didSet{
            buttonLabel.textColor = buttonTextColor
        }
    }
    
    @IBInspectable var dragPointTextColor: UIColor = UIColor.white {
        didSet{
            dragPointButtonLabel.textColor = dragPointTextColor
        }
    }
    
    @IBInspectable var buttonUnlockedTextColor: UIColor = UIColor.white {
        didSet{
            dragPointButtonLabel.textColor = buttonUnlockedTextColor
        }
    }
    
    @IBInspectable var buttonCornerRadius: CGFloat = 30 {
        didSet{
            dragPoint.layer.cornerRadius = buttonCornerRadius
        }
    }
    
    var dragPointCornerRadius: CGFloat = 30 {
        didSet {
            layoutSubviews()
        }
    }
    
    var roundedCorners: UIRectCorner = .allCorners {
        didSet{
            layer.round(with: buttonCornerRadius, corners: roundedCorners)
            clipsToBounds = true
        }
    }
    
    var roundedDragPointCorners: UIRectCorner? = [.topRight, .bottomRight] {
        didSet{
            layoutSubviews()
        }
    }
    
    @IBInspectable var buttonUnlockedText: String   = "UNLOCKED"
    @IBInspectable var buttonUnlockedColor: UIColor = UIColor.black
    
    var buttonFont           = UIFont.boldSystemFont(ofSize: 17)
    var dragPoint            = UIView()
    var buttonLabel          = UILabel()
    var dragPointButtonLabel = UILabel()
    var imageView            = UIImageView()
    var unlocked             = false
    var layoutSet            = false
    
    override init (frame : CGRect) {
        super.init(frame : frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !layoutSet {
            self.setUpButton()
            self.layoutSet = true
        }
    }
    
    func setUpButton(){
        
        backgroundColor              = buttonColor
        dragPoint                    = UIView(frame: CGRect(x: dragPointWidth - self.frame.size.width,
                                                            y: 0,
                                                            width: self.frame.size.width,
                                                            height: self.frame.size.height))
        dragPoint.backgroundColor    = dragPointColor
        addSubview(self.dragPoint)
        
        if !buttonText.isEmpty{
            buttonLabel               = UILabel(frame: CGRect(x: 0,
                                                              y: 0,
                                                              width: self.frame.size.width,
                                                              height: self.frame.size.height))
            buttonLabel.textAlignment = .center
            buttonLabel.text          = buttonText
            buttonLabel.textColor     = UIColor.white
            buttonLabel.font          = buttonFont
            buttonLabel.textColor     = buttonTextColor
            addSubview(buttonLabel)
            
            dragPointButtonLabel               = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
            dragPointButtonLabel.textAlignment = .center
            dragPointButtonLabel.text          = buttonText
            dragPointButtonLabel.textColor     = .white
            dragPointButtonLabel.font          = buttonFont
            dragPointButtonLabel.textColor     = dragPointTextColor
            if let dragPointCorners = roundedDragPointCorners {
                dragPoint.layer.round(with: dragPointCornerRadius, corners: dragPointCorners)
            }
            dragPoint.addSubview(self.dragPointButtonLabel)
        }
        self.bringSubview(toFront: self.dragPoint)
        
        if self.imageName != UIImage() {
            imageView = UIImageView(frame: CGRect(x: self.frame.size.width - dragPointWidth,
                                                  y: 0,
                                                  width: self.dragPointWidth,
                                                  height: self.frame.size.height))
            imageView.contentMode = .center
            imageView.image = imageName
            dragPoint.addSubview(imageView)
        }
        
        self.layer.masksToBounds = true
        
        // start detecting pan gesture
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panDetected(_ :)))
        panGestureRecognizer.minimumNumberOfTouches = 1
        dragPoint.addGestureRecognizer(panGestureRecognizer)
    }
    
    func panDetected(_ sender: UIPanGestureRecognizer){
        var translatedPoint = sender.translation(in: self)
        translatedPoint     = CGPoint(x: translatedPoint.x, y: self.frame.size.height / 2)
        sender.view?.frame.origin.x = (dragPointWidth - self.frame.size.width) + translatedPoint.x
        if sender.state == .ended{
            
            let velocityX = sender.velocity(in: self).x * 0.2
            var finalX    = translatedPoint.x + velocityX
            if finalX < 0{
                finalX = 0
            }else if finalX + self.dragPointWidth  >  (self.frame.size.width - 60){
                unlocked = true
                self.unlock()
            }
            
            let animationDuration:Double = abs(Double(velocityX) * 0.0002) + 0.2
            UIView.transition(with: self, duration: animationDuration, options: UIViewAnimationOptions.curveEaseOut, animations: {
                }, completion: { (status) in
                    if status {
                        self.animationFinished()
                    }
            })
        }
    }
    
    func animationFinished(){
        if !unlocked{
            self.reset()
        }
    }
    
    //lock button animation (SUCCESS)
    func unlock(){
        UIView.transition(with: self, duration: 0.2, options: .curveEaseOut, animations: {
            self.dragPoint.frame = CGRect(x: self.frame.size.width - self.dragPoint.frame.size.width, y: 0, width: self.dragPoint.frame.size.width, height: self.dragPoint.frame.size.height)
        }) { (status) in
            if status{
                self.dragPointButtonLabel.text      = self.buttonUnlockedText
                self.imageView.isHidden               = true
                self.dragPoint.backgroundColor      = self.buttonUnlockedColor
                self.dragPointButtonLabel.textColor = self.buttonUnlockedTextColor
                self.delegate?.buttonStatus("Unlocked", sender: self)
            }
        }
    }
    
    //reset button animation (RESET)
    func reset(){
        UIView.transition(with: self, duration: 0.2, options: .curveEaseOut, animations: {
            self.dragPoint.frame = CGRect(x: self.dragPointWidth - self.frame.size.width, y: 0, width: self.dragPoint.frame.size.width, height: self.dragPoint.frame.size.height)
        }) { (status) in
            if status{
                self.dragPointButtonLabel.text      = self.buttonText
                self.imageView.isHidden               = false
                self.dragPoint.backgroundColor      = self.dragPointColor
                self.dragPointButtonLabel.textColor = self.dragPointTextColor
                self.unlocked                       = false
                //self.delegate?.buttonStatus("Locked")
            }
        }
    }
}

extension CALayer {
    
    func round(with radius: CGFloat, corners: UIRectCorner) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        mask = shape
    }
}

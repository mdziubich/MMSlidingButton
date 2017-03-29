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
    func buttonStatus(_ status: String, sender: MMSlidingButton)
}

@IBDesignable class MMSlidingButton: UIView{
    
    weak var delegate: SlideButtonDelegate?
    
    //MARK: Drag Point UI
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
    
    @IBInspectable var dragPointTextColor: UIColor = UIColor.white {
        didSet{
            dragPointButtonLabel.textColor = dragPointTextColor
        }
    }
    
    var roundedDragPointCorners: UIRectCorner = [.topRight, .bottomRight] {
        didSet{
            layoutSubviews()
        }
    }
    
    var dragPointCornerRadius: CGFloat = 30 {
        didSet {
            layoutSubviews()
        }
    }
    
    @IBInspectable var dragPointUnlockedColor: UIColor = .red {
        didSet{
            dragPointBackgroundView.backgroundColor = dragPointUnlockedColor
        }
    }
    
    @IBInspectable var imageName: UIImage = UIImage() {
        didSet {
            imageView.image = imageName
        }
    }
    
    //MARK: Button II
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
    
    @IBInspectable var buttonTextColor: UIColor = UIColor.white {
        didSet{
            buttonLabel.textColor = buttonTextColor
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
    
    var roundedCorners: UIRectCorner = .allCorners {
        didSet{
            layer.round(with: buttonCornerRadius, corners: roundedCorners)
            clipsToBounds = true
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
    
    var dragPointBackgroundAnimationable = false
    var dragPointBackgroundView = UIView()
    
    private let widthLeftMargin: CGFloat = 50
    
    override init (frame : CGRect) {
        super.init(frame : frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !layoutSet {
            setUpButton()
            layoutSet = true
        }
        dragPoint.layer.round(with: dragPointCornerRadius, corners: roundedDragPointCorners)
        if dragPointBackgroundAnimationable {
            dragPointBackgroundView.layer.round(with: dragPointCornerRadius, corners: roundedDragPointCorners)
        }
    }
    
    func setUpButton() {
        backgroundColor = buttonColor
        layer.masksToBounds = true
        setupDragPointButton()
        setupButtonLabel()
        setupDragButtonImage()
        setupPanGesture()
        if dragPointBackgroundAnimationable {
            bringSubview(toFront: dragPointBackgroundView)
        } else {
            bringSubview(toFront: dragPoint)
        }
    }
    
    private func setupDragPointButton() {
        dragPoint                    = UIView(frame: CGRect(x: dragPointWidth - frame.size.width - widthLeftMargin,
                                                            y: 0,
                                                            width: frame.size.width + widthLeftMargin,
                                                            height: frame.size.height))
        dragPoint.backgroundColor    = dragPointColor
        addSubview(self.dragPoint)
    }
    
    private func setupButtonLabel() {
        if !buttonText.isEmpty {
            buttonLabel               = UILabel(frame: CGRect(x: 0,
                                                              y: 0,
                                                              width: self.frame.size.width,
                                                              height: self.frame.size.height))
            buttonLabel.textAlignment = .center
            buttonLabel.text          = buttonText
            buttonLabel.textColor     = .white
            buttonLabel.font          = buttonFont
            buttonLabel.textColor     = buttonTextColor
            addSubview(buttonLabel)
            setupDragButton()
        }
    }
    
    private func setupDragButton() {
        dragPointButtonLabel               = UILabel(frame: CGRect(x: widthLeftMargin,
                                                                   y: 0,
                                                                   width: self.frame.size.width,
                                                                   height: self.frame.size.height))
        dragPointButtonLabel.textAlignment = .center
        dragPointButtonLabel.text          = buttonText
        dragPointButtonLabel.textColor     = .white
        dragPointButtonLabel.font          = buttonFont
        dragPointButtonLabel.textColor     = dragPointTextColor
        
        if dragPointBackgroundAnimationable {
            setupDragPointAniamtionableView()
        } else {
            dragPoint.addSubview(dragPointButtonLabel)
        }
    }
    
    private func setupDragPointAniamtionableView() {
        dragPointBackgroundView = UIView(frame: CGRect(x: dragPointWidth - frame.size.width - widthLeftMargin,
                                                       y: 0,
                                                       width: frame.size.width + widthLeftMargin,
                                                       height: frame.size.height))
        dragPointBackgroundView.backgroundColor = dragPointUnlockedColor
        addSubview(dragPointBackgroundView)
        dragPointBackgroundView.addSubview(dragPointButtonLabel)
        dragPointBackgroundView.alpha = 0
    }
    
    private func setupDragButtonImage() {
        if self.imageName != UIImage() {
            imageView = UIImageView(frame: CGRect(x: self.frame.size.width - dragPointWidth + widthLeftMargin,
                                                  y: 0,
                                                  width: self.dragPointWidth,
                                                  height: self.frame.size.height))
            imageView.contentMode = .center
            imageView.image = imageName
            dragPoint.addSubview(imageView)
        }
    }
    
    private func setupPanGesture() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panDetected(_ :)))
        panGestureRecognizer.minimumNumberOfTouches = 1
        dragPoint.addGestureRecognizer(panGestureRecognizer)
    }
    
    func panDetected(_ sender: UIPanGestureRecognizer){
        var translatedPoint = sender.translation(in: self)
        translatedPoint     = CGPoint(x: translatedPoint.x, y: self.frame.size.height / 2)
        sender.view?.frame.origin.x = (dragPointWidth - self.frame.size.width - widthLeftMargin) + translatedPoint.x
        if dragPointBackgroundAnimationable {
            dragPointBackgroundView.frame.origin.x = (dragPointWidth - self.frame.size.width - widthLeftMargin) + translatedPoint.x
            dragPointBackgroundView.alpha = translatedPoint.x / (dragPoint.frame.width - widthLeftMargin)
        }
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
            let frame = CGRect(x: self.frame.size.width - self.dragPoint.frame.size.width,
                               y: 0,
                               width: self.dragPoint.frame.size.width,
                               height: self.dragPoint.frame.size.height)
            self.dragPoint.frame = frame
            if self.dragPointBackgroundAnimationable {
                self.dragPointBackgroundView.frame = frame
                self.dragPointBackgroundView.alpha = 1
            }
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
            let frame = CGRect(x: self.dragPointWidth - self.frame.size.width - self.widthLeftMargin,
                               y: 0,
                               width: self.dragPoint.frame.size.width,
                               height: self.dragPoint.frame.size.height)
            
            self.dragPoint.frame = frame
            if self.dragPointBackgroundAnimationable {
                self.dragPointBackgroundView.frame = frame
            }
        }) { (status) in
            if status{
                self.dragPointButtonLabel.text      = self.buttonText
                self.imageView.isHidden               = false
                self.dragPoint.backgroundColor      = self.dragPointColor
                self.dragPointButtonLabel.textColor = self.dragPointTextColor
                self.unlocked                       = false
                self.dragPointBackgroundView.alpha  = 0
                self.delegate?.buttonStatus("Locked", sender: self)
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

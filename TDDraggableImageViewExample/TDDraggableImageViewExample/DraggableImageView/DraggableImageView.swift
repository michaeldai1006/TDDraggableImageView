//
//  DraggableImageView.swift
//  blackjack
//
//  Created by michael on 3/14/18.
//  Copyright © 2018 odinternational. All rights reserved.
//

import UIKit

protocol DraggableImageViewDelegate {
    func imageViewDidSetToDestination(sender: DraggableImageView)
    func imageViewDidReturnToOrigin(sender: DraggableImageView)
}

class DraggableImageView: UIImageView {
    
    var delegate: DraggableImageViewDelegate?
    
    var origin: CGPoint!
    var destinationView: UIView!
    var parentView: UIView!
    var shadowOffset: CGPoint!
    
    init(image: UIImage, origin: CGPoint, destinationView: UIView, parentView: UIView, shadowOffset: CGPoint) {
        super.init(image: image)
        
        // Move view to origin
        self.frame.origin = origin
        
        // Init properities with parameters
        self.origin = origin
        self.destinationView = destinationView
        self.parentView = parentView
        self.shadowOffset = shadowOffset
        
        // Enable user interaction
        self.isUserInteractionEnabled = true
        
        // Add pan gesture
        self.addPanGesture()
    }
    
    private func addPanGesture() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(DraggableImageView.handlePan(sender:)))
        self.addGestureRecognizer(pan)
    }
    
    @objc private func handlePan(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began, .changed:
            moveViewWithPan(sender: sender)
        default:
            if self.frame.intersects(destinationView.frame) {
                self.setViewToDestination()
            } else {
                self.returnViewToOrigin()
            }
        }
    }
    
    private func moveViewWithPan(sender: UIPanGestureRecognizer) {
        self.parentView.bringSubview(toFront: self)
        
        let translation = sender.translation(in: parentView)
        
        self.center = CGPoint(x: self.center.x + translation.x, y: self.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: parentView)
    }
    
    func returnViewToOrigin() {
        UIView.animate(withDuration: 0.5) {
            self.frame.origin = self.origin
        }
        
        self.delegate?.imageViewDidReturnToOrigin(sender: self)
    }
    
    func setViewToDestination() {
        UIView.animate(withDuration: 0.5) {
            self.center = CGPoint(x: self.destinationView.center.x + self.shadowOffset.x,
                                  y: self.destinationView.center.y + self.shadowOffset.y)
        }
        
        self.delegate?.imageViewDidSetToDestination(sender: self)
    }
    
    func turnOffUserInteraction() {
        self.isUserInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

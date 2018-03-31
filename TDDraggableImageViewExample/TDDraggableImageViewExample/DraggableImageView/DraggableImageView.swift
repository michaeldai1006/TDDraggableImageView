//
//  DraggableImageView.swift
//
//  Created by michael on 3/14/18.
//  Copyright © 2018 Tiancheng Dai. All rights reserved.
//

import UIKit

protocol DraggableImageViewDelegate {
    func imageViewDidMoveToDestination(sender: DraggableImageView)
    func imageViewDidReturnToOrigin(sender: DraggableImageView)
    func imageViewWillMove(sender: DraggableImageView)
}

class DraggableImageView: UIImageView {
    
    var delegate: DraggableImageViewDelegate?
    
    var origin: CGPoint!
    var destinationView: UIView!
    var parentView: UIView!
    var moveDuration: Double!
    var returnDuration: Double!
    var enableTapping: Bool!
    
    init(image: UIImage, origin: CGPoint, destinationView: UIView, parentView: UIView, moveDuration: Double, returnDuration: Double, enableTapping tapping: Bool) {
        super.init(image: image)
        
        // Move view to origin
        self.frame.origin = origin
        
        // Init properities with parameters
        self.origin = origin
        self.destinationView = destinationView
        self.parentView = parentView
        self.moveDuration = moveDuration
        self.returnDuration = returnDuration
        self.enableTapping = tapping
        
        // Enable user interaction
        self.isUserInteractionEnabled = true
        
        // Add gesture recognizers
        self.addPanGesture()
        self.addTapGesture()
    }
    
    private func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(DraggableImageView.handleTap(_:)))
        self.addGestureRecognizer(tap)
    }
    
    private func addPanGesture() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(DraggableImageView.handlePan(_:)))
        self.addGestureRecognizer(pan)
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        // If tapping not enabled, return
        if (!enableTapping) { return }
        
        delegate?.imageViewWillMove(sender: self)
        self.parentView.bringSubview(toFront: self)
        
        if (self.frame.intersects(destinationView.frame)) {
            returnViewToOrigin()
        } else {
            setViewToDestination()
        }
    }
    
    @objc private func handlePan(_ sender: UIPanGestureRecognizer) {
        self.parentView.bringSubview(toFront: self)
        switch sender.state {
        case .began:
            delegate?.imageViewWillMove(sender: self)
            moveViewWithPan(sender: sender)
        case .changed:
            moveViewWithPan(sender: sender)
        default:
            if self.frame.intersects(destinationView.frame) {
                self.setViewToDestination()
            } else {
                self.returnViewToOrigin()
            }
        }
    }
    
    func returnViewToOrigin() {
        UIView.animate(withDuration: returnDuration, animations: {
            self.frame.origin = self.origin
        }) { (result) in
            self.delegate?.imageViewDidReturnToOrigin(sender: self)
        }
    }
    
    func setViewToDestination() {
        UIView.animate(withDuration: moveDuration, animations: {
            self.center = self.destinationView.center
        }) { (result) in
            self.delegate?.imageViewDidMoveToDestination(sender: self)
        }
    }
    
    func turnOffUserInteraction() {
        self.isUserInteractionEnabled = false
    }
    
    func turnonUserInteraction() {
        self.isUserInteractionEnabled = true
    }
    
    private func moveViewWithPan(sender: UIPanGestureRecognizer) {
        self.parentView.bringSubview(toFront: self)
        
        let translation = sender.translation(in: parentView)
        
        self.center = CGPoint(x: self.center.x + translation.x, y: self.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: parentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

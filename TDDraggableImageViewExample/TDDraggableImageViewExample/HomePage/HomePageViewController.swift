//
//  ViewController.swift
//  TDDraggableImageViewExample
//
//  Created by Michael Dai on 3/30/18.
//  Copyright © 2018 Tiancheng Dai. All rights reserved.
//

import UIKit

struct constants {
    static let imageName: String = "FileIcon"
    static let animationDuration: Double = 0.3
}

class HomePageViewController: UIViewController {

    @IBOutlet weak var trashCanView: UIImageView!
    @IBOutlet weak var restartBtn: UIButton!
    var fileView: DraggableImageView!
    
    @IBAction func restartBtnPressed(_ sender: UIButton) {
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        restartBtn.isHidden = true
        setupFileView()
    }
    
    private func setupFileView() {
        fileView = DraggableImageView(image: UIImage(named: constants.imageName)!,
                                      origin: self.view.center,
                                      destinationView: trashCanView,
                                      parentView: self.view,
                                      moveDuration: constants.animationDuration,
                                      returnDuration: constants.animationDuration,
                                      enableTapping: true)
        fileView.delegate = self
        self.view.addSubview(fileView)
    }
}

extension HomePageViewController: DraggableImageViewDelegate {
    func imageViewDidMoveToDestination(sender: DraggableImageView) {
        fileView.removeFromSuperview()
        restartBtn.isHidden = false
    }
    
    func imageViewDidReturnToOrigin(sender: DraggableImageView) {
        print("Returned")
    }
    
    func imageViewWillMove(sender: DraggableImageView) {
        print("Will move")
    }
}

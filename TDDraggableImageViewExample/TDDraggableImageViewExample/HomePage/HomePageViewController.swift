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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create DraggableImageView instance and add to home page view as subview
        let fileView = DraggableImageView(image: UIImage(named: constants.imageName)!,
                                          origin: self.view.center,
                                          destinationView: trashCanView,
                                          parentView: self.view,
                                          moveDuration: constants.animationDuration,
                                          returnDuration: constants.animationDuration,
                                          enableTapping: true)
        self.view.addSubview(fileView)
    }
}


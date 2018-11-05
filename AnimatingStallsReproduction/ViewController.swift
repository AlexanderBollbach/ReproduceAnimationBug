//
//  ViewController.swift
//  AnimatingStallsReproduction
//
//  Created by Alexander Bollbach on 11/4/18.
//  Copyright © 2018 Alexander Bollbach. All rights reserved.
//

import UIKit


// use ProjectRenderingView to update a render of a 'Project' 10 times every second
// touches/dragging the screen prevents delays/stops the update

class ViewController: UIViewController {
    
    var project = Project()
    
    private let projectRW = ProjectRenderingView(framerate: 10)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var layer = Layer()
        layer.props.paths.primaryPath.points.append(Point(x: 0, y: 0))
        layer.props.paths.primaryPath.points.append(Point(x: 0.5, y: 0.5))
        
        project.layers.append(layer)
        
        projectRW.pinTo(superView: view)

        projectRW.projectSource = { [unowned self] in
            return self.project
        }
    }
}


//
//  ProjectRenderingView.swift
//  AnimatingStallsReproduction
//
//  Created by Alexander Bollbach on 11/4/18.
//  Copyright © 2018 Alexander Bollbach. All rights reserved.
//

import UIKit

class ProjectRenderingView: AnimatingFramedView {
    
    var projectSource: () -> Project?
    
    init(framerate: Int, source: @escaping () -> Project? = { return nil }) {
        self.projectSource = source
        super.init(defaultFrameRate: framerate)
        
        isUserInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    private var project: Project?
    
    func update(project: Project) {
        self.project = project
    }
    
    override func frameProvider() -> UIImage? {
        guard
            let project = self.projectSource(),
            let im = render(project: project, tick: tick) else {
                return nil
        }
        
        return UIImage(cgImage: im)
    }

}

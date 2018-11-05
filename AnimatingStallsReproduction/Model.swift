//
//  Model.swift
//  AnimatingStallsReproduction
//
//  Created by Alexander Bollbach on 11/4/18.
//  Copyright © 2018 Alexander Bollbach. All rights reserved.
//

import Foundation
import CoreGraphics

struct Project {
    
    var layers: [Layer] = []
}

struct Layer {
    
    var props = RenderableProps()
}


struct Path {
    var points = [Point]()
}

struct Paths {
    
    var all: [Path] {
        return [primaryPath] + []
    }
    
    var primaryPath = Path()
}




struct RenderableProps {
    
    var paths = Paths()
    var strokeWidth: Double = 1
}




struct Point: Codable, Equatable {
    
    var x: Double
    var y: Double
    
    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    
    
    
    func getCGPoint(from rect: CGRect) -> CGPoint {
        
        let pointX = Double(rect.size.width) * self.x
        let pointY = Double(rect.size.height) * self.y
        return CGPoint(x: pointX, y: pointY)
    }
    
    
    
}



struct RenderingEnvironment {
    let context: CGContext
    let rect: CGRect
}

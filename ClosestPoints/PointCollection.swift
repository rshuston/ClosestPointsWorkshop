//
//  PointCollection.swift
//  ClosestPoints
//
//  Created by Robert Huston on 12/2/16.
//  Copyright © 2016 Pinpoint Dynamics. All rights reserved.
//

import Cocoa

class PointCollection: NSObject {

    let maxDimension: UInt32 = 1024

    var points: [Point]

    override init() {
        points = []
    }

    init(withPoints: [Point]) {
        self.points = withPoints
    }

    func clear() {
        points = []
    }

    func generateRandomPoints(numberOfPoints: Int) {
        if numberOfPoints > 0 {
            for _ in 1...numberOfPoints {
                let x = CGFloat(arc4random_uniform(maxDimension))
                let y = CGFloat(arc4random_uniform(maxDimension))
                let p = Point(x: x, y: y)
                points.append(p)
            }
        }
    }

}

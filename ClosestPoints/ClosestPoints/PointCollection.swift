//
//  PointCollection.swift
//  ClosestPoints
//
//  Created by Robert Huston on 12/2/16.
//  Copyright © 2016 Pinpoint Dynamics. All rights reserved.
//

import Cocoa
import GameKit

class PointCollection: NSObject {

    let maxDimension: UInt32 = 128

    let u_distribution: GKRandomDistribution
    let g_distribution: GKGaussianDistribution

    var points: [Point]

    override init() {
        u_distribution = GKRandomDistribution(lowestValue: 0, highestValue: Int(maxDimension))
        g_distribution = GKGaussianDistribution(lowestValue: 0, highestValue: Int(maxDimension))

        points = []
    }

    convenience init(withPoints: [Point]) {
        self.init()
        self.points = withPoints
    }

    func clear() {
        points = []
    }

    func generateUniformRandomPoints(numberOfPoints: Int) {
        if numberOfPoints > 0 {
            for _ in 1...numberOfPoints {
                let x = CGFloat(u_distribution.nextInt())
                let y = CGFloat(u_distribution.nextInt())
                let p = Point(x: x, y: y)
                points.append(p)
            }
        }
    }

    func generateClusteredRandomPoints(numberOfPoints: Int) {
        if numberOfPoints > 0 {
            for _ in 1...numberOfPoints {
                let x = CGFloat(g_distribution.nextInt())
                let y = CGFloat(g_distribution.nextInt())
                let p = Point(x: x, y: y)
                points.append(p)
            }
        }
    }

}

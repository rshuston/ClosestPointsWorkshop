//
//  PointCollection.swift
//  ClosestPoints
//
//  Created by Robert Huston on 12/2/16.
//  Copyright © 2016 Pinpoint Dynamics. All rights reserved.
//

import Cocoa
import GameKit

protocol PointCollectionDataSource {

    var points: [Point] { get }
    var maxDimension: UInt32 { get }

}

class PointCollection: NSObject, PointCollectionDataSource {

    let u_distribution: GKRandomDistribution
    let g_distribution: GKGaussianDistribution

    // MARK: - PointCollectionDataSource

    let maxDimension: UInt32 = 1024
    var points: [Point]

    // MARK: - Initializers

    override init() {
        u_distribution = GKRandomDistribution(lowestValue: 0, highestValue: Int(maxDimension))
        g_distribution = GKGaussianDistribution(lowestValue: 0, highestValue: Int(maxDimension))

        points = []
    }

    convenience init(withPoints: [Point]) {
        self.init()
        self.points = withPoints
    }

    // MARK: - Behavior

    func clear() {
        points = []
    }

    func generateUniformRandomPoints(numberOfPoints: Int) {
        _generateRandomPoints(numberOfPoints: numberOfPoints) {
            return CGFloat(u_distribution.nextInt())
        }
    }

    func generateClusteredRandomPoints(numberOfPoints: Int) {
        _generateRandomPoints(numberOfPoints: numberOfPoints) {
            return CGFloat(g_distribution.nextInt())
        }
    }

    private func _generateRandomPoints(numberOfPoints: Int, usingRandom: () -> CGFloat) {
        if numberOfPoints > 0 {
            for _ in 1...numberOfPoints {
                let x = usingRandom()
                let y = usingRandom()
                let p = Point(x: x, y: y)
                points.append(p)
            }
        }
    }

}

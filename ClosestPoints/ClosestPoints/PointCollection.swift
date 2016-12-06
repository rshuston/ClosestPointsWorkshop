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

    var maxDimension: UInt32 { get }
    var points: [Point] { get }
    var closestPoints: (Point, Point)? { get }

}

class PointCollection: NSObject, PointCollectionDataSource {

    let u_distribution: GKRandomDistribution
    let g_distribution: GKGaussianDistribution

    // MARK: - PointCollectionDataSource

    let maxDimension: UInt32 = 1024
    var points: [Point]
    var closestPoints: (Point, Point)?

    // MARK: - Initializers

    override init() {
        u_distribution = GKRandomDistribution(lowestValue: 0, highestValue: Int(maxDimension))
        g_distribution = GKGaussianDistribution(lowestValue: 0, highestValue: Int(maxDimension))

        points = []
        closestPoints = nil
    }

    convenience init(withPoints: [Point]) {
        self.init()
        self.points = withPoints
    }

    // MARK: - Behavior

    func clear() {
        points = []
        closestPoints = nil
    }

    func generateUniformRandomPoints(numberOfPoints: Int, maxX: CGFloat, maxY: CGFloat, margin: CGFloat) {
        let xDistribution = GKRandomDistribution(lowestValue: Int(margin), highestValue: Int(maxX - margin))
        let yDistribution = GKRandomDistribution(lowestValue: Int(margin), highestValue: Int(maxY - margin))
        _generateRandomPoints(numberOfPoints: numberOfPoints, xDist: xDistribution, yDist: yDistribution)
    }

    func generateClusteredRandomPoints(numberOfPoints: Int, maxX: CGFloat, maxY: CGFloat, margin: CGFloat) {
        let xDistribution = GKGaussianDistribution(lowestValue: Int(margin), highestValue: Int(maxX - margin))
        let yDistribution = GKGaussianDistribution(lowestValue: Int(margin), highestValue: Int(maxY - margin))
        _generateRandomPoints(numberOfPoints: numberOfPoints, xDist: xDistribution, yDist: yDistribution)
    }

    private func _generateRandomPoints(numberOfPoints: Int, xDist: GKRandomDistribution, yDist: GKRandomDistribution) {
        points = []
        if numberOfPoints > 0 {
            for _ in 1...numberOfPoints {
                let x = CGFloat(xDist.nextInt())
                let y = CGFloat(yDist.nextInt())
                let p = Point(x: x, y: y)
                points.append(p)
            }
        }

        closestPoints = nil
    }

}

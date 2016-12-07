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
    var closestPointsColor: NSColor? { get }
    var checkPoints: (Point, Point)? { get }
    var checkPointsColor: NSColor? { get }

}

class PointCollection: NSObject, PointCollectionDataSource {

    // MARK: - PointCollectionDataSource

    let maxDimension: UInt32 = 1024
    var points: [Point]
    var closestPoints: (Point, Point)?
    var closestPointsColor: NSColor?
    var checkPoints: (Point, Point)?
    var checkPointsColor: NSColor?

    // MARK: GKRandomDistribution Factories
    
    var uniformDistributionFactory: (Int, Int) -> GKRandomDistribution = {
        (lowestValue: Int, highestValue: Int) -> GKRandomDistribution in
        return GKRandomDistribution(lowestValue: lowestValue, highestValue: highestValue)
    }

    var gaussianDistributionFactory: (Int, Int) -> GKRandomDistribution = {
        (lowestValue: Int, highestValue: Int) -> GKRandomDistribution in
        return GKGaussianDistribution(lowestValue: lowestValue, highestValue: highestValue)
    }

    // MARK: - Initializers

    override init() {
        points = []
        closestPoints = nil
        closestPointsColor = nil
        checkPoints = nil
        checkPointsColor = nil
    }

    convenience init(withPoints: [Point]) {
        self.init()
        self.points = withPoints
    }

    // MARK: - Behavior

    func clear() {
        points = []
        closestPoints = nil
        closestPointsColor = nil
        checkPoints = nil
        checkPointsColor = nil
    }

    func clearClosestPoints() {
        closestPoints = nil
        closestPointsColor = nil
    }

    func clearCheckPoints() {
        checkPoints = nil
        checkPointsColor = nil
    }

    func generateUniformRandomPoints(numberOfPoints: Int, maxX: CGFloat, maxY: CGFloat, margin: CGFloat) {
        let xDistribution = uniformDistributionFactory(Int(margin), Int(maxX - margin))
        let yDistribution = uniformDistributionFactory(Int(margin), Int(maxY - margin))
        _generateRandomPoints(numberOfPoints: numberOfPoints, xDist: xDistribution, yDist: yDistribution)
    }

    func generateClusteredRandomPoints(numberOfPoints: Int, maxX: CGFloat, maxY: CGFloat, margin: CGFloat) {
        let xDistribution = gaussianDistributionFactory(Int(margin), Int(maxX - margin))
        let yDistribution = gaussianDistributionFactory(Int(margin), Int(maxY - margin))
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
    }

}

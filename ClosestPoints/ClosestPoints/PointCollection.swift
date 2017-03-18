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
    var closestPoints: (Point, Point)? { get }
    var closestPointsColor: NSColor? { get }
    var checkPoints: (Point, Point)? { get }
    var checkPointsColor: NSColor? { get }
    var searchRect: NSRect? { get }

}

class PointCollection: NSObject, PointCollectionDataSource {

    // MARK: - PointCollectionDataSource protocol

    var points: [Point]
    var closestPoints: (Point, Point)?
    var closestPointsColor: NSColor?
    var checkPoints: (Point, Point)?
    var checkPointsColor: NSColor?
    var searchRect: NSRect?

    // MARK: - General controls

    // This gives sufficient precision so we can have distinct coordinates within the view
    var distributionRange: Int = 1048576

    // MARK: - GKRandomDistribution Factories

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
        searchRect = nil
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
        searchRect = nil
    }

    func clearAllDataExceptForPoints() {
        closestPoints = nil
        closestPointsColor = nil
        checkPoints = nil
        checkPointsColor = nil
        searchRect = nil
    }

    func generateUniformRandomPoints(numberOfPoints: Int, maxX: CGFloat, maxY: CGFloat, margin: CGFloat) {
        let xDistribution = uniformDistributionFactory(0, distributionRange)
        let yDistribution = uniformDistributionFactory(0, distributionRange)
        _generateRandomPoints(numberOfPoints: numberOfPoints, xDist: xDistribution, yDist: yDistribution, maxX: maxX, maxY: maxY, margin: margin)
    }

    func generateClusteredRandomPoints(numberOfPoints: Int, maxX: CGFloat, maxY: CGFloat, margin: CGFloat) {
        let xDistribution = gaussianDistributionFactory(0, distributionRange)
        let yDistribution = gaussianDistributionFactory(0, distributionRange)
        _generateRandomPoints(numberOfPoints: numberOfPoints, xDist: xDistribution, yDist: yDistribution, maxX: maxX, maxY: maxY, margin: margin)
    }

    private func _generateRandomPoints(numberOfPoints: Int, xDist: GKRandomDistribution, yDist: GKRandomDistribution, maxX: CGFloat, maxY: CGFloat, margin: CGFloat) {
        points = []
        if numberOfPoints > 0 {
            for _ in 1...numberOfPoints {
                let xi = xDist.nextInt()
                let x = AppUtils.ScaleIntToCGFloat(xi, domain: (0, distributionRange), range: (0.0, maxX), margin: margin)
                let yi = yDist.nextInt()
                let y = AppUtils.ScaleIntToCGFloat(yi, domain: (0, distributionRange), range: (0.0, maxY), margin: margin)
                let p = Point(x: x, y: y)
                points.append(p)
            }
        }
    }

}

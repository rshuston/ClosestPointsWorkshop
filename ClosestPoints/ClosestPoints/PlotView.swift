//
//  PlotView.swift
//  ClosestPoints
//
//  Created by Robert Huston on 11/20/16.
//  Copyright © 2016 Pinpoint Dynamics. All rights reserved.
//

import Cocoa

class PlotView: NSView {

    let pointRadius: CGFloat = 4

    var pointDataSource: PointCollectionDataSource?

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        NSFrameRect(bounds)

        if let pds = pointDataSource {
            let points = pds.points
            for index in 0..<points.count {
                drawPoint(points[index].getAsNSPoint(), radius: pointRadius, color: NSColor.black)
            }

            if let checkPoints = pds.checkPoints {
                let color = pds.checkPointsColor ?? NSColor.black

                let p1 = checkPoints.0.getAsNSPoint()
                let p2 = checkPoints.1.getAsNSPoint()

                drawPoint(p1, radius: pointRadius, color: color)
                drawPoint(p2, radius: pointRadius, color: color)

                drawLine(from: p1, to: p2, width: 2, color: color)
            }

            if let closestPoints = pds.closestPoints {
                let color = pds.closestPointsColor ?? NSColor.black

                let p1 = closestPoints.0.getAsNSPoint()
                let p2 = closestPoints.1.getAsNSPoint()

                drawPoint(p1, radius: pointRadius, color: color)
                drawPoint(p2, radius: pointRadius, color: color)

                drawLine(from: p1, to: p2, width: 2, color: color)
            }
        }
    }

    func drawPoint(_ point: NSPoint, radius: CGFloat, color: NSColor) {
        color.set()

        let rect = NSRect(x: point.x - radius, y: point.y - radius, width: 2 * radius, height: 2 * radius)
        let path = NSBezierPath(ovalIn: rect)
        path.fill()
    }

    func drawLine(from: NSPoint, to: NSPoint, width: CGFloat, color: NSColor) {
        color.set()

        let path = NSBezierPath()
        path.lineWidth = width

        path.move(to: from)
        path.line(to: to)
        path.close()
        path.stroke()
    }

}

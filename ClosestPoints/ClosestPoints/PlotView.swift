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
                let pt = points[index]
                let rect = NSRect(x: pt.x - pointRadius, y: pt.y - pointRadius, width: 2 * pointRadius, height: 2 * pointRadius)
                let path = NSBezierPath(ovalIn: rect)
                path.fill()
            }

            if let closestPoints = pds.closestPoints {
                var rect: NSRect
                var path: NSBezierPath

                let color = pds.closestPointsColor ?? NSColor.black
                color.set()

                let p1 = closestPoints.0.getAsNSPoint()
                let p2 = closestPoints.1.getAsNSPoint()

                rect = NSRect(x: p1.x - pointRadius, y: p1.y - pointRadius, width: 2 * pointRadius, height: 2 * pointRadius)
                path = NSBezierPath(ovalIn: rect)
                path.fill()

                rect = NSRect(x: p2.x - pointRadius, y: p2.y - pointRadius, width: 2 * pointRadius, height: 2 * pointRadius)
                path = NSBezierPath(ovalIn: rect)
                path.fill()

                path = NSBezierPath()
                path.lineWidth = 2

                path.move(to: p1)
                path.line(to: p2)
                path.close()
                path.stroke()
            }
        }
    }
    
}

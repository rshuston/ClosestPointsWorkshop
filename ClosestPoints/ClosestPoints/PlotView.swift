//
//  PlotView.swift
//  ClosestPoints
//
//  Created by Robert Huston on 11/20/16.
//  Copyright © 2016 Pinpoint Dynamics. All rights reserved.
//

import Cocoa

class PlotView: NSView {

    var pointDataSource: PointCollectionDataSource?

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        NSFrameRect(bounds)

        if let pds = pointDataSource {
            let radius: CGFloat = 4
            let points = pds.points
            let dimension = CGFloat(pds.maxDimension)
            for index in 0..<points.count {
                let pt = points[index]
                let x = pt.x * (bounds.size.width - 4 * radius) / dimension
                let y = pt.y * (bounds.size.height - 4 * radius) / dimension
                let r = NSRect(x: x + radius, y: y + radius, width: 2 * radius, height: 2 * radius)
                let path = NSBezierPath(ovalIn: r)
                path.fill()
            }
        }
    }
    
}

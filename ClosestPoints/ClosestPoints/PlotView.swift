//
//  PlotView.swift
//  ClosestPoints
//
//  Created by Robert Huston on 11/20/16.
//  Copyright © 2016 Pinpoint Dynamics. All rights reserved.
//

import Cocoa

class PlotView: NSView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        NSFrameRect(bounds)

        if let vc = AppUtils.appViewController() {
            let radius: CGFloat = 4
            let points = vc.pointCollection.points
            let dimension = CGFloat(vc.pointCollection.maxDimension)
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

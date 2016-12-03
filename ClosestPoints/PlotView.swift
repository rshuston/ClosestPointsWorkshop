//
//  PlotView.swift
//  ClosestPoints
//
//  Created by Robert Huston on 11/20/16.
//  Copyright © 2016 Pinpoint Dynamics. All rights reserved.
//

import Cocoa

class PlotView: NSView {

    func appViewController() -> ViewController? {
        return NSApplication.shared().mainWindow?.contentViewController as? ViewController
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        let borderRect = NSInsetRect(self.bounds, 1, 1)
        NSFrameRect(borderRect)

        if let vc = appViewController() {
            let border: CGFloat = 8
            let points = vc.pointCollection.points
            let dimension = CGFloat(vc.pointCollection.maxDimension)
            for index in 0..<points.count {
                let pt = points[index]
                pt.p.x = pt.p.x * bounds.size.width / dimension
                pt.p.y = pt.p.y * bounds.size.height / dimension
                let r = NSRect(x: pt.p.x - border/2, y: pt.p.y - border, width: border, height: border)
                let path = NSBezierPath(ovalIn: r)
                path.fill()
            }
        }
    }
    
}

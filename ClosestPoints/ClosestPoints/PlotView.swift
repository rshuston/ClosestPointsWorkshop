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
    let pointHighlightRadius: CGFloat = 6
    let pointCaptureMargin: CGFloat = 8

    var pointDataSource: PointCollectionDataSource?

    var selectedPoint: Point?

    lazy var appViewController = AppUtils.appViewController()

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // White background
        NSColor.white.set()
        NSBezierPath(rect: bounds).fill()

        // Black border
        NSColor.black.set()
        NSFrameRect(bounds)

        // Point data
        if let pds = pointDataSource {
            // Search rectangle
            if pds.searchRect != nil {
                NSColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.25).set()
                NSBezierPath(rect: NSInsetRect(pds.searchRect!, -pointRadius, -pointRadius)).fill()
            }

            // All points
            let points = pds.points
            for index in 0..<points.count {
                let pt = points[index]
                drawPoint(pt.getAsNSPoint(), radius: pointRadius, color: NSColor.black, withHighlight: pt.highlighted)
            }

            // Check point pair
            if let checkPoints = pds.checkPoints {
                drawPointPair(pointPair: (checkPoints.0.getAsNSPoint(), checkPoints.1.getAsNSPoint()),
                              radius: pointRadius,
                              lineWidth: 2,
                              color: pds.checkPointsColor ?? NSColor.black,
                              highlightPair: (checkPoints.0.highlighted, checkPoints.1.highlighted))
            }

            // Closest point pair
            if let closestPoints = pds.closestPoints {
                drawPointPair(pointPair: (closestPoints.0.getAsNSPoint(), closestPoints.1.getAsNSPoint()),
                              radius: pointRadius,
                              lineWidth: 2,
                              color: pds.closestPointsColor ?? NSColor.black,
                              highlightPair: (closestPoints.0.highlighted, closestPoints.1.highlighted))
            }
        }
    }

    func drawPoint(_ point: NSPoint, radius: CGFloat, color: NSColor, withHighlight: Bool) {
        color.set()

        var rect: NSRect

        rect = NSRect(x: point.x - radius, y: point.y - radius, width: 2 * radius, height: 2 * radius)
        NSBezierPath(ovalIn: rect).fill()

        if withHighlight {
            rect.origin.x = point.x - pointHighlightRadius
            rect.origin.y = point.y - pointHighlightRadius
            rect.size.width = 2 * pointHighlightRadius
            rect.size.height = 2 * pointHighlightRadius
            NSBezierPath(ovalIn: rect).stroke()
        }
    }

    func drawPointPair(pointPair: (NSPoint, NSPoint), radius: CGFloat, lineWidth: CGFloat, color: NSColor, highlightPair: (Bool, Bool)) {
        drawPoint(pointPair.0, radius: radius, color: color, withHighlight: highlightPair.0)
        drawPoint(pointPair.1, radius: radius, color: color, withHighlight: highlightPair.1)

        drawLine(from: pointPair.0, to: pointPair.1, width: lineWidth, color: color)
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

    override func mouseDown(with event: NSEvent) {
        let eventLocation = AppUtils.convertWindowNSPoint(point: event.locationInWindow, forView: self)

        let canMovePoint = ((appViewController?.isFindingClosestPoints() ?? true) != true)
        if canMovePoint {
            if let pds = pointDataSource {
                for point in pds.points {
                    let nsPoint = point.getAsNSPoint()
                    if AppUtils.IsNSPoint(point: eventLocation, onNSPoint: nsPoint, withMargin: pointCaptureMargin) {
                        point.highlighted = true
                        selectedPoint = point
                        appViewController?.requestPointDataSourceUpdate()
                        appViewController?.requestLiveSolutionIfConfigured()
                        needsDisplay = true
                        break
                    }
                }
            }
        }
    }

    override func mouseDragged(with event: NSEvent) {
        let eventLocation = AppUtils.convertWindowNSPoint(point: event.locationInWindow, forView: self)

        if selectedPoint != nil {
            let pinnedEventLocation = AppUtils.PinNSPoint(point: eventLocation, toNSRect: bounds, withMargin: pointRadius)
            selectedPoint!.x = pinnedEventLocation.x
            selectedPoint!.y = pinnedEventLocation.y
            appViewController?.requestPointDataSourceUpdate()
            appViewController?.requestLiveSolutionIfConfigured()
            needsDisplay = true
        }
    }

    override func mouseUp(with event: NSEvent) {
        if selectedPoint != nil {
            selectedPoint!.highlighted = false
            selectedPoint = nil
            appViewController?.requestPointDataSourceUpdate()
            appViewController?.requestLiveSolutionIfConfigured()
            needsDisplay = true
        }
    }

}

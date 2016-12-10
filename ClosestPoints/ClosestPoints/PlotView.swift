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

        NSFrameRect(bounds)

        if let pds = pointDataSource {
            let points = pds.points
            for index in 0..<points.count {
                let pt = points[index]
                drawPoint(pt.getAsNSPoint(), radius: pointRadius, color: NSColor.black, withHighlight: pt.highlighted)
            }

            if let checkPoints = pds.checkPoints {
                let color = pds.checkPointsColor ?? NSColor.black

                let p0 = checkPoints.0
                let p1 = checkPoints.1
                let nsP0 = p0.getAsNSPoint()
                let nsP1 = p1.getAsNSPoint()

                drawPoint(nsP0, radius: pointRadius, color: color, withHighlight: p0.highlighted)
                drawPoint(nsP1, radius: pointRadius, color: color, withHighlight: p1.highlighted)

                drawLine(from: nsP0, to: nsP1, width: 2, color: color)
            }

            if let closestPoints = pds.closestPoints {
                let color = pds.closestPointsColor ?? NSColor.black

                let p0 = closestPoints.0
                let p1 = closestPoints.1
                let nsP0 = p0.getAsNSPoint()
                let nsP1 = p1.getAsNSPoint()

                drawPoint(nsP0, radius: pointRadius, color: color, withHighlight: p0.highlighted)
                drawPoint(nsP1, radius: pointRadius, color: color, withHighlight: p1.highlighted)

                drawLine(from: nsP0, to: nsP1, width: 2, color: color)
            }
        }
    }

    func drawPoint(_ point: NSPoint, radius: CGFloat, color: NSColor, withHighlight: Bool) {
        color.set()

        var rect: NSRect
        var path: NSBezierPath

        rect = NSRect(x: point.x - radius, y: point.y - radius, width: 2 * radius, height: 2 * radius)
        path = NSBezierPath(ovalIn: rect)
        path.fill()

        if withHighlight {
            rect.origin.x = point.x - pointHighlightRadius
            rect.origin.y = point.y - pointHighlightRadius
            rect.size.width = 2 * pointHighlightRadius
            rect.size.height = 2 * pointHighlightRadius
            path = NSBezierPath(ovalIn: rect)
            path.stroke()
        }
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
                        appViewController?.triggerSolutionUpdate()
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
            appViewController?.triggerSolutionUpdate()
            needsDisplay = true
        }
    }

    override func mouseUp(with event: NSEvent) {
        if selectedPoint != nil {
            selectedPoint!.highlighted = false
            selectedPoint = nil
            appViewController?.triggerSolutionUpdate()
            needsDisplay = true
        }
    }

//    override func mouseEntered(with event: NSEvent) {
//    }

//    override func mouseExited(with event: NSEvent) {
//    }

//    override func mouseMoved(with event: NSEvent) {
//    }

}

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

        // Drawing code here.
        let borderRect = NSInsetRect(self.bounds, 1, 1)
        NSFrameRect(borderRect)
    }
    
}

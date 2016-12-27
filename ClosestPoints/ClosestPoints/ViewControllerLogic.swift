//
//  ViewControllerLogic.swift
//  ClosestPoints
//
//  Created by Robert Huston on 12/7/16.
//  Copyright © 2016 Pinpoint Dynamics. All rights reserved.
//

import Cocoa

// We use a ViewControllerLogic as a companion to ViewController so that we can more
// easily isolate the logic that can be test-driven from the standard MVC logic that
// adheres to the Cocoa design patterns.
//
// (Eewww! A comment! How untrendy! The horror of it all! Whaah! What can it mean?)

class ViewControllerLogic: NSObject {

    let minNumberOfPoints = 2
    let maxNumberOfPoints = 10000

    var pointCollection: PointCollection! = PointCollection()
    var definitionManager: DefinitionManager! = DefinitionManager()
    var controlManager: ControlManager! = ControlManager()
    var solutionEngine: SolutionEngine! = SolutionEngine()

    var hostViewController: ViewController!

    var lastSolutionTime_ms: Float = 0.0

    var startSolutionTime: CFTimeInterval = 0.0
    var endSolutionTime: CFTimeInterval = 0.0

    init(hostViewController: ViewController) {
        self.hostViewController = hostViewController
    }

    func viewDidLoad() {
        definitionManager.numberOfPoints = 3
        definitionManager.pointDistribution = DefinitionManager.PointDistribution.Uniform

        controlManager.solutionType = ControlManager.SolutionType.PermutationSearch
        controlManager.solverOption = ControlManager.SolverOption.OneShot

        hostViewController.setPlotViewPointCollectionDataSource(dataSource: pointCollection)
        hostViewController.setNumberOfPoints(numberOfPoints: definitionManager.numberOfPoints)
        hostViewController.updateSolutionTime(time_ms: lastSolutionTime_ms)

        generatePoints()

        activateGenerateButton()
        activateControlButtonIfCanSolve()
        configureControlButtonForSolvingState()
    }

    func constrainNumberOfPointsBox() {
        var value = hostViewController.getNumberOfPoints()
        if value < minNumberOfPoints {
            value = minNumberOfPoints
        }
        if value > maxNumberOfPoints {
            value = maxNumberOfPoints
        }
        hostViewController.setNumberOfPoints(numberOfPoints: value)
        definitionManager.numberOfPoints = value
    }

    internal func deactivateGenerateButton() {
        hostViewController.setGenerateButtonEnableState(enabled: false)
    }

    internal func activateGenerateButton() {
        hostViewController.setGenerateButtonEnableState(enabled: true)
    }

    internal func deactivateControlButton() {
        hostViewController.setControlButtonEnableState(enabled: false)
    }

    internal func activateControlButtonIfCanSolve() {
        switch controlManager.solutionType {
        case ControlManager.SolutionType.PermutationSearch:
            hostViewController.setControlButtonEnableState(enabled: pointCollection.points.count >= 2)
            break
        case ControlManager.SolutionType.CombinationSearch:
            hostViewController.setControlButtonEnableState(enabled: pointCollection.points.count >= 2)
            break
        case ControlManager.SolutionType.PlaneSweep:
            hostViewController.setControlButtonEnableState(enabled: pointCollection.points.count >= 2)
            break
        case ControlManager.SolutionType.DivideAndConquer:
            hostViewController.setControlButtonEnableState(enabled: pointCollection.points.count >= 2)
            break
        }
    }

    internal func configureControlButtonForSolvingState() {
        hostViewController.setControlButtonTitle(title: solutionEngine.solving ? "Cancel" : "Solve")
    }

    internal func requestPlotViewRedraw() {
        hostViewController.requestPlotViewRedraw()
    }

    func generatePoints() {
        deactivateGenerateButton()
        deactivateControlButton()

        pointCollection.clear()

        let plotSize = hostViewController.getPlotViewSize()
        let pointRadius = hostViewController.getPlotViewPointRadius()
        switch definitionManager.pointDistribution {
        case DefinitionManager.PointDistribution.Uniform:
            pointCollection.generateUniformRandomPoints(numberOfPoints: definitionManager.numberOfPoints,
                                                        maxX: plotSize.width,
                                                        maxY: plotSize.height,
                                                        margin: pointRadius)
            break
        case DefinitionManager.PointDistribution.Clustered:
            pointCollection.generateClusteredRandomPoints(numberOfPoints: definitionManager.numberOfPoints,
                                                          maxX: plotSize.width,
                                                          maxY: plotSize.height,
                                                          margin: pointRadius)
            break
        }

        requestPlotViewRedraw()

        activateGenerateButton()
        activateControlButtonIfCanSolve()

        requestLiveSolutionIfConfigured()
    }

    func findClosestPoints() {
        solutionEngine.solving = true

        var solver: Solver?
        switch controlManager.solutionType {
        case ControlManager.SolutionType.PermutationSearch:
            solver = solutionEngine.permutationSolver
            break
        case ControlManager.SolutionType.CombinationSearch:
            solver = solutionEngine.combinationSolver
            break
        case ControlManager.SolutionType.PlaneSweep:
            solver = solutionEngine.planeSweepSolver
            break
        case ControlManager.SolutionType.DivideAndConquer:
            solver = solutionEngine.divideAndConquerSolver
            break
        }

        if solver != nil {
            deactivateGenerateButton()

            pointCollection.clearAllDataExceptForPoints()

            configureControlButtonForSolvingState()

            let monitor: ((NSRect?, (Point, Point)?, (Point, Point)?) -> Bool)?
            switch controlManager.solverOption {
            case ControlManager.SolverOption.OneShot:
                monitor = monitorCancelOnly
                break
            case ControlManager.SolverOption.SlowAnimation:
                monitor = monitorWaitCancelSlow
                break
            case ControlManager.SolverOption.FastAnimation:
                monitor = monitorWaitCancelFast
                break
            case ControlManager.SolverOption.Live:
                monitor = monitorCancelOnly
                break
            }

            startSolutionTime = 0.0
            endSolutionTime = 0.0

            DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
                self.startSolutionTime = CFAbsoluteTimeGetCurrent()
                solver!.findClosestPoints(points: self.pointCollection.points,
                                          monitor: monitor,
                                          completion: self.completion)
            }
        } else {
            solutionEngine.solving = false
        }
    }

    internal func monitorCancelOnly(checkRect: NSRect?, checkPoints: (Point, Point)?, closestPointsSoFar: (Point, Point)?) -> Bool {
        return solutionEngine.solving
    }

    internal func monitorWaitCancelSlow(checkRect: NSRect?, checkPoints: (Point, Point)?, closestPointsSoFar: (Point, Point)?) -> Bool {
        pointCollection.closestPoints = closestPointsSoFar
        pointCollection.closestPointsColor = NSColor.blue
        pointCollection.checkPoints = checkPoints
        pointCollection.checkPointsColor = NSColor.red
        pointCollection.searchRect = checkRect
        DispatchQueue.main.async {
            self.requestPlotViewRedraw()
        }
        usleep(25000)
        return solutionEngine.solving
    }

    internal func monitorWaitCancelFast(checkRect: NSRect?, checkPoints: (Point, Point)?, closestPointsSoFar: (Point, Point)?) -> Bool {
        pointCollection.closestPoints = closestPointsSoFar
        pointCollection.closestPointsColor = NSColor.blue
        pointCollection.checkPoints = checkPoints
        pointCollection.checkPointsColor = NSColor.red
        pointCollection.searchRect = checkRect
        DispatchQueue.main.async {
            self.requestPlotViewRedraw()
        }
        usleep(1000)
        return solutionEngine.solving
    }

    internal func completion(closestPoints: (Point, Point)?) {
        endSolutionTime = CFAbsoluteTimeGetCurrent()
        lastSolutionTime_ms = Float(endSolutionTime - startSolutionTime) * 1000.0
        if solutionEngine.solving {
            pointCollection.closestPoints = closestPoints
            pointCollection.closestPointsColor = NSColor.blue
            pointCollection.checkPoints = nil
            pointCollection.checkPointsColor = nil
            pointCollection.searchRect = nil
        }
        DispatchQueue.main.async {
            self.requestPlotViewRedraw()
            self.solutionEngine.solving = false
            self.configureControlButtonForSolvingState()
            self.activateGenerateButton()
            self.activateControlButtonIfCanSolve()
            self.hostViewController.updateSolutionTime(time_ms: self.lastSolutionTime_ms)
        }
    }

    func isFindingClosestPoints() -> Bool {
        return solutionEngine.solving
    }

    func requestLiveSolutionIfConfigured() {
        switch controlManager.solverOption {
        case ControlManager.SolverOption.OneShot:
            break
        case ControlManager.SolverOption.SlowAnimation:
            break
        case ControlManager.SolverOption.FastAnimation:
            break
        case ControlManager.SolverOption.Live:
            findClosestPoints()
            break
        }
    }

    func updatePointDataSource() {
        pointCollection.clearAllDataExceptForPoints()
    }

}

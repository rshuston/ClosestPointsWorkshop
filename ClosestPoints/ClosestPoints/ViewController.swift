//
//  ViewController.swift
//  ClosestPoints
//
//  Created by Robert Huston on 11/11/16.
//  Copyright © 2016 Pinpoint Dynamics. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTextFieldDelegate, NSComboBoxDelegate {

    // MARK: - IBOutlet references

    // Plotting
    @IBOutlet weak var o_PlotView: PlotView!

    // Definition
    @IBOutlet weak var o_NumberOfPointsBox: NSComboBox!
    @IBOutlet weak var o_PointDistributionPopUp: NSPopUpButton!
    @IBOutlet weak var o_GenerateButton: NSButton!

    // Control
    @IBOutlet weak var o_SolutionTypePopUp: NSPopUpButton!
    @IBOutlet weak var o_SolverOptionPopUp: NSPopUpButton!
    @IBOutlet weak var o_ControlButton: NSButton!
    @IBOutlet weak var o_SolutionTimeLabel: NSTextField!

    // MARK: - Composition

    var viewControllerLogic: ViewControllerLogic!

    // MARK: - NSViewController life cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllerLogic = ViewControllerLogic(hostViewController: self)
        viewControllerLogic.viewDidLoad()
    }

    // NOTE: Do we still need to keep this?
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    // MARK: - Parameter access methods
    
    func setPlotViewPointCollectionDataSource(dataSource: PointCollectionDataSource) {
        o_PlotView.pointDataSource = dataSource
    }

    func getNumberOfPoints() -> Int {
        return o_NumberOfPointsBox.integerValue
    }

    func setNumberOfPoints(numberOfPoints: Int) {
        o_NumberOfPointsBox.integerValue = numberOfPoints
    }

    func getPlotViewSize() -> CGSize {
        return o_PlotView.bounds.size
    }

    func getPlotViewPointRadius() -> CGFloat {
        return o_PlotView.pointRadius
    }

    // MARK: - Control modifiers

    func setGenerateButtonEnableState(enabled: Bool) {
        o_GenerateButton.isEnabled = enabled
    }

    func setControlButtonEnableState(enabled: Bool) {
        o_ControlButton.isEnabled = enabled
    }

    func setControlButtonTitle(title: String) {
        o_ControlButton.title = title
    }

    func updateSolutionTime(time_ms: Float) {
        o_SolutionTimeLabel.stringValue = String(format: "%.2f ms", time_ms)
    }

    // MARK: - Other commands

    func requestPlotViewRedraw() {
        o_PlotView.needsDisplay = true
    }

    func requestPointDataSourceUpdate() {
        viewControllerLogic.updatePointDataSource()
        o_PlotView.needsDisplay = true
    }

    func requestLiveSolutionIfConfigured() {
        viewControllerLogic.requestLiveSolutionIfConfigured()
    }

    func isFindingClosestPoints() -> Bool {
        return viewControllerLogic.isFindingClosestPoints()
    }

    // MARK: - NSObject notification methods

    override func controlTextDidEndEditing(_ obj: Notification) {
        // Called when value is directly entered into combo box
        if let comboBox: NSComboBox = (obj.object as? NSComboBox) {
            if comboBox == o_NumberOfPointsBox {
                viewControllerLogic.constrainNumberOfPointsBox()
                viewControllerLogic.activateGenerateButton()
                viewControllerLogic.activateControlButtonIfCanSolve()
            }
        }
    }

    // MARK: - NSComboBoxDelegate methods

    func comboBoxSelectionDidChange(_ notification: Notification) {
        // Called when value in combo box list selected
        if let comboBox: NSComboBox = (notification.object as? NSComboBox) {
            if comboBox == o_NumberOfPointsBox {
                if let stringValue = o_NumberOfPointsBox.objectValueOfSelectedItem as? String {
                    let index = o_NumberOfPointsBox.indexOfSelectedItem
                    o_NumberOfPointsBox.deselectItem(at: index)
                    if let value = Int(stringValue) {
                        o_NumberOfPointsBox.integerValue = value
                        viewControllerLogic.definitionManager.numberOfPoints = value
                        viewControllerLogic.activateGenerateButton()
                        viewControllerLogic.activateControlButtonIfCanSolve()
                    }
                }
            }
        }
    }

    // MARK: - IBAction methods

    @IBAction func popUpButtonSelected(_ sender: NSPopUpButton) {
        switch sender {
        case o_PointDistributionPopUp:
            switch sender.titleOfSelectedItem {
            case "Uniform"?:
                viewControllerLogic.definitionManager.pointDistribution = DefinitionManager.PointDistribution.Uniform
                break
            case "Clustered"?:
                viewControllerLogic.definitionManager.pointDistribution = DefinitionManager.PointDistribution.Clustered
                break
            default:
                break
            }
            break
        case o_SolutionTypePopUp:
            switch sender.titleOfSelectedItem {
            case "Permutation Search"?:
                viewControllerLogic.controlManager.solutionType = ControlManager.SolutionType.PermutationSearch
                break
            case "Combination Search"?:
                viewControllerLogic.controlManager.solutionType = ControlManager.SolutionType.CombinationSearch
                break
            case "Plane Sweep"?:
                viewControllerLogic.controlManager.solutionType = ControlManager.SolutionType.PlaneSweep
                break
            case "Divide and Conquer"?:
                viewControllerLogic.controlManager.solutionType = ControlManager.SolutionType.DivideAndConquer
                break
            default:
                break
            }
            break
        case o_SolverOptionPopUp:
            switch sender.titleOfSelectedItem {
            case "One Shot"?:
                viewControllerLogic.controlManager.solverOption = ControlManager.SolverOption.OneShot
                break
            case "Slow Animation"?:
                viewControllerLogic.controlManager.solverOption = ControlManager.SolverOption.SlowAnimation
                break
            case "Fast Animation"?:
                viewControllerLogic.controlManager.solverOption = ControlManager.SolverOption.FastAnimation
                break
            case "Live"?:
                viewControllerLogic.controlManager.solverOption = ControlManager.SolverOption.Live
                viewControllerLogic.requestLiveSolutionIfConfigured()
                break
            default:
                break
            }
            break
        default:
            break
        }

        viewControllerLogic.activateGenerateButton()
        viewControllerLogic.activateControlButtonIfCanSolve()

        requestPointDataSourceUpdate()
    }

    @IBAction func pushButtonSelected(_ sender: NSButton) {
        switch sender {
        case o_GenerateButton:
            viewControllerLogic.generatePoints()
            break
        case o_ControlButton:
            if viewControllerLogic.solutionEngine.solving {
                viewControllerLogic.solutionEngine.solving = false
            } else {
                viewControllerLogic.findClosestPoints()
            }
            break
        default:
            break
        }
    }

}

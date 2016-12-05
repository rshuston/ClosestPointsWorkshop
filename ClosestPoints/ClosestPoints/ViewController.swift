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

    // Control
    @IBOutlet weak var o_SolutionTypePopUp: NSPopUpButton!
    @IBOutlet weak var o_SolverOptionPopUp: NSPopUpButton!
    @IBOutlet weak var o_GenerateButton: NSButton!
    @IBOutlet weak var o_ControlButton: NSButton!

    // MARK: - Composition

    let minNumberOfPoints = 3
    let maxNumberOfPoints = 100

    let pointCollection = PointCollection()
    let definitionManager = DefinitionManager()
    let controlManager = ControlManager()
    let solutionEngine = SolutionEngine()

    // MARK: - IBAction methods

    @IBAction func popUpButtonSelected(_ sender: NSPopUpButton) {
        switch sender {
        case o_PointDistributionPopUp:
            switch sender.titleOfSelectedItem {
            case "Uniform"?:
                definitionManager.pointDistribution = DefinitionManager.PointDistribution.Uniform
                break
            case "Clustered"?:
                definitionManager.pointDistribution = DefinitionManager.PointDistribution.Clustered
                break
            default:
                break
            }
            break
        case o_SolutionTypePopUp:
            switch sender.titleOfSelectedItem {
            case "Naive Combination"?:
                controlManager.solutionType = ControlManager.SolutionType.NaiveCombination
                break
            case "Sorted Search"?:
                controlManager.solutionType = ControlManager.SolutionType.SortedSearch
                break
            case "Plane Sweep"?:
                controlManager.solutionType = ControlManager.SolutionType.PlaneSweep
                break
            case "Divide and Conquer"?:
                controlManager.solutionType = ControlManager.SolutionType.DivideAndConquer
                break
            default:
                break
            }
            break
        case o_SolverOptionPopUp:
            switch sender.titleOfSelectedItem {
            case "Live"?:
                controlManager.solverOption = ControlManager.SolverOption.Live
                break
            case "Fast Animation"?:
                controlManager.solverOption = ControlManager.SolverOption.FastAnimation
                break
            case "Slow Animation"?:
                controlManager.solverOption = ControlManager.SolverOption.SlowAnimation
                break
            case "Single Step"?:
                controlManager.solverOption = ControlManager.SolverOption.SingleStep
                break
            default:
                break
            }
            break
        default:
            break
        }

        activateButtons()
    }

    @IBAction func pushButtonSelected(_ sender: NSButton) {
        switch sender {
        case o_GenerateButton:
            generatePoints()
            activateButtons()
            break
        case o_ControlButton:
            deactivateButtons()
            solutionEngine.findClosestPoints()
            triggerPlotViewRedraw()
            activateButtons()
            break
        default:
            break
        }
    }

    // MARK: - NSViewController life cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        o_PlotView.pointDataSource = pointCollection

        o_NumberOfPointsBox.integerValue = minNumberOfPoints

        definitionManager.numberOfPoints = o_NumberOfPointsBox.integerValue
        definitionManager.pointDistribution = DefinitionManager.PointDistribution.Uniform

        controlManager.solutionType = ControlManager.SolutionType.NaiveCombination
        controlManager.solverOption = ControlManager.SolverOption.Live

        // SPIKE: ... for now
        o_ControlButton.title = "Run"

        generatePoints()
        activateButtons()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    // MARK: - NSObject notification methods

    override func controlTextDidEndEditing(_ obj: Notification) {
        // Called when value is directly entered into combo box
        if let comboBox: NSComboBox = (obj.object as? NSComboBox) {
            if comboBox == o_NumberOfPointsBox {
                constrainNumberOfPointsBox()
                activateButtons()
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
                        definitionManager.numberOfPoints = value
                        activateButtons()
                    }
                }
            }
        }
    }

    // MARK: - Behavior methods

    func activateButtons() {
        o_GenerateButton.isEnabled = true
        o_ControlButton.isEnabled = (pointCollection.points.count > 0)
    }

    func deactivateButtons() {
        o_GenerateButton.isEnabled = false
        o_ControlButton.isEnabled = false
    }

    func triggerPlotViewRedraw() {
        o_PlotView.needsDisplay = true
    }

    func constrainNumberOfPointsBox() {
        var value = o_NumberOfPointsBox.integerValue
        if value < minNumberOfPoints {
            value = minNumberOfPoints
        }
        if value > maxNumberOfPoints {
            value = maxNumberOfPoints
        }
        o_NumberOfPointsBox.integerValue = value
        definitionManager.numberOfPoints = o_NumberOfPointsBox.integerValue
    }

    func generatePoints() {
        constrainNumberOfPointsBox()

        pointCollection.clear()
        switch definitionManager.pointDistribution {
        case DefinitionManager.PointDistribution.Uniform:
            pointCollection.generateUniformRandomPoints(numberOfPoints: definitionManager.numberOfPoints)
            break
        case DefinitionManager.PointDistribution.Clustered:
            pointCollection.generateClusteredRandomPoints(numberOfPoints: definitionManager.numberOfPoints)
            break
        }

        triggerPlotViewRedraw()
    }

}


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
    @IBOutlet weak var o_SolverOptionsPopUp: NSPopUpButton!
    @IBOutlet weak var o_GenerateButton: NSButton!
    @IBOutlet weak var o_ControlButton: NSButton!

    // MARK: - Composition

    let minNumberOfPoints = 3
    let maxNumberOfPoints = 100

    let pointCollection = PointCollection()
    let definitionManager = DefinitionManager()

    // MARK: - IBAction methods

    @IBAction func popUpButtonSelected(_ sender: NSPopUpButton) {
        switch sender {
        case o_PointDistributionPopUp:
            if sender.indexOfSelectedItem == 1 {
                definitionManager.distribution = DefinitionManager.PointDistribution.Clustered
            } else {
                definitionManager.distribution = DefinitionManager.PointDistribution.Uniform
            }
            break
        case o_SolutionTypePopUp:
            break
        case o_SolverOptionsPopUp:
            break
        default:
            break
        }

        // let title = sender.titleOfSelectedItem
    }

    @IBAction func pushButtonSelected(_ sender: NSButton) {
        switch sender {
        case o_GenerateButton:
            updatePoints()
            break
        case o_ControlButton:
            break
        default:
            break
        }
    }

    // MARK: - NSViewController life cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        o_NumberOfPointsBox.integerValue = minNumberOfPoints

        definitionManager.numberOfPoints = o_NumberOfPointsBox.integerValue
        definitionManager.distribution = DefinitionManager.PointDistribution.Uniform
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
                constrainNumberOfPoints()
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
                        definitionManager.numberOfPoints = o_NumberOfPointsBox.integerValue
                    }
                }
            }
        }
    }

    func constrainNumberOfPoints() {
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

    func updatePoints() {
        constrainNumberOfPoints()

        pointCollection.clear()
        switch definitionManager.distribution {
        case DefinitionManager.PointDistribution.Uniform:
            pointCollection.generateUniformRandomPoints(numberOfPoints: definitionManager.numberOfPoints)
            break
        case DefinitionManager.PointDistribution.Clustered:
            pointCollection.generateClusteredRandomPoints(numberOfPoints: definitionManager.numberOfPoints)
            break
        }

        o_PlotView.needsDisplay = true
    }

}


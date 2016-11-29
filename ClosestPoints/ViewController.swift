//
//  ViewController.swift
//  ClosestPoints
//
//  Created by Robert Huston on 11/11/16.
//  Copyright © 2016 Pinpoint Dynamics. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTextFieldDelegate, NSComboBoxDelegate {

    @IBOutlet weak var o_NumberOfPointsBox: NSComboBox!
    @IBOutlet weak var o_PointDistributionPopUp: NSPopUpButton!
    @IBOutlet weak var o_SolutionTypePopUp: NSPopUpButton!
    @IBOutlet weak var o_SolverOptionsPopUp: NSPopUpButton!
    @IBOutlet weak var o_GenerateButton: NSButton!
    @IBOutlet weak var o_ControlButton: NSButton!

    // MARK: - IBAction methods

    @IBAction func popUpButtonSelected(_ sender: NSPopUpButton) {
        switch sender {
        case o_PointDistributionPopUp:
            print("Point Distribution")
            break
        case o_SolutionTypePopUp:
            print("Solution Type")
            break
        case o_SolverOptionsPopUp:
            print("Solver Options")
            break
        default:
            break
        }

        let title = sender.titleOfSelectedItem
        print("... \(title)")
    }

    @IBAction func pushButtonSelected(_ sender: NSButton) {
        switch sender {
        case o_GenerateButton:
            print("Generate")
            break
        case o_ControlButton:
            print("Control")
            break
        default:
            break
        }
    }

    // MARK: - NSViewController life cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        o_NumberOfPointsBox.integerValue = 2
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
                var value = o_NumberOfPointsBox.integerValue
                if value < 2 {
                    value = 2
                    o_NumberOfPointsBox.integerValue = value
                    print("Number of points = \(value)")
                }
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
                        print("Number of points = \(value)")
                    }
                }
            }
        }
    }

}


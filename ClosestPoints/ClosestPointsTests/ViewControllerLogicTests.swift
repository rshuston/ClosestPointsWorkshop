//
//  ViewControllerLogicTests.swift
//  ClosestPoints
//
//  Created by Robert Huston on 12/7/16.
//  Copyright © 2016 Pinpoint Dynamics. All rights reserved.
//

import XCTest

import PDLTestBench

@testable import ClosestPoints

class ViewControllerLogicTests: XCTestCase {

    // MARK: - Setup and tear down

    var mockViewController: MockViewController!
    var subject: ViewControllerLogic!

    override func setUp() {
        super.setUp()

        mockViewController = MockViewController()
        mockViewController.createMockOutlets()

        subject = ViewControllerLogic(hostViewController: mockViewController)
    }

    override func tearDown() {
        subject = nil
        mockViewController = nil

        super.tearDown()
    }

    // MARK: - init()

    func test_init_SetsHostViewController() {
        XCTAssertEqual(subject.hostViewController, mockViewController)
    }

    // MARK: - viewDidLoad()

    func test_viewDidLoad_InitializesDefinitionManagerForThreePointsAndUniformDistribution() {
        subject.viewDidLoad()

        XCTAssertEqual(subject.definitionManager.numberOfPoints, 3)
        XCTAssertEqual(subject.definitionManager.pointDistribution, DefinitionManager.PointDistribution.Uniform)
    }

    func test_viewDidLoad_InitializesControlManagerForPermutationSearchAndOneShotSolution() {
        subject.viewDidLoad()

        XCTAssertEqual(subject.controlManager.solutionType, ControlManager.SolutionType.PermutationSearch)
        XCTAssertEqual(subject.controlManager.solverOption, ControlManager.SolverOption.OneShot)
    }

    func test_viewDidLoad_ConnectsPlotViewPointDataSourceToPointCollection() {
        subject.viewDidLoad()

        // We do this "AnyObject" monkey business because we're trying to compare protocol objects
        let actualDataSource = mockViewController.o_PlotView.pointDataSource as AnyObject?
        let expectedDataSource = subject.pointCollection as AnyObject?
        XCTAssert(actualDataSource === expectedDataSource)
    }

    func test_viewDidLoad_InitializesTheNumberOfPointsComboBoxValueToThree() {
        subject.viewDidLoad()

        XCTAssertEqual(mockViewController.o_NumberOfPointsBox.integerValue, 3)
    }

    func test_viewDidLoad_SetsSolutionTimeLabelToZero() {
        subject.viewDidLoad()

        XCTAssertEqual(mockViewController.recorder.getCallCountFor("updateSolutionTime"), 1)
        let callRecord = mockViewController.recorder.getCallRecordFor("updateSolutionTime")
        XCTAssertEqual(callRecord?[0] as? Float, 0.0)
    }

    func test_viewDidLoad_GeneratesThreePoints() {
        subject.viewDidLoad()

        XCTAssertEqual(subject.pointCollection.points.count, 3)
    }

    func test_viewDidLoad_EnablesGenerateButton() {
        subject.viewDidLoad()

        XCTAssertTrue(mockViewController.o_GenerateButton.isEnabled)
    }

    func test_viewDidLoad_EnablesControlButton() {
        subject.viewDidLoad()

        XCTAssertTrue(mockViewController.o_ControlButton.isEnabled)
    }

    func test_viewDidLoad_SetsControlButtonTitle() {
        subject.viewDidLoad()

        XCTAssertEqual(mockViewController.o_ControlButton.title, "Solve")
    }

    // MARK: - updateNumberOfPointsBox()

    func test_updateNumberOfPointsBox_ClampsLowValuesToMinimum() {
        mockViewController.player.setReturnValue(subject.minNumberOfPoints - 1, forName: "getNumberOfPoints")

        subject.updateNumberOfPointsBox()

        XCTAssertEqual(mockViewController.recorder.getCallCountFor("setNumberOfPoints"), 1)
        let callRecord = mockViewController.recorder.getCallRecordFor("setNumberOfPoints")
        XCTAssertEqual(callRecord?[0] as? Int, subject.minNumberOfPoints)
        XCTAssertEqual(subject.definitionManager.numberOfPoints, subject.minNumberOfPoints)
    }

    func test_updateNumberOfPointsBox_ClampsHighValuesToMaximum() {
        mockViewController.player.setReturnValue(subject.maxNumberOfPoints + 1, forName: "getNumberOfPoints")

        subject.updateNumberOfPointsBox()

        XCTAssertEqual(mockViewController.recorder.getCallCountFor("setNumberOfPoints"), 1)
        let callRecord = mockViewController.recorder.getCallRecordFor("setNumberOfPoints")
        XCTAssertEqual(callRecord?[0] as? Int, subject.maxNumberOfPoints)
        XCTAssertEqual(subject.definitionManager.numberOfPoints, subject.maxNumberOfPoints)
    }

    // MARK: - deactivateGenerateButton()

    func test_deactivateGenerateButton_TellsViewControllerToDisableGenerateButton() {
        subject.deactivateGenerateButton()

        XCTAssertEqual(mockViewController.recorder.getCallCountFor("setGenerateButtonEnableState"), 1)
        let callRecord = mockViewController.recorder.getCallRecordFor("setGenerateButtonEnableState")
        XCTAssertEqual(callRecord?[0] as? Bool, false)
    }

    // MARK: - activateGenerateButton()

    func test_activateGenerateButton_TellsViewControllerToEnableGenerateButton() {
        subject.activateGenerateButton()

        XCTAssertEqual(mockViewController.recorder.getCallCountFor("setGenerateButtonEnableState"), 1)
        let callRecord = mockViewController.recorder.getCallRecordFor("setGenerateButtonEnableState")
        XCTAssertEqual(callRecord?[0] as? Bool, true)
    }

    // MARK: - deactivateControlButton()

    func test_deactivateControlButton_TellsViewControllerToDisableControlButton() {
        subject.deactivateControlButton()

        XCTAssertEqual(mockViewController.recorder.getCallCountFor("setControlButtonEnableState"), 1)
        let callRecord = mockViewController.recorder.getCallRecordFor("setControlButtonEnableState")
        XCTAssertEqual(callRecord?[0] as? Bool, false)
    }

    // MARK: - activateControlButtonIfCanSolve()

    func test_activateControlButtonIfCanSolve_DisablesControlButtonForNoPoints() {
        subject.pointCollection.points = []

        subject.activateControlButtonIfCanSolve()

        XCTAssertEqual(mockViewController.recorder.getCallCountFor("setControlButtonEnableState"), 1)
        let callRecord = mockViewController.recorder.getCallRecordFor("setControlButtonEnableState")
        XCTAssertEqual(callRecord?[0] as? Bool, false)
    }

    func test_activateControlButtonIfCanSolve_EnablesControlButtonForTwoPoints() {
        subject.pointCollection.points = [Point(x: 1, y: 2), Point(x: 3, y: 4)]

        subject.activateControlButtonIfCanSolve()

        XCTAssertEqual(mockViewController.recorder.getCallCountFor("setControlButtonEnableState"), 1)
        let callRecord = mockViewController.recorder.getCallRecordFor("setControlButtonEnableState")
        XCTAssertEqual(callRecord?[0] as? Bool, true)
    }

    // MARK: - configureControlButtonForSolvingState()

    func test_configureControlButtonForSolvingState_SetsTitleToSolveIfNotSolving() {
        subject.solutionEngine.solving = false

        subject.configureControlButtonForSolvingState()

        XCTAssertEqual(mockViewController.recorder.getCallCountFor("setControlButtonTitle"), 1)
        let callRecord = mockViewController.recorder.getCallRecordFor("setControlButtonTitle")
        XCTAssertEqual(callRecord?[0] as? String, "Solve")
    }

    func test_configureControlButtonForSolvingState_SetsTitleToCancelIfSolving() {
        subject.solutionEngine.solving = true

        subject.configureControlButtonForSolvingState()

        XCTAssertEqual(mockViewController.recorder.getCallCountFor("setControlButtonTitle"), 1)
        let callRecord = mockViewController.recorder.getCallRecordFor("setControlButtonTitle")
        XCTAssertEqual(callRecord?[0] as? String, "Cancel")
    }

    // MARK: - requestPlotViewRedraw()

    func test_requestPlotViewRedraw_TriggersViewControllerToRedrawPlotView() {
        subject.requestPlotViewRedraw()

        XCTAssertEqual(mockViewController.recorder.getCallCountFor("requestPlotViewRedraw"), 1)
    }

    // MARK: - generatePoints()

    func test_generatePoints_TellsPointCollectionToGenerateUniformRandomPoints() {
        let mockPointCollection = MockPointCollection()
        let expectedNumberOfPoints = 5

        subject.pointCollection = mockPointCollection
        subject.definitionManager.numberOfPoints = expectedNumberOfPoints
        subject.definitionManager.pointDistribution = DefinitionManager.PointDistribution.Uniform

        subject.generatePoints()
        
        XCTAssertEqual(mockPointCollection.recorder.getCallCountFor("generateUniformRandomPoints"), 1)
        let callRecord = mockPointCollection.recorder.getCallRecordFor("generateUniformRandomPoints")
        XCTAssertEqual(callRecord?[0] as? Int, expectedNumberOfPoints)
    }

    func test_generatePoints_TellsPointCollectionToGenerateClusteredRandomPoints() {
        let mockPointCollection = MockPointCollection()
        let expectedNumberOfPoints = 5

        subject.pointCollection = mockPointCollection
        subject.definitionManager.numberOfPoints = expectedNumberOfPoints
        subject.definitionManager.pointDistribution = DefinitionManager.PointDistribution.Clustered

        subject.generatePoints()

        XCTAssertEqual(mockPointCollection.recorder.getCallCountFor("generateClusteredRandomPoints"), 1)
        let callRecord = mockPointCollection.recorder.getCallRecordFor("generateClusteredRandomPoints")
        XCTAssertEqual(callRecord?[0] as? Int, expectedNumberOfPoints)
    }

    func test_generatePoints_RequestsSolutionWhenConfiguredForLive() {
        let mockPointCollection = MockPointCollection()
        let expectedNumberOfPoints = 5

        subject.pointCollection = mockPointCollection
        subject.definitionManager.numberOfPoints = expectedNumberOfPoints
        subject.definitionManager.pointDistribution = DefinitionManager.PointDistribution.Uniform

        let mockPermutationSolver = MockPermutationSolver()
        let mockCombinationSolver = MockCombinationSolver()

        subject.solutionEngine.permutationSolver = mockPermutationSolver
        subject.solutionEngine.combinationSolver = mockCombinationSolver

        subject.controlManager.solutionType = ControlManager.SolutionType.PermutationSearch
        subject.controlManager.solverOption = ControlManager.SolverOption.Live

        mockPermutationSolver.completionExpectation = expectation(description: "completion")

        subject.generatePoints()

        waitForExpectations(timeout: 1.0, handler: nil)

        XCTAssertEqual(mockPermutationSolver.recorder.getCallCountFor("findClosestPoints (P)"), 1)
    }

    func test_generatePoints_DoesNotRequestSolutionWhenNotConfiguredForLive() {
        let mockPointCollection = MockPointCollection()
        let expectedNumberOfPoints = 5

        subject.pointCollection = mockPointCollection
        subject.definitionManager.numberOfPoints = expectedNumberOfPoints
        subject.definitionManager.pointDistribution = DefinitionManager.PointDistribution.Uniform

        let mockPermutationSolver = MockPermutationSolver()
        let mockCombinationSolver = MockCombinationSolver()

        subject.solutionEngine.permutationSolver = mockPermutationSolver
        subject.solutionEngine.combinationSolver = mockCombinationSolver

        subject.controlManager.solutionType = ControlManager.SolutionType.PermutationSearch
        subject.controlManager.solverOption = ControlManager.SolverOption.OneShot

        subject.generatePoints()

        XCTAssertEqual(mockPermutationSolver.recorder.getCallCountFor("findClosestPoints (P)"), 0)
    }

    // MARK: - findClosestPoints()

    func test_findClosestPoints_FindsSolutionUsingPermutationSearchWithClosures() {
        let mockPermutationSolver = MockPermutationSolver()
        let mockCombinationSolver = MockCombinationSolver()
        let mockPlaneSweepSolver = MockPlaneSweepSolver()
        let mockDivideAndConquerSolver = MockDivideAndConquerSolver()

        subject.solutionEngine.permutationSolver = mockPermutationSolver
        subject.solutionEngine.combinationSolver = mockCombinationSolver
        subject.solutionEngine.planeSweepSolver = mockPlaneSweepSolver
        subject.solutionEngine.divideAndConquerSolver = mockDivideAndConquerSolver

        subject.controlManager.solutionType = ControlManager.SolutionType.PermutationSearch
        subject.controlManager.solverOption = ControlManager.SolverOption.OneShot

        subject.pointCollection.points = [Point(x: 1, y: 2), Point(x: 3, y: 4)]

        subject.lastSolutionTime_ms = 0.0
        subject.startSolutionTime = 0.0
        subject.endSolutionTime = 0.0

        mockPermutationSolver.completionExpectation = expectation(description: "completion")

        subject.findClosestPoints()

        waitForExpectations(timeout: 1.0, handler: nil)

        XCTAssertEqual(mockPermutationSolver.recorder.getCallCountFor("findClosestPoints (P)"), 1)
        XCTAssertEqual(mockCombinationSolver.recorder.getCallCountFor("findClosestPoints (C)"), 0)
        XCTAssertEqual(mockPlaneSweepSolver.recorder.getCallCountFor("findClosestPoints (PS)"), 0)
        XCTAssertEqual(mockDivideAndConquerSolver.recorder.getCallCountFor("findClosestPoints (DQ)"), 0)

        let record = mockPermutationSolver.recorder.getCallRecordFor("findClosestPoints (P)")

        XCTAssertEqual(3, record?.count)
        let points = record?[0] as? [Point]
        let monitorClosure = record?[1] as? ((NSRect?, (Point, Point)?, (Point, Point)?) -> Bool)
        let completionClosure = record?[2] as? (((Point, Point)?) -> Void)

        XCTAssertNotNil(points)
        XCTAssertEqual(points!, subject.pointCollection.points)

        let pointPair1 = (subject.pointCollection.points[0], subject.pointCollection.points[1])
        let pointPair2 = (subject.pointCollection.points[0], subject.pointCollection.points[1])
        let dummyRect = NSRect(x: 0, y: 0, width: 1, height: 1)
        let keepGoing = monitorClosure?(dummyRect, pointPair1, pointPair2)
        XCTAssertTrue(keepGoing!)
        XCTAssertNil(subject.pointCollection.checkPoints)
        XCTAssertNil(subject.pointCollection.closestPoints)

        completionClosure?(pointPair2)
        XCTAssertNil(subject.pointCollection.checkPoints)
        XCTAssertNotNil(subject.pointCollection.closestPoints)

        XCTAssertNotEqual(subject.startSolutionTime, 0.0)
        XCTAssertNotEqual(subject.endSolutionTime, 0.0)
        XCTAssertNotEqual(subject.lastSolutionTime_ms, 0.0)
    }

    func test_findClosestPoints_FindsSolutionUsingCombinationSearchWithClosures() {
        let mockPermutationSolver = MockPermutationSolver()
        let mockCombinationSolver = MockCombinationSolver()
        let mockPlaneSweepSolver = MockPlaneSweepSolver()
        let mockDivideAndConquerSolver = MockDivideAndConquerSolver()

        subject.solutionEngine.permutationSolver = mockPermutationSolver
        subject.solutionEngine.combinationSolver = mockCombinationSolver
        subject.solutionEngine.planeSweepSolver = mockPlaneSweepSolver
        subject.solutionEngine.divideAndConquerSolver = mockDivideAndConquerSolver

        subject.controlManager.solutionType = ControlManager.SolutionType.CombinationSearch
        subject.controlManager.solverOption = ControlManager.SolverOption.OneShot

        subject.pointCollection.points = [Point(x: 1, y: 2), Point(x: 3, y: 4)]

        subject.lastSolutionTime_ms = 0.0
        subject.startSolutionTime = 0.0
        subject.endSolutionTime = 0.0

        mockCombinationSolver.completionExpectation = expectation(description: "completion")

        subject.findClosestPoints()

        waitForExpectations(timeout: 1.0, handler: nil)

        XCTAssertEqual(mockPermutationSolver.recorder.getCallCountFor("findClosestPoints (P)"), 0)
        XCTAssertEqual(mockCombinationSolver.recorder.getCallCountFor("findClosestPoints (C)"), 1)
        XCTAssertEqual(mockPlaneSweepSolver.recorder.getCallCountFor("findClosestPoints (PS)"), 0)
        XCTAssertEqual(mockDivideAndConquerSolver.recorder.getCallCountFor("findClosestPoints (DQ)"), 0)

        let record = mockCombinationSolver.recorder.getCallRecordFor("findClosestPoints (C)")

        XCTAssertEqual(3, record?.count)
        let points = record?[0] as? [Point]
        let monitorClosure = record?[1] as? ((NSRect?, (Point, Point)?, (Point, Point)?) -> Bool)
        let completionClosure = record?[2] as? (((Point, Point)?) -> Void)

        XCTAssertNotNil(points)
        XCTAssertEqual(points!, subject.pointCollection.points)

        let pointPair1 = (subject.pointCollection.points[0], subject.pointCollection.points[1])
        let pointPair2 = (subject.pointCollection.points[0], subject.pointCollection.points[1])
        let dummyRect = NSRect(x: 0, y: 0, width: 1, height: 1)
        let keepGoing = monitorClosure?(dummyRect, pointPair1, pointPair2)
        XCTAssertTrue(keepGoing!)
        XCTAssertNil(subject.pointCollection.checkPoints)
        XCTAssertNil(subject.pointCollection.closestPoints)

        completionClosure?(pointPair2)
        XCTAssertNil(subject.pointCollection.checkPoints)
        XCTAssertNotNil(subject.pointCollection.closestPoints)

        XCTAssertNotEqual(subject.startSolutionTime, 0.0)
        XCTAssertNotEqual(subject.endSolutionTime, 0.0)
        XCTAssertNotEqual(subject.lastSolutionTime_ms, 0.0)
    }

    func test_findClosestPoints_FindsSolutionUsingPlaneSweepWithClosures() {
        let mockPermutationSolver = MockPermutationSolver()
        let mockCombinationSolver = MockCombinationSolver()
        let mockPlaneSweepSolver = MockPlaneSweepSolver()
        let mockDivideAndConquerSolver = MockDivideAndConquerSolver()

        subject.solutionEngine.permutationSolver = mockPermutationSolver
        subject.solutionEngine.combinationSolver = mockCombinationSolver
        subject.solutionEngine.planeSweepSolver = mockPlaneSweepSolver
        subject.solutionEngine.divideAndConquerSolver = mockDivideAndConquerSolver

        subject.controlManager.solutionType = ControlManager.SolutionType.PlaneSweep
        subject.controlManager.solverOption = ControlManager.SolverOption.OneShot

        subject.pointCollection.points = [Point(x: 1, y: 2), Point(x: 3, y: 4)]

        subject.lastSolutionTime_ms = 0.0
        subject.startSolutionTime = 0.0
        subject.endSolutionTime = 0.0

        mockPlaneSweepSolver.completionExpectation = expectation(description: "completion")

        subject.findClosestPoints()

        waitForExpectations(timeout: 1.0, handler: nil)

        XCTAssertEqual(mockPermutationSolver.recorder.getCallCountFor("findClosestPoints (P)"), 0)
        XCTAssertEqual(mockCombinationSolver.recorder.getCallCountFor("findClosestPoints (C)"), 0)
        XCTAssertEqual(mockPlaneSweepSolver.recorder.getCallCountFor("findClosestPoints (PS)"), 1)
        XCTAssertEqual(mockDivideAndConquerSolver.recorder.getCallCountFor("findClosestPoints (DQ)"), 0)

        let record = mockPlaneSweepSolver.recorder.getCallRecordFor("findClosestPoints (PS)")

        XCTAssertEqual(3, record?.count)
        let points = record?[0] as? [Point]
        let monitorClosure = record?[1] as? ((NSRect?, (Point, Point)?, (Point, Point)?) -> Bool)
        let completionClosure = record?[2] as? (((Point, Point)?) -> Void)

        XCTAssertNotNil(points)
        XCTAssertEqual(points!, subject.pointCollection.points)

        let pointPair1 = (subject.pointCollection.points[0], subject.pointCollection.points[1])
        let pointPair2 = (subject.pointCollection.points[0], subject.pointCollection.points[1])
        let dummyRect = NSRect(x: 0, y: 0, width: 1, height: 1)
        let keepGoing = monitorClosure?(dummyRect, pointPair1, pointPair2)
        XCTAssertTrue(keepGoing!)
        XCTAssertNil(subject.pointCollection.checkPoints)
        XCTAssertNil(subject.pointCollection.closestPoints)

        completionClosure?(pointPair2)
        XCTAssertNil(subject.pointCollection.checkPoints)
        XCTAssertNotNil(subject.pointCollection.closestPoints)

        XCTAssertNotEqual(subject.startSolutionTime, 0.0)
        XCTAssertNotEqual(subject.endSolutionTime, 0.0)
        XCTAssertNotEqual(subject.lastSolutionTime_ms, 0.0)
    }

    func test_findClosestPoints_FindsSolutionUsingDivideAndConquerWithClosuresWithThreePointSimpleRegion() {
        let mockPermutationSolver = MockPermutationSolver()
        let mockCombinationSolver = MockCombinationSolver()
        let mockPlaneSweepSolver = MockPlaneSweepSolver()
        let mockDivideAndConquerSolver = MockDivideAndConquerSolver()

        subject.solutionEngine.permutationSolver = mockPermutationSolver
        subject.solutionEngine.combinationSolver = mockCombinationSolver
        subject.solutionEngine.planeSweepSolver = mockPlaneSweepSolver
        subject.solutionEngine.divideAndConquerSolver = mockDivideAndConquerSolver

        subject.controlManager.solutionType = ControlManager.SolutionType.DivideAndConquer_3
        subject.controlManager.solverOption = ControlManager.SolverOption.OneShot

        subject.pointCollection.points = [Point(x: 1, y: 2), Point(x: 3, y: 4)]

        subject.lastSolutionTime_ms = 0.0
        subject.startSolutionTime = 0.0
        subject.endSolutionTime = 0.0

        mockDivideAndConquerSolver.maxSimpleRegionSize = 0

        mockDivideAndConquerSolver.completionExpectation = expectation(description: "completion")

        subject.findClosestPoints()

        waitForExpectations(timeout: 1.0, handler: nil)

        XCTAssertEqual(mockDivideAndConquerSolver.maxSimpleRegionSize, 3)
        
        XCTAssertEqual(mockPermutationSolver.recorder.getCallCountFor("findClosestPoints (P)"), 0)
        XCTAssertEqual(mockCombinationSolver.recorder.getCallCountFor("findClosestPoints (C)"), 0)
        XCTAssertEqual(mockPlaneSweepSolver.recorder.getCallCountFor("findClosestPoints (PS)"), 0)
        XCTAssertEqual(mockDivideAndConquerSolver.recorder.getCallCountFor("findClosestPoints (DQ)"), 1)

        let record = mockDivideAndConquerSolver.recorder.getCallRecordFor("findClosestPoints (DQ)")

        XCTAssertEqual(3, record?.count)
        let points = record?[0] as? [Point]
        let monitorClosure = record?[1] as? ((NSRect?, (Point, Point)?, (Point, Point)?) -> Bool)
        let completionClosure = record?[2] as? (((Point, Point)?) -> Void)

        XCTAssertNotNil(points)
        XCTAssertEqual(points!, subject.pointCollection.points)

        let pointPair1 = (subject.pointCollection.points[0], subject.pointCollection.points[1])
        let pointPair2 = (subject.pointCollection.points[0], subject.pointCollection.points[1])
        let dummyRect = NSRect(x: 0, y: 0, width: 1, height: 1)
        let keepGoing = monitorClosure?(dummyRect, pointPair1, pointPair2)
        XCTAssertTrue(keepGoing!)
        XCTAssertNil(subject.pointCollection.checkPoints)
        XCTAssertNil(subject.pointCollection.closestPoints)

        completionClosure?(pointPair2)
        XCTAssertNil(subject.pointCollection.checkPoints)
        XCTAssertNotNil(subject.pointCollection.closestPoints)

        XCTAssertNotEqual(subject.startSolutionTime, 0.0)
        XCTAssertNotEqual(subject.endSolutionTime, 0.0)
        XCTAssertNotEqual(subject.lastSolutionTime_ms, 0.0)
    }

    func test_findClosestPoints_FindsSolutionUsingDivideAndConquerWithClosuresWithFivePointSimpleRegion() {
        let mockPermutationSolver = MockPermutationSolver()
        let mockCombinationSolver = MockCombinationSolver()
        let mockPlaneSweepSolver = MockPlaneSweepSolver()
        let mockDivideAndConquerSolver = MockDivideAndConquerSolver()

        subject.solutionEngine.permutationSolver = mockPermutationSolver
        subject.solutionEngine.combinationSolver = mockCombinationSolver
        subject.solutionEngine.planeSweepSolver = mockPlaneSweepSolver
        subject.solutionEngine.divideAndConquerSolver = mockDivideAndConquerSolver

        subject.controlManager.solutionType = ControlManager.SolutionType.DivideAndConquer_5
        subject.controlManager.solverOption = ControlManager.SolverOption.OneShot

        subject.pointCollection.points = [Point(x: 1, y: 2), Point(x: 3, y: 4)]

        mockDivideAndConquerSolver.maxSimpleRegionSize = 0

        mockDivideAndConquerSolver.completionExpectation = expectation(description: "completion")

        subject.findClosestPoints()

        waitForExpectations(timeout: 1.0, handler: nil)

        XCTAssertEqual(mockDivideAndConquerSolver.maxSimpleRegionSize, 5)
    }

    func test_findClosestPoints_FindsSolutionUsingDivideAndConquerWithClosuresWithSevenPointSimpleRegion() {
        let mockPermutationSolver = MockPermutationSolver()
        let mockCombinationSolver = MockCombinationSolver()
        let mockPlaneSweepSolver = MockPlaneSweepSolver()
        let mockDivideAndConquerSolver = MockDivideAndConquerSolver()

        subject.solutionEngine.permutationSolver = mockPermutationSolver
        subject.solutionEngine.combinationSolver = mockCombinationSolver
        subject.solutionEngine.planeSweepSolver = mockPlaneSweepSolver
        subject.solutionEngine.divideAndConquerSolver = mockDivideAndConquerSolver

        subject.controlManager.solutionType = ControlManager.SolutionType.DivideAndConquer_7
        subject.controlManager.solverOption = ControlManager.SolverOption.OneShot

        subject.pointCollection.points = [Point(x: 1, y: 2), Point(x: 3, y: 4)]

        mockDivideAndConquerSolver.maxSimpleRegionSize = 0

        mockDivideAndConquerSolver.completionExpectation = expectation(description: "completion")

        subject.findClosestPoints()

        waitForExpectations(timeout: 1.0, handler: nil)

        XCTAssertEqual(mockDivideAndConquerSolver.maxSimpleRegionSize, 7)
    }

    // MARK: - isFindingClosestPoints()

    func test_isFindingClosestPoints_IndicatesWhenSolutionIsInProgress() {
        subject.solutionEngine.solving = true

        let result = subject.isFindingClosestPoints()

        XCTAssertTrue(result)
    }

    func test_isFindingClosestPoints_IndicatesWhenSolutionIsInNotProgress() {
        subject.solutionEngine.solving = false

        let result = subject.isFindingClosestPoints()

        XCTAssertFalse(result)
    }

    // MARK: - requestLiveSolutionIfConfigured()

    func test_requestLiveSolutionIfConfigured_FindsClosestPointsForLiveOption() {
        let mockPermutationSolver = MockPermutationSolver()
        let mockCombinationSolver = MockCombinationSolver()

        subject.solutionEngine.permutationSolver = mockPermutationSolver
        subject.solutionEngine.combinationSolver = mockCombinationSolver

        subject.controlManager.solutionType = ControlManager.SolutionType.PermutationSearch
        subject.controlManager.solverOption = ControlManager.SolverOption.Live

        subject.pointCollection.points = [Point(x: 1, y: 2), Point(x: 3, y: 4)]

        mockPermutationSolver.completionExpectation = expectation(description: "completion")

        subject.requestLiveSolutionIfConfigured()

        waitForExpectations(timeout: 1.0, handler: nil)

        XCTAssertEqual(mockPermutationSolver.recorder.getCallCountFor("findClosestPoints (P)"), 1)
    }

    func test_requestLiveSolutionIfConfigured_DoesNotFindClosestPointsForNonLiveOption() {
        let mockPermutationSolver = MockPermutationSolver()
        let mockCombinationSolver = MockCombinationSolver()

        subject.solutionEngine.permutationSolver = mockPermutationSolver
        subject.solutionEngine.combinationSolver = mockCombinationSolver

        subject.controlManager.solutionType = ControlManager.SolutionType.PermutationSearch
        subject.controlManager.solverOption = ControlManager.SolverOption.OneShot

        subject.pointCollection.points = [Point(x: 1, y: 2), Point(x: 3, y: 4)]

        subject.requestLiveSolutionIfConfigured()

        XCTAssertEqual(mockPermutationSolver.recorder.getCallCountFor("findClosestPoints (P)"), 0)
    }

    // MARK: - updatePointDataSource()

    func test_updatePointDataSource_ClearsAnyCheckPointsAndClosestPointsAndSearchRect() {
        subject.controlManager.solutionType = ControlManager.SolutionType.PermutationSearch
        subject.controlManager.solverOption = ControlManager.SolverOption.OneShot

        let points = [Point(x: 1, y: 2), Point(x: 3, y: 4)]
        subject.pointCollection.points = points
        subject.pointCollection.checkPoints = (points[0], points[1])
        subject.pointCollection.closestPoints = (points[0], points[1])

        subject.updatePointDataSource()

        XCTAssertNil(subject.pointCollection.checkPoints)
        XCTAssertNil(subject.pointCollection.closestPoints)
        XCTAssertNil(subject.pointCollection.searchRect)
    }

    // MARK: - Mocks
    
    class MockViewController: ViewController {
        
        let player = FuncPlayer()
        var playerEnabled = true

        let recorder = FuncRecorder()
        var recorderEnabled = true

        var my_PlotView: PlotView!

        var my_NumberOfPointsBox: NSComboBox!
        var my_PointDistributionPopUp: NSPopUpButton!
        var my_GenerateButton: NSButton!

        var my_SolutionTypePopUp: NSPopUpButton!
        var my_SolverOptionPopUp: NSPopUpButton!
        var my_ControlButton: NSButton!
        var my_SolutionTimeLabel: NSTextField!

        func createMockOutlets() {
            my_PlotView = PlotView(frame: NSRect(x: 0, y: 0, width: 100, height: 100))
            my_NumberOfPointsBox = NSComboBox()
            my_PointDistributionPopUp = NSPopUpButton()
            my_GenerateButton = NSButton()
            my_SolutionTypePopUp = NSPopUpButton()
            my_SolverOptionPopUp = NSPopUpButton()
            my_ControlButton = NSButton()
            my_SolutionTimeLabel = NSTextField()

            o_PlotView = my_PlotView

            o_NumberOfPointsBox = my_NumberOfPointsBox
            o_PointDistributionPopUp = my_PointDistributionPopUp
            o_GenerateButton = my_GenerateButton
            o_SolutionTypePopUp = my_SolutionTypePopUp
            o_SolverOptionPopUp = my_SolverOptionPopUp
            o_ControlButton = my_ControlButton
            o_SolutionTimeLabel = my_SolutionTimeLabel
        }

        override func setGenerateButtonEnableState(enabled: Bool) {
            if recorderEnabled {
                recorder.recordCallFor("setGenerateButtonEnableState", params: [enabled])
            }
            super.setGenerateButtonEnableState(enabled: enabled)
        }

        override func setControlButtonEnableState(enabled: Bool) {
            if recorderEnabled {
                recorder.recordCallFor("setControlButtonEnableState", params: [enabled])
            }
            super.setControlButtonEnableState(enabled: enabled)
        }

        override func setControlButtonTitle(title: String) {
            if recorderEnabled {
                recorder.recordCallFor("setControlButtonTitle", params: [title])
            }
            super.setControlButtonTitle(title: title)
        }

        override func requestPlotViewRedraw() {
            if recorderEnabled {
                recorder.recordCallFor("requestPlotViewRedraw", params: [])
            }
            super.requestPlotViewRedraw()
        }

        override func setNumberOfPoints(numberOfPoints: Int) {
            if recorderEnabled {
                recorder.recordCallFor("setNumberOfPoints", params: [numberOfPoints])
            }
            super.setNumberOfPoints(numberOfPoints: numberOfPoints)
        }

        override func updateSolutionTime(time_ms: Float) {
            if recorderEnabled {
                recorder.recordCallFor("updateSolutionTime", params: [time_ms])
            }
            super.updateSolutionTime(time_ms: time_ms)
        }

        override func getNumberOfPoints() -> Int {
            var numberOfPoints = 0
            if playerEnabled {
                let result: (value: Any?, success: Bool) = player.getReturnValueFor("getNumberOfPoints")
                if result.success, let vcNumberOfPoints = result.value as? Int {
                    numberOfPoints = vcNumberOfPoints
                }
            }
            return numberOfPoints
        }

    }

    class MockPointCollection: PointCollection {

        let recorder = FuncRecorder()
        var recorderEnabled = true

        override func generateUniformRandomPoints(numberOfPoints: Int, maxX: CGFloat, maxY: CGFloat, margin: CGFloat) {
            if recorderEnabled {
                recorder.recordCallFor("generateUniformRandomPoints", params: [numberOfPoints, maxX, maxY, margin])
            }
            super.generateUniformRandomPoints(numberOfPoints: numberOfPoints, maxX: maxX, maxY: maxY, margin: margin)
        }

        override func generateClusteredRandomPoints(numberOfPoints: Int, maxX: CGFloat, maxY: CGFloat, margin: CGFloat) {
            if recorderEnabled {
                recorder.recordCallFor("generateClusteredRandomPoints", params: [numberOfPoints, maxX, maxY, margin])
            }
            super.generateClusteredRandomPoints(numberOfPoints: numberOfPoints, maxX: maxX, maxY: maxY, margin: margin)
        }

    }

    class MockPermutationSolver: PermutationSolver {

        let recorder = FuncRecorder()

        var completionExpectation: XCTestExpectation?

        override func findClosestPoints(points: [Point],
                                        monitor: ((NSRect?, (Point, Point)?, (Point, Point)?) -> Bool)?,
                                        completion: (((Point, Point)?) -> Void)?) {
            recorder.recordCallFor("findClosestPoints (P)", params: [points, monitor, completion])
            completionExpectation?.fulfill()
        }

    }

    class MockCombinationSolver: CombinationSolver {

        let recorder = FuncRecorder()

        var completionExpectation: XCTestExpectation?

        override func findClosestPoints(points: [Point],
                                        monitor: ((NSRect?, (Point, Point)?, (Point, Point)?) -> Bool)?,
                                        completion: (((Point, Point)?) -> Void)?) {
            recorder.recordCallFor("findClosestPoints (C)", params: [points, monitor, completion])
            completionExpectation?.fulfill()
        }
        
    }

    class MockPlaneSweepSolver: PlaneSweepSolver {

        let recorder = FuncRecorder()

        var completionExpectation: XCTestExpectation?

        override func findClosestPoints(points: [Point],
                                        monitor: ((NSRect?, (Point, Point)?, (Point, Point)?) -> Bool)?,
                                        completion: (((Point, Point)?) -> Void)?) {
            recorder.recordCallFor("findClosestPoints (PS)", params: [points, monitor, completion])
            completionExpectation?.fulfill()
        }
        
    }

    class MockDivideAndConquerSolver: DivideAndConquerSolver {

        let recorder = FuncRecorder()

        var completionExpectation: XCTestExpectation?

        override func findClosestPoints(points: [Point],
                                        monitor: ((NSRect?, (Point, Point)?, (Point, Point)?) -> Bool)?,
                                        completion: (((Point, Point)?) -> Void)?) {
            recorder.recordCallFor("findClosestPoints (DQ)", params: [points, monitor, completion])
            completionExpectation?.fulfill()
        }
        
    }

}

# Makefile for running tests from command line

WORKSPACE = ClosestPointsWorkshop.xcworkspace
DESTINATION = platform=macOS,arch=x86_64

default:
	@echo
	@echo "Targets:"
	@echo "  test-all-unit"
	@echo "  test-app"
	@echo "  test-app-unit"
	@echo "  test-app-ui"
	@echo "  test-pdltestbench"
	@echo "  test-pdltoolbox"
	@echo

test-all-unit:
	xcodebuild test \
	-workspace $(WORKSPACE) \
	-scheme 'All Tests' \
	-destination $(DESTINATION)

test-app:
	xcodebuild test \
	-workspace $(WORKSPACE) \
	-scheme ClosestPoints \
	-destination $(DESTINATION)

test-app-unit:
	xcodebuild test \
	-workspace $(WORKSPACE) \
	-scheme ClosestPoints \
	-destination $(DESTINATION) \
	-only-testing ClosestPointsTests

test-app-ui:
	xcodebuild test \
	-workspace $(WORKSPACE) \
	-scheme ClosestPoints \
	-destination $(DESTINATION) \
	-only-testing ClosestPointsUITests

test-pdltestbench:
	xcodebuild test \
	-workspace $(WORKSPACE) \
	-scheme PDLTestBench \
	-destination $(DESTINATION)

test-pdltoolbox:
	xcodebuild test \
	-workspace $(WORKSPACE) \
	-scheme PDLToolBox \
	-destination $(DESTINATION)

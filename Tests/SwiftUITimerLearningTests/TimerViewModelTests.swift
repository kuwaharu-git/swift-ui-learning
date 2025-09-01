import XCTest
@testable import SwiftUITimerLearning

/// Tests for the TimerViewModel to demonstrate testing SwiftUI view models
final class TimerViewModelTests: XCTestCase {
    
    var viewModel: TimerViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = TimerViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testInitialState() {
        // Test that the view model starts in the correct state
        XCTAssertEqual(viewModel.timeElapsed, 0)
        XCTAssertFalse(viewModel.isRunning)
        XCTAssertEqual(viewModel.formattedTime, "00:00")
    }
    
    func testFormattedTime() {
        // Test time formatting for various values
        viewModel.timeElapsed = 0
        XCTAssertEqual(viewModel.formattedTime, "00:00")
        
        viewModel.timeElapsed = 30
        XCTAssertEqual(viewModel.formattedTime, "00:30")
        
        viewModel.timeElapsed = 60
        XCTAssertEqual(viewModel.formattedTime, "01:00")
        
        viewModel.timeElapsed = 125
        XCTAssertEqual(viewModel.formattedTime, "02:05")
    }
    
    func testStartTimer() {
        // Test starting the timer
        viewModel.startTimer()
        XCTAssertTrue(viewModel.isRunning)
        
        // Test that starting an already running timer doesn't change state
        viewModel.startTimer()
        XCTAssertTrue(viewModel.isRunning)
    }
    
    func testStopTimer() {
        // Start timer first
        viewModel.startTimer()
        XCTAssertTrue(viewModel.isRunning)
        
        // Stop the timer
        viewModel.stopTimer()
        XCTAssertFalse(viewModel.isRunning)
    }
    
    func testResetTimer() {
        // Set some elapsed time and start timer
        viewModel.timeElapsed = 100
        viewModel.startTimer()
        
        // Reset should stop timer and reset time
        viewModel.resetTimer()
        XCTAssertFalse(viewModel.isRunning)
        XCTAssertEqual(viewModel.timeElapsed, 0)
    }
}
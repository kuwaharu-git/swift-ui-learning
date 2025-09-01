import SwiftUI
import Combine

/// A SwiftUI view that demonstrates timer functionality
/// This view showcases:
/// - Timer creation and management
/// - State management with @State
/// - UI updates based on timer events
/// - Start, Stop, and Reset functionality
struct TimerView: View {
    // MARK: - State Properties
    
    /// The current time displayed on the timer (in seconds)
    @State private var timeElapsed: Int = 0
    
    /// Whether the timer is currently running
    @State private var isRunning: Bool = false
    
    /// The timer publisher that emits every second
    @State private var timer: AnyCancellable?
    
    // MARK: - Computed Properties
    
    /// Formatted time string in MM:SS format
    private var formattedTime: String {
        let minutes = timeElapsed / 60
        let seconds = timeElapsed % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 30) {
            // Title
            Text("SwiftUI Timer")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            // Timer Display
            Text(formattedTime)
                .font(.system(size: 60, weight: .bold, design: .monospaced))
                .foregroundColor(isRunning ? .green : .primary)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.gray.opacity(0.1))
                        .stroke(isRunning ? Color.green : Color.gray, lineWidth: 2)
                )
            
            // Control Buttons
            HStack(spacing: 20) {
                // Start/Stop Button
                Button(action: toggleTimer) {
                    HStack {
                        Image(systemName: isRunning ? "pause.fill" : "play.fill")
                        Text(isRunning ? "Stop" : "Start")
                    }
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 25)
                    .padding(.vertical, 15)
                    .background(isRunning ? Color.red : Color.blue)
                    .cornerRadius(25)
                }
                
                // Reset Button
                Button(action: resetTimer) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("Reset")
                    }
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 25)
                    .padding(.vertical, 15)
                    .background(Color.orange)
                    .cornerRadius(25)
                }
            }
            
            // Timer Status
            Text(isRunning ? "Timer is running..." : "Timer is stopped")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.top, 10)
            
            Spacer()
        }
        .padding()
        .onDisappear {
            // Clean up the timer when the view disappears
            stopTimer()
        }
    }
    
    // MARK: - Methods
    
    /// Toggles the timer between running and stopped states
    private func toggleTimer() {
        if isRunning {
            stopTimer()
        } else {
            startTimer()
        }
    }
    
    /// Starts the timer
    private func startTimer() {
        isRunning = true
        
        // Create a timer that fires every second
        timer = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                timeElapsed += 1
            }
    }
    
    /// Stops the timer
    private func stopTimer() {
        isRunning = false
        timer?.cancel()
        timer = nil
    }
    
    /// Resets the timer to zero and stops it
    private func resetTimer() {
        stopTimer()
        timeElapsed = 0
    }
}

// MARK: - Preview

/// Preview for SwiftUI Canvas
struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
            .preferredColorScheme(.light)
            .previewDisplayName("Light Mode")
        
        TimerView()
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
    }
}

// MARK: - Alternative Timer Implementation

/// Alternative timer implementation using @Published and ObservableObject
/// This demonstrates a different approach to state management
class TimerViewModel: ObservableObject {
    @Published var timeElapsed: Int = 0
    @Published var isRunning: Bool = false
    
    private var timer: AnyCancellable?
    
    func startTimer() {
        guard !isRunning else { return }
        isRunning = true
        
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.timeElapsed += 1
            }
    }
    
    func stopTimer() {
        isRunning = false
        timer?.cancel()
        timer = nil
    }
    
    func resetTimer() {
        stopTimer()
        timeElapsed = 0
    }
    
    var formattedTime: String {
        let minutes = timeElapsed / 60
        let seconds = timeElapsed % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    deinit {
        timer?.cancel()
    }
}

/// Alternative timer view using ObservableObject pattern
struct AlternativeTimerView: View {
    @StateObject private var viewModel = TimerViewModel()
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Timer with ViewModel")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(viewModel.formattedTime)
                .font(.system(size: 60, weight: .bold, design: .monospaced))
                .foregroundColor(viewModel.isRunning ? .green : .primary)
            
            HStack {
                Button(viewModel.isRunning ? "Stop" : "Start") {
                    if viewModel.isRunning {
                        viewModel.stopTimer()
                    } else {
                        viewModel.startTimer()
                    }
                }
                .padding()
                .background(viewModel.isRunning ? Color.red : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Button("Reset") {
                    viewModel.resetTimer()
                }
                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
    }
}
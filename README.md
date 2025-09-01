# SwiftUI Timer Learning Project

A comprehensive SwiftUI learning project that demonstrates how to implement timers using different architectural patterns.

## 📚 What You'll Learn

This project showcases two different approaches to implementing timers in SwiftUI:

### 1. Basic Timer Implementation (`TimerView`)
- Uses `@State` for local state management
- Demonstrates `Timer.publish()` with Combine
- Shows direct timer control within the view
- Perfect for simple, self-contained timer logic

### 2. ViewModel-Based Timer (`AlternativeTimerView`)
- Uses `@StateObject` with `ObservableObject`
- Separates timer logic from UI code
- Better for complex state management scenarios
- Easier to test and reuse across different views

## 🎯 Key SwiftUI Concepts Demonstrated

- **Property Wrappers**: `@State`, `@StateObject`, `@Published`
- **Combine Framework**: `Timer.publish()`, `AnyCancellable`
- **Memory Management**: Proper timer cleanup and cancellation
- **View Lifecycle**: Using `onDisappear` for cleanup
- **Conditional UI**: Dynamic styling based on state
- **Custom Formatting**: Time display formatting
- **Preview Providers**: SwiftUI Canvas previews for both light/dark modes

## 🚀 Getting Started

### Prerequisites
- Xcode 14.0 or later
- iOS 15.0+ or macOS 12.0+
- Swift 5.7+

### Running the Project

1. **As a Swift Package**:
   ```bash
   swift build
   ```

2. **In Xcode**:
   - Open the project in Xcode
   - Select your target device/simulator
   - Press ⌘+R to run

### File Structure
```
swift-ui-learning/
├── timer_view.swift          # Main timer implementations
├── TimerLearningApp.swift    # App entry point with TabView
├── Package.swift             # Swift Package Manager configuration
└── README.md                # This documentation
```

## 🔧 Features

### Timer Functionality
- ⏱️ Start/Stop timer controls
- 🔄 Reset functionality
- 📱 Real-time display updates
- 🎨 Visual feedback (color changes when running)
- 🕐 MM:SS time format display

### UI Features
- 📱 Tab-based navigation
- 🌓 Dark/Light mode support
- 📊 Information view with learning tips
- 🎯 Clean, educational code structure

## 📖 Code Examples

### Basic Timer Usage
```swift
struct TimerView: View {
    @State private var timeElapsed: Int = 0
    @State private var isRunning: Bool = false
    @State private var timer: AnyCancellable?
    
    // Timer implementation...
}
```

### ViewModel Pattern
```swift
class TimerViewModel: ObservableObject {
    @Published var timeElapsed: Int = 0
    @Published var isRunning: Bool = false
    
    // Timer logic separated from UI...
}
```

## 🎓 Learning Exercises

Try these modifications to deepen your understanding:

1. **Customize the Timer**:
   - Change the timer interval (every 0.1 seconds for milliseconds)
   - Add hours to the display format
   - Implement lap time functionality

2. **Enhance the UI**:
   - Add animations for state changes
   - Create custom button styles
   - Implement a circular progress indicator

3. **Add Features**:
   - Sound notifications when timer reaches certain milestones
   - Save timer sessions to UserDefaults
   - Add multiple simultaneous timers

4. **Architecture Exploration**:
   - Compare the two implementation patterns
   - Try implementing with different state management approaches
   - Add unit tests for the ViewModel

## 🐛 Common Issues & Solutions

### Timer Not Updating
- Ensure timer is running on the main thread
- Check that `AnyCancellable` is properly stored
- Verify timer cleanup in `onDisappear`

### Memory Leaks
- Always cancel timers when done
- Use `weak self` in closures when needed
- Implement proper cleanup in `deinit`

## 🤝 Contributing

This is a learning project! Feel free to:
- Add new timer implementations
- Improve documentation
- Add more SwiftUI concepts
- Create additional examples

## 📝 License

This project is open source and available under the MIT License.

## 🔗 Additional Resources

- [Apple's SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [Combine Framework Guide](https://developer.apple.com/documentation/combine)
- [SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)

---

Happy learning! 🎉

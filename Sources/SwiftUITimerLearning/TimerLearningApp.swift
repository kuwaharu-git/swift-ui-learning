import SwiftUI

/// Main app entry point for the SwiftUI Timer Learning project
/// This demonstrates how to create a simple SwiftUI app with a timer view
@main
struct TimerLearningApp: App {
    var body: some Scene {
        WindowGroup {
            // Main content view with tab navigation
            TabView {
                // Basic Timer View
                NavigationView {
                    TimerView()
                        .navigationTitle("Timer")
                }
                .tabItem {
                    Image(systemName: "timer")
                    Text("Timer")
                }
                
                // Alternative Timer View with ViewModel
                NavigationView {
                    AlternativeTimerView()
                        .navigationTitle("ViewModel Timer")
                }
                .tabItem {
                    Image(systemName: "clock")
                    Text("Alt Timer")
                }
                
                // Information View
                NavigationView {
                    TimerInfoView()
                        .navigationTitle("Info")
                }
                .tabItem {
                    Image(systemName: "info.circle")
                    Text("Info")
                }
            }
        }
    }
}

/// Information view explaining the timer implementations
struct TimerInfoView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Group {
                    Text("SwiftUI Timer Learning")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("This app demonstrates two different approaches to implementing timers in SwiftUI:")
                        .font(.body)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("1. Basic Timer View")
                            .font(.headline)
                        Text("• Uses @State for local state management")
                        Text("• Timer.publish() with Combine")
                        Text("• Direct timer control within the view")
                        Text("• Good for simple, self-contained timer logic")
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("2. ViewModel Timer")
                            .font(.headline)
                        Text("• Uses @StateObject with ObservableObject")
                        Text("• Separates timer logic from UI")
                        Text("• Better for complex state management")
                        Text("• Easier to test and reuse")
                    }
                }
                
                Group {
                    Text("Key SwiftUI Concepts Demonstrated:")
                        .font(.headline)
                        .padding(.top)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("• @State and @StateObject property wrappers")
                        Text("• Timer.publish() with Combine framework")
                        Text("• AnyCancellable for memory management")
                        Text("• View lifecycle methods (onDisappear)")
                        Text("• Conditional UI updates based on state")
                        Text("• Custom formatting and computed properties")
                        Text("• Button actions and state mutations")
                        Text("• Preview providers for SwiftUI Canvas")
                    }
                }
                
                Group {
                    Text("Learning Tips:")
                        .font(.headline)
                        .padding(.top)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("• Study both implementations to understand different patterns")
                        Text("• Notice how state changes trigger UI updates")
                        Text("• Observe memory management with timer cancellation")
                        Text("• Experiment with different timer intervals")
                        Text("• Try modifying the UI layout and styling")
                    }
                }
            }
            .padding()
        }
    }
}
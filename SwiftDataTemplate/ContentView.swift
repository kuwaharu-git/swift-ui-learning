import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        NavigationStack {
            BookView()
            .toolbar {
                NavigationLink(destination: AddBookView()) {
                    Label("本を追加", systemImage: "plus")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

import SwiftUI
import SwiftData

struct AddBookView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var title: String = ""
    @State private var author: String = ""
    @State private var showAlert = false

    var body: some View {
        Form {
            TextField("タイトル", text: $title)
            TextField("著者", text: $author)
            Button("追加") {
                let newBook = Book(title: title, author: author)
                modelContext.insert(newBook)
                showAlert = true
                title = ""
                author = ""
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("追加完了"), message: Text("本が追加されました"), dismissButton: .default(Text("OK")))
        }
        .navigationTitle("本を追加")
    }
}

#Preview {
    AddBookView()
}

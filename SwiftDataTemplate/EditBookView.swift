import SwiftUI
import SwiftData

struct EditBookView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var book: Book
    @State private var showAlert = false

    var body: some View {
        Form {
            TextField("タイトル", text: $book.title)
            TextField("著者", text: $book.author)
            Button("保存") {
                modelContext.save()
                showAlert = true
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("保存完了"), message: Text("本の情報が更新されました"), dismissButton: .default(Text("OK")))
        }
        .navigationTitle("本を編集")
    }
}

#Preview {
    EditBookView(book: Book(title: "サンプル", author: "著者"))
}

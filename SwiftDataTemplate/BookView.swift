import SwiftUI
import SwiftData

struct BookView: View {
    @Query var books: [Book]

    var body: some View {
        List(books) { book in
            VStack(alignment: .leading) {
                Text(book.title)
                    .font(.headline)
                Text(book.author)
                    .font(.subheadline)
            }
        }
        .navigationTitle("本一覧")
    }
}

#Preview {
    BookView()
}

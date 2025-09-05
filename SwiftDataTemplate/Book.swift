import Foundation
import SwiftData

@Model
class Book: Identifiable {
    var id: UUID
    var title: String
    var author: String

    init(title: String, author: String) {
        self.id = UUID()
        self.title = title
        self.author = author
    }
}

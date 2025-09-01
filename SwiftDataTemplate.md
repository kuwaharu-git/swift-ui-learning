# Swift Data データ保存テンプレート

このドキュメントは、Swift Dataを使用したデータ保存の基本的な方法をまとめたテンプレートです。SwiftUIアプリケーションでデータ永続化を実装する際の参考として使用してください。

## 目次
1. [Swift Data とは](#swift-data-とは)
2. [基本セットアップ](#基本セットアップ)
3. [モデル定義](#モデル定義)
4. [データコンテナの設定](#データコンテナの設定)
5. [CRUD操作](#crud操作)
6. [クエリとフィルタリング](#クエリとフィルタリング)
7. [リレーションシップ](#リレーションシップ)
8. [実践的な使用例](#実践的な使用例)
9. [ベストプラクティス](#ベストプラクティス)

## Swift Data とは

Swift Dataは、iOS 17以降で利用できるAppleの新しいデータ永続化フレームワークです。Core Dataの後継として、よりシンプルで直感的なAPIを提供し、SwiftUIとの統合も優れています。

### 主な特徴
- **シンプルなAPI**: Core Dataよりも簡潔で理解しやすい
- **Swift マクロベース**: `@Model`マクロを使用したモデル定義
- **SwiftUIとの統合**: `@Query`を使用した自動的なUI更新
- **型安全**: Swiftの型システムを活用した安全性

## 基本セットアップ

### 1. プロジェクト要件
- iOS 17.0以降
- Xcode 15以降
- SwiftUIアプリケーション

### 2. インポート
```swift
import SwiftData
import SwiftUI
```

## モデル定義

### 基本的なモデル
```swift
import SwiftData
import Foundation

@Model
final class Item {
    var name: String
    var createdAt: Date
    var isCompleted: Bool
    
    init(name: String) {
        self.name = name
        self.createdAt = Date()
        self.isCompleted = false
    }
}
```

### プロパティの属性

#### ユニークな値を指定
```swift
@Model
final class User {
    @Attribute(.unique) var email: String
    var name: String
    var age: Int
    
    init(email: String, name: String, age: Int) {
        self.email = email
        self.name = name
        self.age = age
    }
}
```

#### オプショナルプロパティ
```swift
@Model
final class Product {
    var name: String
    var description: String?
    var price: Double
    var category: String?
    
    init(name: String, price: Double) {
        self.name = name
        self.price = price
    }
}
```

## データコンテナの設定

### Appファイルでの設定
```swift
import SwiftUI
import SwiftData

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Item.self, User.self, Product.self])
    }
}
```

### カスタム設定
```swift
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Item.self]) { container in
            container.mainContext.autosaveEnabled = true
        }
    }
}
```

## CRUD操作

### Create（作成）
```swift
struct AddItemView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var itemName = ""
    
    var body: some View {
        VStack {
            TextField("アイテム名", text: $itemName)
            
            Button("追加") {
                let newItem = Item(name: itemName)
                modelContext.insert(newItem)
                
                do {
                    try modelContext.save()
                } catch {
                    print("保存エラー: \(error)")
                }
                
                itemName = ""
            }
        }
    }
}
```

### Read（読み取り）
```swift
struct ItemListView: View {
    @Query private var items: [Item]
    
    var body: some View {
        List(items) { item in
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                Text(item.createdAt, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}
```

### Update（更新）
```swift
struct EditItemView: View {
    @Environment(\.modelContext) private var modelContext
    let item: Item
    @State private var newName: String
    
    init(item: Item) {
        self.item = item
        self._newName = State(initialValue: item.name)
    }
    
    var body: some View {
        VStack {
            TextField("アイテム名", text: $newName)
            
            Button("更新") {
                item.name = newName
                
                do {
                    try modelContext.save()
                } catch {
                    print("更新エラー: \(error)")
                }
            }
        }
    }
}
```

### Delete（削除）
```swift
struct ItemListView: View {
    @Query private var items: [Item]
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        List {
            ForEach(items) { item in
                Text(item.name)
            }
            .onDelete(perform: deleteItems)
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(items[index])
        }
        
        do {
            try modelContext.save()
        } catch {
            print("削除エラー: \(error)")
        }
    }
}
```

## クエリとフィルタリング

### 基本的なクエリ
```swift
struct FilteredItemView: View {
    @Query(sort: \Item.createdAt, order: .reverse) 
    private var items: [Item]
    
    var body: some View {
        List(items) { item in
            Text(item.name)
        }
    }
}
```

### 条件付きクエリ
```swift
struct CompletedItemsView: View {
    @Query(filter: #Predicate<Item> { $0.isCompleted == true })
    private var completedItems: [Item]
    
    var body: some View {
        List(completedItems) { item in
            Text(item.name)
        }
    }
}
```

### 複雑なフィルタリング
```swift
struct ExpensiveProductsView: View {
    @Query(
        filter: #Predicate<Product> { product in
            product.price > 1000 && product.category == "Electronics"
        },
        sort: \Product.price,
        order: .reverse
    )
    private var expensiveProducts: [Product]
    
    var body: some View {
        List(expensiveProducts) { product in
            VStack(alignment: .leading) {
                Text(product.name)
                Text("¥\(product.price, specifier: "%.0f")")
            }
        }
    }
}
```

### 動的クエリ
```swift
struct SearchableItemView: View {
    @State private var searchText = ""
    
    var body: some View {
        ItemSearchList(searchText: searchText)
            .searchable(text: $searchText)
    }
}

struct ItemSearchList: View {
    let searchText: String
    
    @Query private var items: [Item]
    
    init(searchText: String) {
        self.searchText = searchText
        let predicate = #Predicate<Item> { item in
            searchText.isEmpty || item.name.localizedStandardContains(searchText)
        }
        _items = Query(filter: predicate, sort: \Item.name)
    }
    
    var body: some View {
        List(items) { item in
            Text(item.name)
        }
    }
}
```

## リレーションシップ

### One-to-Many リレーションシップ
```swift
@Model
final class Category {
    var name: String
    @Relationship(deleteRule: .cascade, inverse: \Item.category)
    var items: [Item] = []
    
    init(name: String) {
        self.name = name
    }
}

@Model
final class Item {
    var name: String
    var createdAt: Date
    var category: Category?
    
    init(name: String) {
        self.name = name
        self.createdAt = Date()
    }
}
```

### Many-to-Many リレーションシップ
```swift
@Model
final class Tag {
    var name: String
    var items: [Item] = []
    
    init(name: String) {
        self.name = name
    }
}

@Model
final class Item {
    var name: String
    var tags: [Tag] = []
    
    init(name: String) {
        self.name = name
    }
}
```

## 実践的な使用例

### TODOアプリの例
```swift
// TODOアイテムモデル
@Model
final class TodoItem {
    var title: String
    var notes: String
    var isCompleted: Bool
    var priority: Priority
    var dueDate: Date?
    var createdAt: Date
    
    init(title: String, priority: Priority = .medium) {
        self.title = title
        self.notes = ""
        self.isCompleted = false
        self.priority = priority
        self.createdAt = Date()
    }
}

enum Priority: String, CaseIterable, Codable {
    case low = "低"
    case medium = "中"
    case high = "高"
}

// メインビュー
struct TodoListView: View {
    @Query(sort: [
        SortDescriptor(\TodoItem.priority, order: .reverse),
        SortDescriptor(\TodoItem.createdAt, order: .reverse)
    ])
    private var todos: [TodoItem]
    
    @Environment(\.modelContext) private var modelContext
    @State private var showingAddTodo = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(todos) { todo in
                    TodoRowView(todo: todo)
                }
                .onDelete(perform: deleteTodos)
            }
            .navigationTitle("TODO")
            .toolbar {
                Button(action: { showingAddTodo = true }) {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddTodo) {
                AddTodoView()
            }
        }
    }
    
    private func deleteTodos(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(todos[index])
        }
        try? modelContext.save()
    }
}
```

### ユーザー設定の保存
```swift
@Model
final class UserSettings {
    var username: String
    var theme: String
    var notificationsEnabled: Bool
    var language: String
    
    init() {
        self.username = ""
        self.theme = "システム"
        self.notificationsEnabled = true
        self.language = "ja"
    }
}

struct SettingsView: View {
    @Query private var settings: [UserSettings]
    @Environment(\.modelContext) private var modelContext
    
    private var userSettings: UserSettings {
        if let existing = settings.first {
            return existing
        } else {
            let newSettings = UserSettings()
            modelContext.insert(newSettings)
            try? modelContext.save()
            return newSettings
        }
    }
    
    var body: some View {
        Form {
            Section("ユーザー情報") {
                TextField("ユーザー名", text: Binding(
                    get: { userSettings.username },
                    set: { newValue in
                        userSettings.username = newValue
                        try? modelContext.save()
                    }
                ))
            }
            
            Section("表示設定") {
                Picker("テーマ", selection: Binding(
                    get: { userSettings.theme },
                    set: { newValue in
                        userSettings.theme = newValue
                        try? modelContext.save()
                    }
                )) {
                    Text("ライト").tag("ライト")
                    Text("ダーク").tag("ダーク")
                    Text("システム").tag("システム")
                }
            }
        }
    }
}
```

## ベストプラクティス

### 1. エラーハンドリング
```swift
func saveContext() {
    do {
        try modelContext.save()
    } catch {
        // ログ出力
        print("保存エラー: \(error.localizedDescription)")
        
        // ユーザーへの通知
        // エラーアラートの表示など
    }
}
```

### 2. パフォーマンス最適化
```swift
// 大量データの処理時はバッチ操作を使用
func bulkInsert(items: [ItemData]) {
    for itemData in items {
        let item = Item(name: itemData.name)
        modelContext.insert(item)
    }
    
    // 一度に保存
    try? modelContext.save()
}
```

### 3. メモリ管理
```swift
// 不要になったオブジェクトの削除
@Query(limit: 1000) private var items: [Item]

// 古いデータの定期的なクリーンアップ
func cleanupOldData() {
    let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date())!
    let predicate = #Predicate<Item> { $0.createdAt < thirtyDaysAgo }
    
    let fetchDescriptor = FetchDescriptor(predicate: predicate)
    let oldItems = try? modelContext.fetch(fetchDescriptor)
    
    oldItems?.forEach { modelContext.delete($0) }
    try? modelContext.save()
}
```

### 4. データマイグレーション
```swift
// モデル変更時のマイグレーション対応
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Item.self]) { container in
            // マイグレーション設定
            container.mainContext.autosaveEnabled = true
        }
    }
}
```

## 活用シーン

### 適用例
- **メモアプリ**: テキストデータの保存と検索
- **タスク管理**: TODO項目の状態管理
- **設定保存**: アプリケーション設定の永続化
- **ローカルキャッシュ**: APIデータのオフライン保存
- **ユーザーデータ**: プロフィール情報の管理

### 使い分けの指針
- **Swift Data**: iOS 17以降、新規プロジェクト
- **Core Data**: レガシーサポート、複雑なデータモデル
- **UserDefaults**: 軽量な設定データ
- **Keychain**: 機密情報の保存

## まとめ

Swift Dataは現代的で使いやすいデータ永続化フレームワークです。このテンプレートを参考に、あなたのSwiftUIアプリケーションに最適なデータ保存機能を実装してください。

### 次のステップ
1. 実際のプロジェクトでモデル定義から始める
2. 基本的なCRUD操作を実装する  
3. 必要に応じてリレーションシップを追加する
4. パフォーマンスとエラーハンドリングを最適化する

---

**最終更新**: 2024年  
**対応バージョン**: iOS 17.0以降、Xcode 15以降
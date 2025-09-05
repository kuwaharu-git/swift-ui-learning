# SwiftUIでのリスト表示の方法

SwiftUIにおいて、リストを使って繰り返し要素を表示する方法をまとめました。

## 目次
1. [基本的なリストの作成](#基本的なリストの作成)
2. [静的リストの作成](#静的リストの作成)
3. [動的リストの作成](#動的リストの作成)
4. [カスタムリストアイテム](#カスタムリストアイテム)
5. [リストのスタイリング](#リストのスタイリング)
6. [実用的な例](#実用的な例)
7. [ベストプラクティス](#ベストプラクティス)

## 基本的なリストの作成

### シンプルな文字列リスト

```swift
import SwiftUI

struct ContentView: View {
    let fruits = ["りんご", "バナナ", "オレンジ", "ぶどう", "いちご"]
    
    var body: some View {
        List(fruits, id: \.self) { fruit in
            Text(fruit)
        }
    }
}
```

### ForEachを使用したリスト

```swift
struct ContentView: View {
    let fruits = ["りんご", "バナナ", "オレンジ", "ぶどう", "いちご"]
    
    var body: some View {
        List {
            ForEach(fruits, id: \.self) { fruit in
                Text(fruit)
            }
        }
    }
}
```

## 静的リストの作成

固定の要素を持つリストを作成する場合：

```swift
struct StaticListView: View {
    var body: some View {
        List {
            Text("ホーム")
            Text("設定")
            Text("プロフィール")
            Text("ヘルプ")
            Text("ログアウト")
        }
    }
}
```

### セクションを持つ静的リスト

```swift
struct SectionedListView: View {
    var body: some View {
        List {
            Section("メインメニュー") {
                Text("ホーム")
                Text("検索")
                Text("お気に入り")
            }
            
            Section("設定") {
                Text("アカウント")
                Text("プライバシー")
                Text("通知")
            }
        }
    }
}
```

## 動的リストの作成

### Identifiableプロトコルを使用

```swift
struct Person: Identifiable {
    let id = UUID()
    let name: String
    let age: Int
}

struct DynamicListView: View {
    let people = [
        Person(name: "田中太郎", age: 25),
        Person(name: "佐藤花子", age: 30),
        Person(name: "山田次郎", age: 28)
    ]
    
    var body: some View {
        List(people) { person in
            HStack {
                Text(person.name)
                Spacer()
                Text("\(person.age)歳")
                    .foregroundColor(.secondary)
            }
        }
    }
}
```

### インデックスを使用したリスト

```swift
struct IndexedListView: View {
    let items = ["アイテム1", "アイテム2", "アイテム3", "アイテム4"]
    
    var body: some View {
        List(Array(items.enumerated()), id: \.offset) { index, item in
            HStack {
                Text("\(index + 1)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(item)
            }
        }
    }
}
```

## カスタムリストアイテム

### 複雑なリストセル

```swift
struct Task: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let isCompleted: Bool
    let priority: Priority
    
    enum Priority {
        case low, medium, high
        
        var color: Color {
            switch self {
            case .low: return .green
            case .medium: return .orange
            case .high: return .red
            }
        }
    }
}

struct TaskRowView: View {
    let task: Task
    
    var body: some View {
        HStack {
            // 完了ステータス
            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(task.isCompleted ? .green : .gray)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.headline)
                    .strikethrough(task.isCompleted)
                
                Text(task.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // 優先度インジケーター
            Circle()
                .fill(task.priority.color)
                .frame(width: 10, height: 10)
        }
        .padding(.vertical, 2)
    }
}

struct TaskListView: View {
    let tasks = [
        Task(title: "買い物", description: "牛乳とパンを買う", isCompleted: false, priority: .high),
        Task(title: "会議準備", description: "資料の確認", isCompleted: true, priority: .medium),
        Task(title: "読書", description: "新しい本を読む", isCompleted: false, priority: .low)
    ]
    
    var body: some View {
        List(tasks) { task in
            TaskRowView(task: task)
        }
    }
}
```

## リストのスタイリング

### リストスタイルの変更

```swift
struct StyledListView: View {
    let items = ["アイテム1", "アイテム2", "アイテム3"]
    
    var body: some View {
        VStack {
            // デフォルトスタイル
            List(items, id: \.self) { item in
                Text(item)
            }
            .listStyle(.automatic)
            
            // プレーンスタイル
            List(items, id: \.self) { item in
                Text(item)
            }
            .listStyle(.plain)
            
            // インセットスタイル
            List(items, id: \.self) { item in
                Text(item)
            }
            .listStyle(.inset)
        }
    }
}
```

### 行の削除と移動

```swift
struct EditableListView: View {
    @State private var items = ["アイテム1", "アイテム2", "アイテム3", "アイテム4"]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items, id: \.self) { item in
                    Text(item)
                }
                .onDelete(perform: deleteItems)
                .onMove(perform: moveItems)
            }
            .navigationTitle("編集可能リスト")
            .toolbar {
                EditButton()
            }
        }
    }
    
    func deleteItems(offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
    
    func moveItems(from source: IndexSet, to destination: Int) {
        items.move(fromOffsets: source, toOffset: destination)
    }
}
```

## 実用的な例

### 検索機能付きリスト

```swift
struct SearchableListView: View {
    @State private var searchText = ""
    
    let allItems = [
        "りんご", "バナナ", "オレンジ", "ぶどう", "いちご",
        "みかん", "メロン", "スイカ", "パイナップル", "キウイ"
    ]
    
    var filteredItems: [String] {
        if searchText.isEmpty {
            return allItems
        } else {
            return allItems.filter { $0.contains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            List(filteredItems, id: \.self) { item in
                Text(item)
            }
            .searchable(text: $searchText, prompt: "果物を検索")
            .navigationTitle("果物リスト")
        }
    }
}
```

### 無限スクロールリスト

```swift
class ListViewModel: ObservableObject {
    @Published var items: [String] = []
    private var currentPage = 0
    private let itemsPerPage = 20
    
    init() {
        loadMoreItems()
    }
    
    func loadMoreItems() {
        let newItems = (1...itemsPerPage).map { "アイテム \(currentPage * itemsPerPage + $0)" }
        items.append(contentsOf: newItems)
        currentPage += 1
    }
}

struct InfiniteScrollListView: View {
    @StateObject private var viewModel = ListViewModel()
    
    var body: some View {
        List(viewModel.items, id: \.self) { item in
            Text(item)
                .onAppear {
                    if item == viewModel.items.last {
                        viewModel.loadMoreItems()
                    }
                }
        }
    }
}
```

## ベストプラクティス

### 1. 適切なIDの使用

```swift
// ✅ 良い例：一意のIDを持つ構造体
struct Item: Identifiable {
    let id = UUID()
    let name: String
}

// ❌ 避けるべき：文字列をIDとして使用（重複の可能性）
let items = ["item1", "item1", "item2"] // 重複あり
```

### 2. パフォーマンスの最適化

```swift
struct OptimizedListView: View {
    let items: [LargeDataItem]
    
    var body: some View {
        List(items) { item in
            // 軽量なビューコンポーネントを使用
            LazyVStack {
                Text(item.title)
                    .font(.headline)
            }
        }
        // 遅延読み込みを有効にする
        .listStyle(.plain)
    }
}
```

### 3. 状態管理

```swift
struct ManagedListView: View {
    @State private var items: [Item] = []
    @State private var isLoading = false
    
    var body: some View {
        List {
            ForEach(items) { item in
                ItemRowView(item: item)
            }
            
            if isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
        }
        .onAppear {
            loadItemsIfNeeded()
        }
    }
    
    private func loadItemsIfNeeded() {
        guard !isLoading && items.isEmpty else { return }
        
        isLoading = true
        // データ読み込み処理
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // サンプルデータ
            self.items = sampleItems
            self.isLoading = false
        }
    }
}
```

### 4. アクセシビリティの考慮

```swift
struct AccessibleListView: View {
    let items: [Item]
    
    var body: some View {
        List(items) { item in
            HStack {
                Text(item.title)
                Spacer()
                Text(item.subtitle)
                    .foregroundColor(.secondary)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("\(item.title), \(item.subtitle)")
        }
        .accessibilityIdentifier("itemList")
    }
}
```

## まとめ

SwiftUIのListは非常に柔軟で強力なコンポーネントです。基本的な使い方から高度なカスタマイズまで、様々な場面で活用できます。

- **静的コンテンツ**には直接Listブロック内にビューを配置
- **動的コンテンツ**にはForEachやIdentifiableプロトコルを活用
- **パフォーマンス**を考慮して適切なIDの設定と軽量なビューの使用
- **ユーザビリティ**を向上させるための検索、編集、無限スクロール機能の実装
- **アクセシビリティ**への配慮も忘れずに

これらの方法を組み合わせることで、ユーザーにとって使いやすく、開発者にとって保守しやすいリストビューを作成できます。
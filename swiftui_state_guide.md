# SwiftUIにおける@Stateの完全ガイド

SwiftUIの状態管理において最も基本的で重要な `@State` プロパティラッパーについて詳しく解説します。

## 目次
1. [@Stateとは](#stateとは)
2. [基本的な使い方](#基本的な使い方)
3. [様々なデータ型での使用例](#様々なデータ型での使用例)
4. [UIコンポーネントとの連携](#uiコンポーネントとの連携)
5. [複雑な状態管理](#複雑な状態管理)
6. [他のプロパティラッパーとの比較](#他のプロパティラッパーとの比較)
7. [ベストプラクティス](#ベストプラクティス)
8. [よくある間違いと解決方法](#よくある間違いと解決方法)
9. [パフォーマンスに関する考慮事項](#パフォーマンスに関する考慮事項)

## @Stateとは

`@State` は SwiftUI のプロパティラッパーの一つで、**ビュー内で管理される状態**を定義するために使用します。

### 主な特徴
- ビューのライフサイクルに連動
- 値が変更されるとビューが自動的に再描画される
- ビュー内でのみ使用（プライベートな状態）
- 単一のビューが所有する状態を管理

### なぜ@Stateが必要なのか

```swift
// ❌ これは動作しません
struct CounterView: View {
    var count = 0  // 通常のプロパティ
    
    var body: some View {
        VStack {
            Text("カウント: \(count)")
            Button("増加") {
                count += 1  // エラー: 変更できません
            }
        }
    }
}

// ✅ @Stateを使用した正しい方法
struct CounterView: View {
    @State private var count = 0  // @Stateプロパティ
    
    var body: some View {
        VStack {
            Text("カウント: \(count)")
            Button("増加") {
                count += 1  // 正常に動作します
            }
        }
    }
}
```

## 基本的な使い方

### シンプルなカウンター

```swift
import SwiftUI

struct SimpleCounterView: View {
    @State private var count = 0
    
    var body: some View {
        VStack(spacing: 20) {
            Text("カウント: \(count)")
                .font(.title)
            
            HStack(spacing: 15) {
                Button("減少") {
                    count -= 1
                }
                .buttonStyle(.bordered)
                
                Button("リセット") {
                    count = 0
                }
                .buttonStyle(.bordered)
                
                Button("増加") {
                    count += 1
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
    }
}
```

### テキスト入力の管理

```swift
struct TextInputView: View {
    @State private var inputText = ""
    @State private var displayText = "入力待ち..."
    
    var body: some View {
        VStack(spacing: 20) {
            Text(displayText)
                .font(.headline)
                .foregroundColor(.blue)
            
            TextField("テキストを入力", text: $inputText)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            Button("表示を更新") {
                displayText = inputText.isEmpty ? "空の入力です" : inputText
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
```

## 様々なデータ型での使用例

### Bool型（トグル状態）

```swift
struct ToggleExampleView: View {
    @State private var isOn = false
    @State private var showAlert = false
    @State private var isExpanded = false
    
    var body: some View {
        VStack(spacing: 20) {
            // トグルスイッチ
            Toggle("設定をオン", isOn: $isOn)
                .padding(.horizontal)
            
            // 条件に応じた表示
            if isOn {
                Text("設定が有効です")
                    .foregroundColor(.green)
            } else {
                Text("設定が無効です")
                    .foregroundColor(.red)
            }
            
            // アラート表示ボタン
            Button("アラートを表示") {
                showAlert = true
            }
            .alert("確認", isPresented: $showAlert) {
                Button("OK") { }
                Button("キャンセル", role: .cancel) { }
            } message: {
                Text("これはサンプルアラートです")
            }
            
            // 展開可能なセクション
            DisclosureGroup("詳細情報", isExpanded: $isExpanded) {
                Text("これは展開された詳細情報です。")
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}
```

### Array型（リスト管理）

```swift
struct TodoListView: View {
    @State private var todos: [String] = ["買い物", "掃除", "勉強"]
    @State private var newTodo = ""
    
    var body: some View {
        NavigationView {
            VStack {
                // 新しいタスク追加
                HStack {
                    TextField("新しいタスク", text: $newTodo)
                        .textFieldStyle(.roundedBorder)
                    
                    Button("追加") {
                        if !newTodo.isEmpty {
                            todos.append(newTodo)
                            newTodo = ""
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                
                // タスクリスト
                List {
                    ForEach(todos, id: \.self) { todo in
                        Text(todo)
                    }
                    .onDelete(perform: deleteTodos)
                }
            }
            .navigationTitle("やることリスト")
            .toolbar {
                EditButton()
            }
        }
    }
    
    func deleteTodos(offsets: IndexSet) {
        todos.remove(atOffsets: offsets)
    }
}
```

### Optional型

```swift
struct OptionalStateView: View {
    @State private var selectedColor: Color?
    @State private var userName: String?
    @State private var selectedDate: Date?
    
    var body: some View {
        VStack(spacing: 20) {
            // オプショナルな色の選択
            Group {
                Text("選択された色:")
                if let color = selectedColor {
                    Rectangle()
                        .fill(color)
                        .frame(width: 100, height: 50)
                        .cornerRadius(8)
                } else {
                    Text("色が選択されていません")
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Button("赤") { selectedColor = .red }
                    Button("青") { selectedColor = .blue }
                    Button("緑") { selectedColor = .green }
                    Button("クリア") { selectedColor = nil }
                }
                .buttonStyle(.bordered)
            }
            
            Divider()
            
            // オプショナルなユーザー名
            Group {
                if let name = userName {
                    Text("こんにちは、\(name)さん！")
                        .font(.headline)
                } else {
                    Text("ログインしてください")
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Button("ログイン") { userName = "太郎" }
                    Button("ログアウト") { userName = nil }
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
    }
}
```

## UIコンポーネントとの連携

### スライダーとピッカー

```swift
struct SliderPickerView: View {
    @State private var sliderValue: Double = 50
    @State private var selectedFruit = "りんご"
    @State private var selectedDate = Date()
    
    let fruits = ["りんご", "バナナ", "オレンジ", "ぶどう"]
    
    var body: some View {
        Form {
            Section("スライダー") {
                VStack {
                    Text("値: \(Int(sliderValue))")
                        .font(.headline)
                    
                    Slider(value: $sliderValue, in: 0...100, step: 1)
                    
                    HStack {
                        Text("0")
                        Spacer()
                        Text("100")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
            }
            
            Section("ピッカー") {
                Picker("好きな果物", selection: $selectedFruit) {
                    ForEach(fruits, id: \.self) { fruit in
                        Text(fruit).tag(fruit)
                    }
                }
                .pickerStyle(.segmented)
                
                Text("選択: \(selectedFruit)")
                    .foregroundColor(.blue)
            }
            
            Section("日付選択") {
                DatePicker("日付を選択", selection: $selectedDate, displayedComponents: .date)
                
                Text("選択された日付: \(selectedDate, style: .date)")
                    .foregroundColor(.blue)
            }
        }
    }
}
```

### タブビューとナビゲーション

```swift
struct TabNavigationView: View {
    @State private var selectedTab = 0
    @State private var isShowingSheet = false
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // 最初のタブ
            NavigationStack(path: $navigationPath) {
                VStack(spacing: 20) {
                    Text("メインタブ")
                        .font(.title)
                    
                    Button("シートを表示") {
                        isShowingSheet = true
                    }
                    .buttonStyle(.borderedProminent)
                    
                    NavigationLink("詳細ページへ", destination: DetailView())
                }
                .navigationTitle("ホーム")
            }
            .tabItem {
                Image(systemName: "house")
                Text("ホーム")
            }
            .tag(0)
            
            // 2番目のタブ
            SettingsView(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "gear")
                    Text("設定")
                }
                .tag(1)
        }
        .sheet(isPresented: $isShowingSheet) {
            SheetContentView(isPresented: $isShowingSheet)
        }
    }
}

struct DetailView: View {
    var body: some View {
        Text("詳細ページです")
            .navigationTitle("詳細")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct SettingsView: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        VStack {
            Text("設定ページ")
                .font(.title)
            
            Button("ホームタブに戻る") {
                selectedTab = 0
            }
            .buttonStyle(.bordered)
        }
    }
}

struct SheetContentView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Text("シートコンテンツ")
                    .font(.title)
                
                Button("閉じる") {
                    isPresented = false
                }
                .buttonStyle(.borderedProminent)
            }
            .navigationTitle("シート")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完了") {
                        isPresented = false
                    }
                }
            }
        }
    }
}
```

## 複雑な状態管理

### 構造体を使った状態管理

```swift
struct User {
    var name: String
    var email: String
    var age: Int
    var isSubscribed: Bool
}

struct UserProfileView: View {
    @State private var user = User(
        name: "山田太郎",
        email: "yamada@example.com",
        age: 25,
        isSubscribed: false
    )
    @State private var isEditing = false
    
    var body: some View {
        NavigationView {
            Form {
                Section("プロフィール情報") {
                    if isEditing {
                        TextField("名前", text: $user.name)
                        TextField("メール", text: $user.email)
                        Stepper("年齢: \(user.age)", value: $user.age, in: 0...120)
                        Toggle("購読中", isOn: $user.isSubscribed)
                    } else {
                        HStack {
                            Text("名前")
                            Spacer()
                            Text(user.name)
                                .foregroundColor(.blue)
                        }
                        
                        HStack {
                            Text("メール")
                            Spacer()
                            Text(user.email)
                                .foregroundColor(.blue)
                        }
                        
                        HStack {
                            Text("年齢")
                            Spacer()
                            Text("\(user.age)歳")
                                .foregroundColor(.blue)
                        }
                        
                        HStack {
                            Text("購読状況")
                            Spacer()
                            Image(systemName: user.isSubscribed ? "checkmark.circle.fill" : "xmark.circle")
                                .foregroundColor(user.isSubscribed ? .green : .red)
                        }
                    }
                }
            }
            .navigationTitle("ユーザープロフィール")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(isEditing ? "保存" : "編集") {
                        isEditing.toggle()
                    }
                }
            }
        }
    }
}
```

### 複数の関連する状態

```swift
struct WeatherAppView: View {
    @State private var currentTemperature: Double = 20.0
    @State private var humidity: Double = 65.0
    @State private var weatherCondition = "晴れ"
    @State private var isLoading = false
    @State private var lastUpdated = Date()
    @State private var showDetails = false
    
    let weatherConditions = ["晴れ", "曇り", "雨", "雪", "嵐"]
    
    var body: some View {
        VStack(spacing: 20) {
            // メインの天気表示
            VStack {
                HStack {
                    Text(weatherCondition)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Image(systemName: weatherIcon)
                        .font(.system(size: 40))
                        .foregroundColor(weatherColor)
                }
                
                HStack {
                    Text("\(Int(currentTemperature))°C")
                        .font(.system(size: 60, weight: .thin))
                    
                    Spacer()
                }
                
                HStack {
                    Text("湿度: \(Int(humidity))%")
                    Spacer()
                    Text("更新: \(lastUpdated, style: .time)")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(12)
            
            // 詳細情報トグル
            Button("詳細を\(showDetails ? "隠す" : "表示")") {
                withAnimation {
                    showDetails.toggle()
                }
            }
            .buttonStyle(.bordered)
            
            if showDetails {
                DetailedWeatherView(
                    temperature: $currentTemperature,
                    humidity: $humidity,
                    condition: $weatherCondition,
                    conditions: weatherConditions
                )
                .transition(.slide)
            }
            
            // 更新ボタン
            Button("天気を更新") {
                updateWeather()
            }
            .buttonStyle(.borderedProminent)
            .disabled(isLoading)
            
            if isLoading {
                ProgressView("更新中...")
            }
            
            Spacer()
        }
        .padding()
    }
    
    private var weatherIcon: String {
        switch weatherCondition {
        case "晴れ": return "sun.max"
        case "曇り": return "cloud"
        case "雨": return "cloud.rain"
        case "雪": return "cloud.snow"
        case "嵐": return "cloud.bolt"
        default: return "questionmark"
        }
    }
    
    private var weatherColor: Color {
        switch weatherCondition {
        case "晴れ": return .yellow
        case "曇り": return .gray
        case "雨": return .blue
        case "雪": return .cyan
        case "嵐": return .purple
        default: return .black
        }
    }
    
    private func updateWeather() {
        isLoading = true
        
        // 擬似的な非同期処理
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            currentTemperature = Double.random(in: -10...35)
            humidity = Double.random(in: 30...90)
            weatherCondition = weatherConditions.randomElement() ?? "晴れ"
            lastUpdated = Date()
            isLoading = false
        }
    }
}

struct DetailedWeatherView: View {
    @Binding var temperature: Double
    @Binding var humidity: Double
    @Binding var condition: String
    let conditions: [String]
    
    var body: some View {
        VStack(spacing: 15) {
            Text("詳細設定")
                .font(.headline)
            
            VStack {
                Text("気温: \(Int(temperature))°C")
                Slider(value: $temperature, in: -10...40, step: 1)
            }
            
            VStack {
                Text("湿度: \(Int(humidity))%")
                Slider(value: $humidity, in: 0...100, step: 1)
            }
            
            Picker("天気", selection: $condition) {
                ForEach(conditions, id: \.self) { condition in
                    Text(condition).tag(condition)
                }
            }
            .pickerStyle(.segmented)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}
```

## 他のプロパティラッパーとの比較

### @State vs @Binding

```swift
struct StateBindingComparisonView: View {
    @State private var parentValue = "親の値"
    
    var body: some View {
        VStack(spacing: 20) {
            Text("親ビュー: \(parentValue)")
                .font(.headline)
            
            // @Stateを使用した子ビュー（独立した状態）
            StateChildView()
            
            Divider()
            
            // @Bindingを使用した子ビュー（状態を共有）
            BindingChildView(sharedValue: $parentValue)
        }
        .padding()
    }
}

struct StateChildView: View {
    @State private var childValue = "子の独立した値"
    
    var body: some View {
        VStack {
            Text("@State子ビュー: \(childValue)")
            TextField("値を変更", text: $childValue)
                .textFieldStyle(.roundedBorder)
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(8)
    }
}

struct BindingChildView: View {
    @Binding var sharedValue: String
    
    var body: some View {
        VStack {
            Text("@Binding子ビュー: \(sharedValue)")
            TextField("親の値を変更", text: $sharedValue)
                .textFieldStyle(.roundedBorder)
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(8)
    }
}
```

### @State vs @StateObject vs @ObservedObject

```swift
// ObservableObjectの例
class UserData: ObservableObject {
    @Published var username = ""
    @Published var score = 0
    
    func incrementScore() {
        score += 1
    }
}

struct StateObjectComparisonView: View {
    // @State: 単純な値型の状態管理
    @State private var simpleCounter = 0
    
    // @StateObject: このビューがオブジェクトの所有者
    @StateObject private var userData = UserData()
    
    var body: some View {
        VStack(spacing: 20) {
            // @Stateの例
            VStack {
                Text("@State カウンター: \(simpleCounter)")
                Button("増加") { simpleCounter += 1 }
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(8)
            
            // @StateObjectの例
            VStack {
                Text("@StateObject ユーザー: \(userData.username)")
                Text("スコア: \(userData.score)")
                
                TextField("ユーザー名", text: $userData.username)
                    .textFieldStyle(.roundedBorder)
                
                Button("スコア増加") {
                    userData.incrementScore()
                }
            }
            .padding()
            .background(Color.green.opacity(0.1))
            .cornerRadius(8)
            
            // 子ビューに@ObservedObjectとして渡す
            ObservedObjectChildView(userData: userData)
        }
        .padding()
    }
}

struct ObservedObjectChildView: View {
    @ObservedObject var userData: UserData
    
    var body: some View {
        VStack {
            Text("@ObservedObject 子ビュー")
            Text("ユーザー: \(userData.username)")
            Text("スコア: \(userData.score)")
            
            Button("子ビューからスコア増加") {
                userData.incrementScore()
            }
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(8)
    }
}
```

## ベストプラクティス

### 1. privateキーワードの使用

```swift
struct BestPracticeView: View {
    // ✅ 良い例: privateを使用
    @State private var count = 0
    @State private var isVisible = true
    
    // ❌ 避けるべき: privateなし（他のビューからアクセス可能になってしまう）
    // @State var publicCount = 0
    
    var body: some View {
        VStack {
            if isVisible {
                Text("カウント: \(count)")
            }
            
            Button("増加") { count += 1 }
            Button("表示切替") { isVisible.toggle() }
        }
    }
}
```

### 2. 初期値の適切な設定

```swift
struct InitializationBestPracticeView: View {
    // ✅ 良い例: 意味のある初期値
    @State private var userName = ""
    @State private var age = 18
    @State private var selectedOptions: Set<String> = []
    @State private var isLoading = false
    
    // ✅ 良い例: オプショナル型で未選択状態を表現
    @State private var selectedDate: Date? = nil
    @State private var selectedColor: Color? = nil
    
    var body: some View {
        Form {
            Section("ユーザー情報") {
                TextField("名前", text: $userName)
                Stepper("年齢: \(age)", value: $age, in: 0...120)
            }
            
            Section("オプション") {
                if let date = selectedDate {
                    Text("選択された日付: \(date, style: .date)")
                } else {
                    Text("日付が選択されていません")
                }
                
                DatePicker("日付選択", selection: Binding(
                    get: { selectedDate ?? Date() },
                    set: { selectedDate = $0 }
                ), displayedComponents: .date)
            }
        }
    }
}
```

### 3. 状態の分割と整理

```swift
struct OrganizedStateView: View {
    // UI状態
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var selectedTab = 0
    
    // データ状態
    @State private var items: [String] = []
    @State private var searchText = ""
    @State private var sortOrder: SortOrder = .ascending
    
    // フォーム状態
    @State private var formData = FormData()
    
    enum SortOrder {
        case ascending, descending
    }
    
    struct FormData {
        var name = ""
        var email = ""
        var age = 0
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // 検索機能
                SearchBar(searchText: $searchText)
                
                // リスト表示
                ItemList(items: filteredItems, sortOrder: $sortOrder)
                
                // フォーム
                FormView(formData: $formData)
            }
            .navigationTitle("整理された状態管理")
        }
    }
    
    private var filteredItems: [String] {
        items.filter { item in
            searchText.isEmpty || item.contains(searchText)
        }
        .sorted { first, second in
            sortOrder == .ascending ? first < second : first > second
        }
    }
}

struct SearchBar: View {
    @Binding var searchText: String
    
    var body: some View {
        TextField("検索...", text: $searchText)
            .textFieldStyle(.roundedBorder)
            .padding()
    }
}

struct ItemList: View {
    let items: [String]
    @Binding var sortOrder: OrganizedStateView.SortOrder
    
    var body: some View {
        VStack {
            Picker("並び順", selection: $sortOrder) {
                Text("昇順").tag(OrganizedStateView.SortOrder.ascending)
                Text("降順").tag(OrganizedStateView.SortOrder.descending)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            List(items, id: \.self) { item in
                Text(item)
            }
        }
    }
}

struct FormView: View {
    @Binding var formData: OrganizedStateView.FormData
    
    var body: some View {
        Form {
            Section("個人情報") {
                TextField("名前", text: $formData.name)
                TextField("メール", text: $formData.email)
                Stepper("年齢: \(formData.age)", value: $formData.age, in: 0...120)
            }
        }
    }
}
```

## よくある間違いと解決方法

### 1. @Stateを他のビューに直接渡す間違い

```swift
// ❌ 間違った例
struct WrongParentView: View {
    @State private var count = 0
    
    var body: some View {
        VStack {
            Text("親: \(count)")
            WrongChildView(count: count)  // 値のコピーが渡される
        }
    }
}

struct WrongChildView: View {
    let count: Int  // 値のコピー
    
    var body: some View {
        VStack {
            Text("子: \(count)")
            Button("増加") {
                // count += 1  // エラー: letなので変更できない
            }
        }
    }
}

// ✅ 正しい例
struct CorrectParentView: View {
    @State private var count = 0
    
    var body: some View {
        VStack {
            Text("親: \(count)")
            CorrectChildView(count: $count)  // Bindingとして渡す
        }
    }
}

struct CorrectChildView: View {
    @Binding var count: Int  // Bindingで受け取る
    
    var body: some View {
        VStack {
            Text("子: \(count)")
            Button("増加") {
                count += 1  // 正常に動作
            }
        }
    }
}
```

### 2. 構造体のプロパティを直接変更しようとする間違い

```swift
struct Person {
    var name: String
    var age: Int
}

// ❌ 間違った例
struct WrongStructModificationView: View {
    @State private var person = Person(name: "太郎", age: 25)
    
    var body: some View {
        VStack {
            Text("名前: \(person.name), 年齢: \(person.age)")
            
            Button("年齢を増やす") {
                // person.age += 1  // 直接変更はできない場合がある
            }
        }
    }
}

// ✅ 正しい例
struct CorrectStructModificationView: View {
    @State private var person = Person(name: "太郎", age: 25)
    
    var body: some View {
        VStack {
            Text("名前: \(person.name), 年齢: \(person.age)")
            
            Button("年齢を増やす") {
                // 新しいインスタンスを作成して代入
                person = Person(name: person.name, age: person.age + 1)
            }
            
            // または、mutatingメソッドを作成
            Button("名前を変更") {
                var newPerson = person
                newPerson.name = "花子"
                person = newPerson
            }
        }
    }
}
```

### 3. 非同期処理での状態更新の間違い

```swift
struct AsyncUpdateView: View {
    @State private var data: [String] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("読み込み中...")
            } else if let error = errorMessage {
                Text("エラー: \(error)")
                    .foregroundColor(.red)
            } else {
                List(data, id: \.self) { item in
                    Text(item)
                }
            }
            
            Button("データを読み込む") {
                loadData()
            }
        }
        .padding()
    }
    
    private func loadData() {
        isLoading = true
        errorMessage = nil
        
        // ✅ 正しい例: メインスレッドで状態を更新
        DispatchQueue.global().async {
            // バックグラウンドでの処理
            Thread.sleep(forTimeInterval: 2)
            let newData = ["アイテム1", "アイテム2", "アイテム3"]
            
            DispatchQueue.main.async {
                self.data = newData
                self.isLoading = false
            }
        }
        
        // ❌ 間違った例: バックグラウンドスレッドで直接UI更新
        // DispatchQueue.global().async {
        //     Thread.sleep(forTimeInterval: 2)
        //     self.data = newData  // UIスレッド以外からの更新は危険
        //     self.isLoading = false
        // }
    }
}
```

## パフォーマンスに関する考慮事項

### 1. 不要な再描画を避ける

```swift
// ❌ 頻繁に更新される状態が他の部分も再描画させる例
struct PerformanceProblemView: View {
    @State private var timerCount = 0
    @State private var userInput = ""
    @State private var expensiveComputationResult = ""
    
    var body: some View {
        VStack {
            // タイマーが更新されるたびに全体が再描画される
            Text("タイマー: \(timerCount)")
            Text("入力: \(userInput)")
            Text("計算結果: \(expensiveComputationResult)")
            
            TextField("入力", text: $userInput)
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                timerCount += 1
            }
        }
    }
}

// ✅ 改善例: 関心事を分離
struct PerformanceOptimizedView: View {
    @State private var userInput = ""
    @State private var expensiveComputationResult = ""
    
    var body: some View {
        VStack {
            // タイマーは独立したビューに分離
            TimerView()
            
            // ユーザー入力部分
            VStack {
                Text("入力: \(userInput)")
                TextField("入力", text: $userInput)
                    .onChange(of: userInput) { newValue in
                        // 必要な時のみ計算を実行
                        updateExpensiveComputation(input: newValue)
                    }
            }
            
            Text("計算結果: \(expensiveComputationResult)")
        }
    }
    
    private func updateExpensiveComputation(input: String) {
        // 重い計算をシミュレート
        expensiveComputationResult = "計算済み: \(input.count)"
    }
}

struct TimerView: View {
    @State private var timerCount = 0
    
    var body: some View {
        Text("タイマー: \(timerCount)")
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                    timerCount += 1
                }
            }
    }
}
```

### 2. 計算プロパティの活用

```swift
struct ComputedPropertyView: View {
    @State private var items: [Item] = []
    @State private var searchText = ""
    @State private var selectedCategory = "すべて"
    
    // ✅ 計算プロパティを使用してフィルタリング
    private var filteredItems: [Item] {
        items
            .filter { item in
                searchText.isEmpty || item.name.contains(searchText)
            }
            .filter { item in
                selectedCategory == "すべて" || item.category == selectedCategory
            }
    }
    
    // ✅ 計算プロパティでサマリー情報を提供
    private var itemSummary: String {
        "合計: \(filteredItems.count)件"
    }
    
    var body: some View {
        VStack {
            HStack {
                TextField("検索", text: $searchText)
                Picker("カテゴリ", selection: $selectedCategory) {
                    Text("すべて").tag("すべて")
                    Text("重要").tag("重要")
                    Text("普通").tag("普通")
                }
            }
            
            Text(itemSummary)
                .font(.caption)
                .foregroundColor(.secondary)
            
            List(filteredItems) { item in
                Text(item.name)
            }
        }
        .padding()
    }
}

struct Item: Identifiable {
    let id = UUID()
    let name: String
    let category: String
}
```

### 3. 大きなデータセットの管理

```swift
struct LargeDataSetView: View {
    @State private var allItems: [LargeItem] = []
    @State private var currentPage = 0
    @State private var isLoading = false
    
    private let pageSize = 50
    
    // ✅ ページングで表示するアイテムを制限
    private var displayedItems: [LargeItem] {
        let endIndex = min((currentPage + 1) * pageSize, allItems.count)
        return Array(allItems[0..<endIndex])
    }
    
    var body: some View {
        VStack {
            Text("表示中: \(displayedItems.count) / \(allItems.count)")
                .font(.caption)
            
            List(displayedItems) { item in
                LazyVStack(alignment: .leading) {
                    Text(item.title)
                        .font(.headline)
                    Text(item.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .onAppear {
                    // 最後のアイテムが表示されたら次のページを読み込み
                    if item.id == displayedItems.last?.id {
                        loadNextPageIfNeeded()
                    }
                }
            }
            
            if isLoading {
                ProgressView("読み込み中...")
                    .padding()
            }
        }
        .onAppear {
            loadInitialData()
        }
    }
    
    private func loadInitialData() {
        guard allItems.isEmpty else { return }
        
        isLoading = true
        // 初期データの読み込み
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            allItems = generateSampleData(count: 500)
            isLoading = false
        }
    }
    
    private func loadNextPageIfNeeded() {
        guard !isLoading && displayedItems.count < allItems.count else { return }
        
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            currentPage += 1
            isLoading = false
        }
    }
    
    private func generateSampleData(count: Int) -> [LargeItem] {
        (1...count).map { index in
            LargeItem(
                title: "アイテム \(index)",
                description: "これはアイテム \(index) の説明です。"
            )
        }
    }
}

struct LargeItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
}
```

## まとめ

`@State` は SwiftUI における状態管理の基礎となる重要な概念です。

### 重要なポイント

1. **単一ビューの責任**: `@State` はそのビューが所有する状態を管理
2. **自動更新**: 値が変更されると自動的にビューが再描画される
3. **private使用**: 基本的には `private` キーワードと組み合わせて使用
4. **適切な初期値**: 意味のある初期値を設定する
5. **状態の分離**: 関連する状態をまとめ、無関係な状態は分離する

### 使い分けガイド

- **@State**: ビュー内での単純な状態管理
- **@Binding**: 親ビューから子ビューへの状態の共有
- **@StateObject**: ObservableObjectの所有者となる場合
- **@ObservedObject**: 他で作成されたObservableObjectを観察する場合

### ベストプラクティス

- `private` キーワードの使用
- 適切な初期値の設定
- 状態の論理的な分割
- パフォーマンスを考慮した設計
- 非同期処理での適切な更新

`@State` を正しく理解し活用することで、SwiftUI アプリケーションにおける効果的な状態管理が可能になります。
# SwiftUIでの複数ファイル間での変数の受け渡し

SwiftUIにおいて、複数のViewファイル間でデータを受け渡す方法を具体的なコード例とともに解説します。

## 目次
1. [基本的な値の受け渡し](#基本的な値の受け渡し)
2. [@Stateと@Bindingを使った双方向通信](#stateとbindingを使った双方向通信)
3. [@ObservableObjectを使ったデータ共有](#observableobjectを使ったデータ共有)
4. [@EnvironmentObjectを使ったアプリ全体のデータ共有](#environmentobjectを使ったアプリ全体のデータ共有)
5. [コールバック関数を使った通信](#コールバック関数を使った通信)
6. [実践的な例：ユーザー情報管理アプリ](#実践的な例ユーザー情報管理アプリ)
7. [ベストプラクティス](#ベストプラクティス)

---

## 基本的な値の受け渡し

最もシンプルな方法は、親Viewから子Viewに値を直接渡すことです。

### ParentView.swift
```swift
import SwiftUI

struct ParentView: View {
    let userName = "田中太郎"
    let userAge = 25
    
    var body: some View {
        VStack {
            Text("親View")
                .font(.title)
            
            ChildView(name: userName, age: userAge)
        }
        .padding()
    }
}
```

### ChildView.swift
```swift
import SwiftUI

struct ChildView: View {
    let name: String
    let age: Int
    
    var body: some View {
        VStack {
            Text("子View")
                .font(.headline)
            Text("名前: \(name)")
            Text("年齢: \(age)歳")
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}
```

---

## @Stateと@Bindingを使った双方向通信

子Viewで変更した値を親Viewに反映させたい場合は、`@Binding`を使用します。

### ParentView.swift
```swift
import SwiftUI

struct ParentView: View {
    @State private var counter = 0
    @State private var inputText = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("親View - カウンター: \(counter)")
                .font(.title)
            
            Text("入力されたテキスト: \(inputText)")
            
            CounterChildView(counter: $counter)
            TextInputChildView(text: $inputText)
        }
        .padding()
    }
}
```

### CounterChildView.swift
```swift
import SwiftUI

struct CounterChildView: View {
    @Binding var counter: Int
    
    var body: some View {
        VStack {
            Text("カウンター子View")
                .font(.headline)
            
            HStack {
                Button("＋") {
                    counter += 1
                }
                .buttonStyle(.borderedProminent)
                
                Button("－") {
                    counter -= 1
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(10)
    }
}
```

### TextInputChildView.swift
```swift
import SwiftUI

struct TextInputChildView: View {
    @Binding var text: String
    
    var body: some View {
        VStack {
            Text("テキスト入力子View")
                .font(.headline)
            
            TextField("テキストを入力", text: $text)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(10)
    }
}
```

---

## @ObservableObjectを使ったデータ共有

複雑なデータや複数のプロパティを管理する場合は、`@ObservableObject`を使用します。

### UserData.swift
```swift
import SwiftUI

class UserData: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var age: Int = 0
    @Published var isLoggedIn: Bool = false
    
    func login() {
        isLoggedIn = true
    }
    
    func logout() {
        isLoggedIn = false
        name = ""
        email = ""
        age = 0
    }
    
    func updateProfile(name: String, email: String, age: Int) {
        self.name = name
        self.email = email
        self.age = age
    }
}
```

### MainView.swift
```swift
import SwiftUI

struct MainView: View {
    @StateObject private var userData = UserData()
    
    var body: some View {
        NavigationView {
            VStack {
                if userData.isLoggedIn {
                    ProfileView(userData: userData)
                } else {
                    LoginView(userData: userData)
                }
            }
            .navigationTitle("ユーザー管理")
        }
    }
}
```

### LoginView.swift
```swift
import SwiftUI

struct LoginView: View {
    @ObservedObject var userData: UserData
    @State private var tempName = ""
    @State private var tempEmail = ""
    @State private var tempAge = ""
    
    var body: some View {
        VStack(spacing: 15) {
            Text("ログイン")
                .font(.title)
            
            TextField("名前", text: $tempName)
                .textFieldStyle(.roundedBorder)
            
            TextField("メールアドレス", text: $tempEmail)
                .textFieldStyle(.roundedBorder)
            
            TextField("年齢", text: $tempAge)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)
            
            Button("ログイン") {
                if let age = Int(tempAge) {
                    userData.updateProfile(name: tempName, email: tempEmail, age: age)
                    userData.login()
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(tempName.isEmpty || tempEmail.isEmpty || tempAge.isEmpty)
        }
        .padding()
    }
}
```

### ProfileView.swift
```swift
import SwiftUI

struct ProfileView: View {
    @ObservedObject var userData: UserData
    
    var body: some View {
        VStack(spacing: 15) {
            Text("プロフィール")
                .font(.title)
            
            VStack(alignment: .leading, spacing: 5) {
                Text("名前: \(userData.name)")
                Text("メール: \(userData.email)")
                Text("年齢: \(userData.age)歳")
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            
            Button("ログアウト") {
                userData.logout()
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}
```

---

## @EnvironmentObjectを使ったアプリ全体のデータ共有

アプリ全体で共有したいデータがある場合は、`@EnvironmentObject`を使用します。

### App.swift
```swift
import SwiftUI

@main
struct MyApp: App {
    @StateObject private var themeManager = ThemeManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(themeManager)
        }
    }
}
```

### ThemeManager.swift
```swift
import SwiftUI

class ThemeManager: ObservableObject {
    @Published var isDarkMode: Bool = false
    @Published var primaryColor: Color = .blue
    
    var backgroundColor: Color {
        isDarkMode ? .black : .white
    }
    
    var textColor: Color {
        isDarkMode ? .white : .black
    }
    
    func toggleTheme() {
        isDarkMode.toggle()
    }
    
    func setPrimaryColor(_ color: Color) {
        primaryColor = color
    }
}
```

### ContentView.swift
```swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                HomeView()
                
                NavigationLink("設定画面へ", destination: SettingsView())
                    .padding()
            }
        }
    }
}
```

### HomeView.swift
```swift
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 20) {
            Text("ホーム画面")
                .font(.title)
                .foregroundColor(themeManager.textColor)
            
            Text("現在のテーマ: \(themeManager.isDarkMode ? "ダーク" : "ライト")")
                .foregroundColor(themeManager.textColor)
            
            Rectangle()
                .fill(themeManager.primaryColor)
                .frame(width: 100, height: 100)
                .cornerRadius(10)
        }
        .padding()
        .background(themeManager.backgroundColor)
    }
}
```

### SettingsView.swift
```swift
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 20) {
            Text("設定画面")
                .font(.title)
                .foregroundColor(themeManager.textColor)
            
            Toggle("ダークモード", isOn: $themeManager.isDarkMode)
                .padding()
            
            Text("プライマリカラー")
                .foregroundColor(themeManager.textColor)
            
            HStack {
                ColorButton(color: .blue, themeManager: themeManager)
                ColorButton(color: .red, themeManager: themeManager)
                ColorButton(color: .green, themeManager: themeManager)
                ColorButton(color: .purple, themeManager: themeManager)
            }
        }
        .padding()
        .background(themeManager.backgroundColor)
        .navigationTitle("設定")
    }
}

struct ColorButton: View {
    let color: Color
    let themeManager: ThemeManager
    
    var body: some View {
        Button(action: {
            themeManager.setPrimaryColor(color)
        }) {
            Circle()
                .fill(color)
                .frame(width: 30, height: 30)
                .overlay(
                    Circle()
                        .stroke(themeManager.primaryColor == color ? Color.black : Color.clear, lineWidth: 3)
                )
        }
    }
}
```

---

## コールバック関数を使った通信

親Viewに処理結果を通知したい場合は、コールバック関数を使用します。

### ParentView.swift
```swift
import SwiftUI

struct ParentView: View {
    @State private var resultMessage = "まだ何も選択されていません"
    @State private var selectedItems: [String] = []
    
    var body: some View {
        VStack(spacing: 20) {
            Text("結果: \(resultMessage)")
                .font(.headline)
                .padding()
            
            Text("選択されたアイテム: \(selectedItems.joined(separator: ", "))")
                .padding()
            
            SelectionView(
                onItemSelected: { item in
                    resultMessage = "\(item)が選択されました"
                    if !selectedItems.contains(item) {
                        selectedItems.append(item)
                    }
                },
                onClearSelection: {
                    resultMessage = "選択がクリアされました"
                    selectedItems.removeAll()
                }
            )
        }
        .padding()
    }
}
```

### SelectionView.swift
```swift
import SwiftUI

struct SelectionView: View {
    let items = ["りんご", "バナナ", "オレンジ", "ぶどう"]
    let onItemSelected: (String) -> Void
    let onClearSelection: () -> Void
    
    var body: some View {
        VStack {
            Text("アイテム選択")
                .font(.headline)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2)) {
                ForEach(items, id: \.self) { item in
                    Button(item) {
                        onItemSelected(item)
                    }
                    .buttonStyle(.bordered)
                    .padding(2)
                }
            }
            
            Button("選択をクリア") {
                onClearSelection()
            }
            .buttonStyle(.borderedProminent)
            .padding(.top)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}
```

---

## 実践的な例：ユーザー情報管理アプリ

複数のデータ受け渡し方法を組み合わせた実践的な例を紹介します。

### Models/User.swift
```swift
import Foundation

struct User: Identifiable, Codable {
    let id = UUID()
    var name: String
    var email: String
    var age: Int
    var profileImage: String = "person.circle"
}
```

### ViewModels/UserStore.swift
```swift
import SwiftUI

class UserStore: ObservableObject {
    @Published var users: [User] = []
    @Published var selectedUser: User?
    
    func addUser(_ user: User) {
        users.append(user)
    }
    
    func updateUser(_ user: User) {
        if let index = users.firstIndex(where: { $0.id == user.id }) {
            users[index] = user
        }
    }
    
    func deleteUser(_ user: User) {
        users.removeAll { $0.id == user.id }
    }
    
    func selectUser(_ user: User) {
        selectedUser = user
    }
}
```

### Views/MainAppView.swift
```swift
import SwiftUI

struct MainAppView: View {
    @StateObject private var userStore = UserStore()
    
    var body: some View {
        NavigationView {
            UserListView()
                .environmentObject(userStore)
        }
    }
}
```

### Views/UserListView.swift
```swift
import SwiftUI

struct UserListView: View {
    @EnvironmentObject var userStore: UserStore
    @State private var showingAddUser = false
    
    var body: some View {
        List {
            ForEach(userStore.users) { user in
                UserRowView(user: user) {
                    userStore.selectUser(user)
                }
            }
            .onDelete(perform: deleteUsers)
        }
        .navigationTitle("ユーザー一覧")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("追加") {
                    showingAddUser = true
                }
            }
        }
        .sheet(isPresented: $showingAddUser) {
            AddUserView { user in
                userStore.addUser(user)
                showingAddUser = false
            }
        }
        .sheet(item: $userStore.selectedUser) { user in
            UserDetailView(user: user) { updatedUser in
                userStore.updateUser(updatedUser)
                userStore.selectedUser = nil
            }
        }
    }
    
    func deleteUsers(offsets: IndexSet) {
        for index in offsets {
            userStore.deleteUser(userStore.users[index])
        }
    }
}
```

### Views/UserRowView.swift
```swift
import SwiftUI

struct UserRowView: View {
    let user: User
    let onTap: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: user.profileImage)
                .font(.title2)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading) {
                Text(user.name)
                    .font(.headline)
                Text(user.email)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("\(user.age)歳")
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}
```

### Views/AddUserView.swift
```swift
import SwiftUI

struct AddUserView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var age = ""
    
    let onSave: (User) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("ユーザー情報")) {
                    TextField("名前", text: $name)
                    TextField("メールアドレス", text: $email)
                        .keyboardType(.emailAddress)
                    TextField("年齢", text: $age)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("新規ユーザー")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("キャンセル") {
                        // キャンセル処理
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        if let ageInt = Int(age) {
                            let newUser = User(name: name, email: email, age: ageInt)
                            onSave(newUser)
                        }
                    }
                    .disabled(name.isEmpty || email.isEmpty || age.isEmpty)
                }
            }
        }
    }
}
```

### Views/UserDetailView.swift
```swift
import SwiftUI

struct UserDetailView: View {
    @State private var editableUser: User
    let onSave: (User) -> Void
    
    init(user: User, onSave: @escaping (User) -> Void) {
        self._editableUser = State(initialValue: user)
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("プロフィール画像")) {
                    HStack {
                        Image(systemName: editableUser.profileImage)
                            .font(.system(size: 50))
                            .foregroundColor(.blue)
                        Spacer()
                    }
                }
                
                Section(header: Text("ユーザー情報")) {
                    TextField("名前", text: $editableUser.name)
                    TextField("メールアドレス", text: $editableUser.email)
                        .keyboardType(.emailAddress)
                    
                    HStack {
                        Text("年齢")
                        Spacer()
                        TextField("年齢", value: $editableUser.age, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
            .navigationTitle("ユーザー詳細")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        onSave(editableUser)
                    }
                }
            }
        }
    }
}
```

---

## ベストプラクティス

### 1. 適切な方法の選択

- **単純な値の受け渡し**: 基本的なパラメータ渡し
- **子Viewでの値変更が必要**: `@Binding`
- **複雑なデータモデル**: `@ObservableObject`
- **アプリ全体で共有**: `@EnvironmentObject`
- **イベント通知**: コールバック関数

### 2. データの流れを明確にする

```swift
// ❌ 避けるべき: 複雑な双方向Binding
struct ChildView: View {
    @Binding var complexObject: ComplexObject
    // 複雑なオブジェクトの直接的なBinding
}

// ✅ 推奨: 明確な責任分離
struct ChildView: View {
    let object: ComplexObject
    let onUpdate: (ComplexObject) -> Void
    // 明確な入力と出力
}
```

### 3. @Published を適切に使用

```swift
class DataManager: ObservableObject {
    @Published var publicData: String = "" // UIに影響するデータ
    private var internalCache: [String] = [] // 内部データはPublishedにしない
    
    func updateData(_ newData: String) {
        internalCache.append(newData)
        publicData = processedData()
    }
}
```

### 4. メモリ管理に注意

```swift
// @StateObject: Viewがデータのオーナーの場合
struct ParentView: View {
    @StateObject private var dataManager = DataManager()
}

// @ObservedObject: データが外部から渡される場合
struct ChildView: View {
    @ObservedObject var dataManager: DataManager
}

// @EnvironmentObject: アプリ全体で共有する場合
struct AnyView: View {
    @EnvironmentObject var globalData: GlobalDataManager
}
```

### 5. 型安全性を保つ

```swift
// ✅ 型安全なコールバック
struct ButtonView: View {
    let onTap: (ButtonType) -> Void
    
    enum ButtonType {
        case save, cancel, delete
    }
}

// ❌ 避けるべき: 文字列での判定
struct ButtonView: View {
    let onTap: (String) -> Void // "save", "cancel" などの文字列
}
```

---

## まとめ

SwiftUIでの変数の受け渡しには複数の方法があり、それぞれ適切な使用場面があります：

1. **基本的なパラメータ渡し**: 単純な値の表示
2. **@Binding**: 子Viewでの値変更が必要な場合
3. **@ObservableObject**: 複雑なデータモデルの管理
4. **@EnvironmentObject**: アプリ全体でのデータ共有
5. **コールバック関数**: イベントやアクションの通知

適切な方法を選択することで、保守性が高く、理解しやすいSwiftUIアプリケーションを構築できます。
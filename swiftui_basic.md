# SwiftUI 基本文法まとめ

## SwiftUIとは
Appleが提供する宣言的UIフレームワーク。iOS, macOS, watchOS, tvOS向けのUIを簡潔に記述できる。

---

## 基本構文
```swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, SwiftUI!")
    }
}
```

---

## 代表的なView

### Text
```swift
Text("テキスト表示")
    .font(.title)
    .foregroundColor(.blue)
```

### Image
```swift
Image(systemName: "star.fill")
    .foregroundColor(.yellow)
```

### Button
```swift
Button("押してね") {
    print("ボタンが押されました")
}
```

### List
```swift
List {
    Text("アイテム1")
    Text("アイテム2")
}
```

---

## レイアウト

### VStack, HStack, ZStack
```swift
VStack {
    Text("上")
    Text("下")
}

HStack {
    Text("左")
    Text("右")
}

ZStack {
    Image("背景")
    Text("前面")
}
```

---

## 修飾子（Modifier）
```swift
Text("修飾子例")
    .font(.headline)
    .padding()
    .background(Color.gray)
    .cornerRadius(8)
```

---

## データ管理


### State
```swift
@State private var count = 0

Button("カウント: \(count)") {
    count += 1
}
```

### Binding
```swift
struct ParentView: View {
    @State private var text = ""
    var body: some View {
        ChildView(text: $text)
    }
}

struct ChildView: View {
    @Binding var text: String
    var body: some View {
        TextField("入力", text: $text)
    }
}
```

---

## Swiftの基本文法

### 変数・定数
```swift
var name = "Taro"      // 変数
let age = 20           // 定数
```

### 配列・辞書
```swift
let fruits = ["Apple", "Banana", "Orange"]
let scores = ["Math": 80, "English": 90]
```

### 条件分岐
```swift
let score = 75
if score >= 80 {
    print("合格")
} else if score >= 60 {
    print("追試")
} else {
    print("不合格")
}
```

### 繰り返し
```swift
for fruit in fruits {
    print(fruit)
}

for i in 0..<5 {
    print(i)
}

var i = 0
while i < 3 {
    print(i)
    i += 1
}
```

### 関数
```swift
func greet(name: String) -> String {
    return "Hello, \(name)!"
}

let message = greet(name: "Hanako")
```

### 構造体
```swift
struct User {
    var name: String
    var age: Int
}

let user = User(name: "Taro", age: 20)
```

### 列挙型
```swift
enum Direction {
    case up, down, left, right
}

let dir = Direction.left
```

### オプショナル
```swift
var nickname: String? = nil
nickname = "Swift"

if let name = nickname {
    print(name)
} else {
    print("値なし")
}
```

### クロージャ
```swift
let add = { (a: Int, b: Int) -> Int in
    return a + b
}
let result = add(2, 3) // 5
```

---

---

## 参考
- [Apple公式ドキュメント](https://developer.apple.com/documentation/swiftui/)
- [SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)

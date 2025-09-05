# SwiftUIでよく発生するエラーとその意味

SwiftUIを使用する際に遭遇する可能性のある一般的なエラーとその解決方法を以下にまとめます。

---

## 1. `Cannot find 'X' in scope`
### 意味
SwiftUIで使用している変数や関数、型がスコープ内で見つからない場合に発生します。

### 解決方法
- 該当の変数や関数が正しく宣言されているか確認する。
- 必要なモジュール（例: `import SwiftUI`）がインポートされているか確認する。

---

## 2. `Type 'X' does not conform to protocol 'View'`
### 意味
SwiftUIのViewプロトコルに準拠していない型を使用しようとした場合に発生します。

### 解決方法
- `View`プロトコルに準拠するために、`body`プロパティを実装する。

```swift
struct MyView: View {
    var body: some View {
        Text("Hello, SwiftUI!")
    }
}
```

---

## 3. `Missing argument for parameter 'X' in call`
### 意味
関数やイニシャライザの呼び出し時に、必要な引数が不足している場合に発生します。

### 解決方法
- 関数やイニシャライザのシグネチャを確認し、必要な引数をすべて渡す。

---

## 4. `Cannot use mutating member on immutable value`
### 意味
`struct`内で`mutating`メソッドを呼び出そうとしたが、インスタンスが`let`で宣言されている場合に発生します。

### 解決方法
- インスタンスを`var`で宣言する。

```swift
struct Counter {
    var count = 0
    mutating func increment() {
        count += 1
    }
}

var counter = Counter()
counter.increment()
```

---

## 5. `Thread 1: Fatal error: Index out of range`
### 意味
配列やコレクションのインデックスが範囲外の場合に発生します。

### 解決方法
- 配列のインデックスが有効かどうかを確認する。

```swift
let array = [1, 2, 3]
if array.indices.contains(3) {
    print(array[3])
} else {
    print("範囲外です")
}
```

---

## 6. `Type 'X' has no member 'Y'`
### 意味
型`X`に存在しないプロパティやメソッドを使用しようとした場合に発生します。

### 解決方法
- 型`X`の定義を確認し、正しいプロパティやメソッドを使用する。
- スペルミスがないか確認する。

---

## 7. `Cannot assign to property: 'self' is immutable`
### 意味
`struct`や`View`内で`self`を直接変更しようとした場合に発生します。

### 解決方法
- `@State`や`@Binding`を使用して状態を管理する。

```swift
struct ContentView: View {
    @State private var count = 0

    var body: some View {
        Button("カウント: \(count)") {
            count += 1
        }
    }
}
```

---

## 8. `PreviewProvider`エラー
### 意味
Xcodeのプレビューが正しく表示されない場合に発生します。

### 解決方法
- プレビュー用のコードが正しいか確認する。
- Xcodeを再起動する。
- 必要に応じてクリーンビルドを行う。

```swift
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
```

---

## 9. `Ambiguous use of 'X'`
### 意味
コンパイラが使用するべき関数やプロパティを特定できない場合に発生します。

### 解決方法
- 明示的に型を指定する。

```swift
let value: Double = 42
```

---

## 10. その他のエラー
- **ビルドエラー**: 必要なライブラリやフレームワークがリンクされていない。
- **ランタイムエラー**: 実行時に発生するエラー。デバッグコンソールで詳細を確認する。

---

## 11. `Closure containing control flow statement cannot be used with function builder 'ViewBuilder'`
### 意味
SwiftUIのView内で`if`や`for`などの制御構文を直接使用すると、`ViewBuilder`の制約によりエラーが発生します。

### 解決方法
- `if`や`for`を使用する場合は、条件に応じて異なるViewを返すように記述します。
- `Group`や`@ViewBuilder`を活用して複数のViewをまとめることができます。

#### 修正例
```swift
struct ContentView: View {
    let items = ["Apple", "Banana", "Orange"]
    var showList = true

    var body: some View {
        VStack {
            if showList {
                ForEach(items, id: \ .self) { item in
                    Text(item)
                }
            } else {
                Text("リストは非表示です")
            }
        }
    }
}
```

---

## 参考
- [Apple公式ドキュメント](https://developer.apple.com/documentation/swiftui/)
- [Swiftエラーリファレンス](https://developer.apple.com/documentation/swift/errors)

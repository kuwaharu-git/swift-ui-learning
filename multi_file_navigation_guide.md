# SwiftUIで複数ファイル・複数画面構成の基本

SwiftUIで複数の画面（View）を複数ファイルに分割し、画面間を移動できるようにする方法について解説します。

## 目次
1. プロジェクト構成例
2. 画面（View）ファイルの作成方法
3. 画面間の移動（Navigation）の実装
4. サンプルコード
5. ベストプラクティス

---

## 1. プロジェクト構成例

SwiftUIでは、各画面ごとにViewファイルを分割することで、保守性・可読性が向上します。

```
MyApp/
├── ContentView.swift      // 最初に表示される画面
├── HomeView.swift         // ホーム画面
├── DetailView.swift       // 詳細画面
├── SettingsView.swift     // 設定画面
└── ...
```

---

## 2. 画面（View）ファイルの作成方法

例えば、`HomeView.swift` というファイルを作成し、以下のように記述します。

```swift
import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Text("ホーム画面")
                .font(.largeTitle)
            // ...
        }
    }
}
```

---

## 3. 画面間の移動（Navigation）の実装

SwiftUIでは、`NavigationView` と `NavigationLink` を使って画面間を移動できます。

### 例: ContentViewからHomeView・DetailViewへ遷移

```swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                NavigationLink("ホームへ", destination: HomeView())
                NavigationLink("詳細へ", destination: DetailView())
            }
            .navigationTitle("メイン画面")
        }
    }
}
```

---

## 4. サンプルコード

### DetailView.swift
```swift
import SwiftUI

struct DetailView: View {
    var body: some View {
        VStack {
            Text("詳細画面")
                .font(.title)
            // ...
        }
    }
}
```

### SettingsView.swift
```swift
import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            Text("設定画面")
                .font(.title)
            // ...
        }
    }
}
```

---

## 5. ベストプラクティス

- 各画面ごとにViewファイルを分割する
- 画面遷移は `NavigationView` と `NavigationLink` を使う
- 複数画面間でデータを受け渡す場合は、`@State`、`@Binding`、`@ObservableObject`、`@EnvironmentObject` などを活用する
- 画面ごとに責任を分離し、役割を明確にする

---

## まとめ

SwiftUIでは、
- 各画面を個別のViewファイルとして作成
- `NavigationView` と `NavigationLink` で画面間を移動
- 必要に応じてデータ受け渡しの仕組みを追加

これにより、拡張性・保守性の高いアプリを構築できます。

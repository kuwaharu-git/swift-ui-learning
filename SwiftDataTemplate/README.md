## SwiftDataTemplate 各ファイルの役割と編集ポイント

| ファイル名                | 役割・編集ポイント                                                                 |
|--------------------------|----------------------------------------------------------------------------------|
| AddBookView.swift        | 本の追加画面。フォーム項目やバリデーション、追加処理のUI/ロジックを編集できます。 |
| BookView.swift           | 本一覧表示画面。リスト表示や並び順、詳細表示への遷移などを編集できます。         |
| EditBookView.swift       | 本の編集画面。編集フォームや保存処理、バリデーションを編集できます。             |
| ContentView.swift        | アプリのメイン画面。画面遷移やツールバー、全体のUI構成を編集できます。           |
| MyBooksApp.swift         | アプリのエントリーポイント。モデルコンテナの設定や起動時の画面を編集できます。   |
| Book.swift               | データモデル。Bookのプロパティ追加や初期化処理、@Model属性の調整が可能です。     |
| document.md              | テンプレートの概要や使い方を記載。自分用のメモや補足説明を追加できます。         |
| TestData.csv             | サンプルデータ。初期データやテスト用データを編集できます。                      |
| Assets.xcassets           | 画像やアイコンなどのアセット管理。必要な画像を追加・編集できます。              |
| AppIcon.appiconset        | アプリアイコンセット。アイコン画像を差し替えできます。                          |

---
この表を参考に、目的に応じて各ファイルを編集してください。UIやデータ構造の変更、機能追加も柔軟に行えます。
## SwiftDataの使い方

SwiftDataは、SwiftUIアプリでデータの永続化（保存・取得・更新・削除）を簡単に行うためのフレームワークです。

### 1. モデルの定義
@Model 属性を使ってデータモデル（例：Book）を定義します。

```swift
import SwiftData

@Model
class Book: Identifiable {
	var id: UUID
	var title: String
	var author: String
	// ...
}
```

### 2. モデルコンテナのセットアップ
アプリのエントリーポイント（App構造体）で `.modelContainer(for:)` を使い、モデルを永続化します。

```swift
@main
struct MyBooksApp: App {
	var body: some Scene {
		WindowGroup {
			ContentView()
				.modelContainer(for: Book.self)
		}
	}
}
```

### 3. データの追加
`@Environment(\.modelContext)` でモデルコンテキストを取得し、`insert` で新規データを追加します。

```swift
@Environment(\.modelContext) private var modelContext
let newBook = Book(title: "タイトル", author: "著者")
modelContext.insert(newBook)
```

### 4. データの取得
`@Query` プロパティラッパーでモデルの一覧を取得できます。

```swift
@Query var books: [Book]
```

### 5. データの編集・保存
編集後、`modelContext.save()` で変更を保存します。

```swift
modelContext.save()
```

### 6. データの削除
`modelContext.delete(オブジェクト)` で削除できます。

```swift
modelContext.delete(book)
```

---
これらの基本操作を組み合わせることで、SwiftUIアプリで直感的にデータベース管理が可能です。
# swift-ui-learning

SwiftUIの学習用リポジトリです。

## ドキュメント

- [Swift Data データ保存テンプレート](./SwiftDataTemplate.md) - Swift Dataを用いたデータ保存方法の包括的なガイド

## SwiftDataTemplate 解説

SwiftDataTemplate は SwiftUI + SwiftData を使ったシンプルな本管理アプリのテンプレートです。

### 構成ファイル
- AddBookView.swift: 本の追加画面。タイトル・著者を入力して新しい本を追加できます。
- BookView.swift: 登録された本の一覧を表示します。
- EditBookView.swift: 本の情報（タイトル・著者）を編集できます。
- ContentView.swift: アプリのメイン画面。BookView へのナビゲーションや追加ボタンを持ちます。
- MyBooksApp.swift: アプリのエントリーポイント。SwiftData のモデルコンテナをセットアップします。
- Book.swift: SwiftData の @Model 属性を使った本データモデルです。
- document.md: テンプレートの概要や使い方を記載したドキュメントです。
- TestData.csv: サンプルデータ（タイトル・著者）を CSV 形式で格納しています。
- Assets.xcassets: 画像やアイコンなどのアセット管理用フォルダです。
- AppIcon.appiconset: アプリアイコンセット。

### 特徴
- SwiftData の @Model 属性を使い、データベースの永続化が簡単に行えます。
- 追加・編集・一覧表示の基本的な CRUD 操作が揃っています。
- サンプルデータやアセットも含まれているため、すぐに動作確認やカスタマイズが可能です。

### 使い方
1. SwiftDataTemplate フォルダを Xcode プロジェクトとして開きます。
2. 必要に応じて Book モデルや画面をカスタマイズしてください。
3. SwiftData の機能を活用し、独自のデータ管理アプリを作成できます。

---


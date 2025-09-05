# SwiftDataTemplate

このテンプレートは、SwiftUI + SwiftData を使ったシンプルな本管理アプリのサンプルです。

## 構成ファイル
- AddBookView.swift: 本の追加画面
- BookView.swift: 本一覧表示画面
- EditBookView.swift: 本の編集画面
- ContentView.swift: ルート画面
- MyBooksApp.swift: アプリのエントリーポイント
- Book.swift: SwiftDataモデル
- Assets.xcassets: アセット管理
- TestData.csv: サンプルデータ

## SwiftDataの利用
Bookモデルは @Model 属性で宣言され、SwiftDataの永続化機能を利用しています。

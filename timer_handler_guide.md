# SwiftUI タイマーハンドラー解説書

## 概要
SwiftUIでタイマーを使う場合、`Timer` クラスを利用して一定間隔で処理を実行できます。タイマーは、カウントダウンや定期的な更新など、様々な用途に活用できます。

## 基本構成
- `@State var timerHandler: Timer?` : タイマーのインスタンスを保持
- `@State var count = 0` : カウント用の変数
- `@AppStorage("timer_value") var timerValue: Int = 10` : タイマーの秒数（ユーザー設定可能）
- `@State var isShowAlert: Bool = false` : 終了時のアラート表示用

## 具体例
```swift
import SwiftUI

struct ContentView: View {
    @State var timerHandler: Timer?
    @State var count = 0
    @AppStorage("timer_value") var timerValue: Int = 10
    @State var isShowAlert: Bool = false

    var body: some View {
        VStack {
            Text("残り\(timerValue - count)秒")
            HStack {
                Button("スタート") { startTimer() }
                Button("ストップ") { stopTimer() }
            }
        }
        .alert("終了", isPresented: $isShowAlert) {
            Button("OK") {}
        } message: {
            Text("タイマー終了時間です")
        }
    }

    func countDownTimer() {
        count += 1
        if timerValue - count <= 0 {
            timerHandler?.invalidate()
            isShowAlert = true
        }
    }

    func startTimer() {
        if let timerHandler, timerHandler.isValid { return }
        if timerValue - count <= 0 { count = 0 }
        timerHandler = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            Task { @MainActor in countDownTimer() }
        }
    }

    func stopTimer() {
        if let timerHandler, timerHandler.isValid {
            timerHandler.invalidate()
        }
    }
}
```

## ポイント解説
- `Timer.scheduledTimer` で1秒ごとに `countDownTimer()` を呼び出す
- タイマー終了時は `invalidate()` で停止し、アラートを表示
- スタート・ストップボタンでタイマーの制御
- `@AppStorage` で秒数をユーザー設定可能

## 応用例
- 繰り返し処理やアニメーションの制御
- 一定時間後の自動処理
- 残り時間の表示や進捗バー連動

---
このガイドを参考に、タイマー機能を自由にカスタマイズしてください。

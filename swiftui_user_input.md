# SwiftUI ユーザー入力コンポーネント完全ガイド

SwiftUIでユーザーからの入力を受け取るための基本的なコンポーネントと実装方法を網羅的に説明します。

## 目次
1. [TextField - テキスト入力](#textfield---テキスト入力)
2. [Toggle - チェックボックス](#toggle---チェックボックス)
3. [Picker - ラジオボタン・ドロップダウン](#picker---ラジオボタンドロップダウン)
4. [DatePicker - 日付選択](#datepicker---日付選択)
5. [Slider - スライダー](#slider---スライダー)
6. [Stepper - ステッパー](#stepper---ステッパー)
7. [実践的な使用例](#実践的な使用例)

---

## TextField - テキスト入力

TextFieldは最も基本的なテキスト入力コンポーネントです。

### 基本的な使い方
```swift
import SwiftUI

struct BasicTextFieldExample: View {
    @State private var text = ""
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("名前を入力してください", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Text("入力された内容: \(text)")
        }
        .padding()
    }
}
```

### パスワード入力
```swift
struct PasswordFieldExample: View {
    @State private var password = ""
    
    var body: some View {
        SecureField("パスワード", text: $password)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
    }
}
```

### 数値入力
```swift
struct NumberInputExample: View {
    @State private var numberText = ""
    @State private var number: Double = 0
    
    var body: some View {
        VStack {
            TextField("数値を入力", text: $numberText)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: numberText) { newValue in
                    number = Double(newValue) ?? 0
                }
            
            Text("数値: \(number, specifier: "%.2f")")
        }
        .padding()
    }
}
```

### テキストフィールドのカスタマイズ
```swift
struct CustomTextFieldExample: View {
    @State private var email = ""
    
    var body: some View {
        TextField("メールアドレス", text: $email)
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .padding(12)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.blue, lineWidth: 1)
            )
            .padding()
    }
}
```

---

## Toggle - チェックボックス

Toggleはオン/オフの状態を表現するコンポーネントです。

### 基本的なToggle
```swift
struct BasicToggleExample: View {
    @State private var isOn = false
    
    var body: some View {
        VStack {
            Toggle("通知を受け取る", isOn: $isOn)
                .padding()
            
            Text("通知設定: \(isOn ? "オン" : "オフ")")
        }
    }
}
```

### 複数のToggle（チェックボックスリスト）
```swift
struct MultipleToggleExample: View {
    @State private var notifications = true
    @State private var darkMode = false
    @State private var autoSave = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("設定")
                .font(.title2)
                .bold()
            
            Toggle("プッシュ通知", isOn: $notifications)
            Toggle("ダークモード", isOn: $darkMode)
            Toggle("自動保存", isOn: $autoSave)
            
            Divider()
            
            Text("設定状況:")
                .font(.headline)
            Text("通知: \(notifications ? "有効" : "無効")")
            Text("ダークモード: \(darkMode ? "有効" : "無効")")
            Text("自動保存: \(autoSave ? "有効" : "無効")")
        }
        .padding()
    }
}
```

### カスタムToggleスタイル
```swift
struct CustomToggleExample: View {
    @State private var isAccepted = false
    
    var body: some View {
        Toggle("利用規約に同意する", isOn: $isAccepted)
            .toggleStyle(CheckboxToggleStyle())
            .padding()
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .foregroundColor(configuration.isOn ? .blue : .gray)
                .font(.system(size: 20))
                .onTapGesture {
                    configuration.isOn.toggle()
                }
            
            configuration.label
        }
    }
}
```

---

## Picker - ラジオボタン・ドロップダウン

Pickerは複数の選択肢から一つを選ぶためのコンポーネントです。

### セグメントスタイル（ラジオボタン風）
```swift
struct SegmentedPickerExample: View {
    @State private var selectedTransport = "車"
    let transportOptions = ["車", "電車", "バス", "徒歩"]
    
    var body: some View {
        VStack {
            Text("交通手段を選択")
                .font(.headline)
            
            Picker("交通手段", selection: $selectedTransport) {
                ForEach(transportOptions, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            Text("選択された交通手段: \(selectedTransport)")
                .padding(.top)
        }
        .padding()
    }
}
```

### ホイールスタイル（ドロップダウン風）
```swift
struct WheelPickerExample: View {
    @State private var selectedAge = 25
    let ages = Array(18...80)
    
    var body: some View {
        VStack {
            Text("年齢を選択")
                .font(.headline)
            
            Picker("年齢", selection: $selectedAge) {
                ForEach(ages, id: \.self) { age in
                    Text("\(age)歳").tag(age)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(height: 150)
            
            Text("選択された年齢: \(selectedAge)歳")
        }
        .padding()
    }
}
```

### メニュースタイル（ドロップダウン）
```swift
struct MenuPickerExample: View {
    @State private var selectedCategory = "技術書"
    let categories = ["技術書", "小説", "ビジネス", "自己啓発", "料理", "旅行"]
    
    var body: some View {
        VStack {
            Text("カテゴリを選択")
                .font(.headline)
            
            Picker("カテゴリ", selection: $selectedCategory) {
                ForEach(categories, id: \.self) { category in
                    Text(category).tag(category)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            
            Text("選択されたカテゴリ: \(selectedCategory)")
                .padding(.top)
        }
        .padding()
    }
}
```

### カスタムラジオボタン
```swift
struct CustomRadioButtonExample: View {
    @State private var selectedPlan = "Basic"
    let plans = ["Basic", "Pro", "Enterprise"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("プランを選択")
                .font(.headline)
            
            ForEach(plans, id: \.self) { plan in
                RadioButton(
                    text: plan,
                    isSelected: selectedPlan == plan
                ) {
                    selectedPlan = plan
                }
            }
            
            Text("選択されたプラン: \(selectedPlan)")
                .padding(.top)
        }
        .padding()
    }
}

struct RadioButton: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                    .foregroundColor(isSelected ? .blue : .gray)
                Text(text)
                    .foregroundColor(.primary)
                Spacer()
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
```

---

## DatePicker - 日付選択

DatePickerは日付と時刻の選択に使用します。

### 基本的な日付選択
```swift
struct BasicDatePickerExample: View {
    @State private var selectedDate = Date()
    
    var body: some View {
        VStack {
            DatePicker("日付を選択", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
            
            Text("選択された日付: \(selectedDate, formatter: dateFormatter)")
                .padding(.top)
        }
        .padding()
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }
}
```

### 時刻選択
```swift
struct TimePickerExample: View {
    @State private var selectedTime = Date()
    
    var body: some View {
        VStack {
            DatePicker("時刻を選択", selection: $selectedTime, displayedComponents: .hourAndMinute)
                .datePickerStyle(WheelDatePickerStyle())
            
            Text("選択された時刻: \(selectedTime, formatter: timeFormatter)")
                .padding(.top)
        }
        .padding()
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }
}
```

### 日付範囲制限
```swift
struct DateRangePickerExample: View {
    @State private var selectedDate = Date()
    
    var body: some View {
        VStack {
            DatePicker(
                "予約日を選択",
                selection: $selectedDate,
                in: Date()...Calendar.current.date(byAdding: .month, value: 3, to: Date())!,
                displayedComponents: .date
            )
            .datePickerStyle(CompactDatePickerStyle())
            
            Text("予約日: \(selectedDate, formatter: dateFormatter)")
                .padding(.top)
        }
        .padding()
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }
}
```

---

## Slider - スライダー

Sliderは数値の範囲選択に使用します。

### 基本的なSlider
```swift
struct BasicSliderExample: View {
    @State private var volume: Double = 50
    
    var body: some View {
        VStack {
            Text("音量: \(Int(volume))")
                .font(.headline)
            
            Slider(value: $volume, in: 0...100, step: 1)
                .padding()
            
            HStack {
                Text("0")
                Spacer()
                Text("100")
            }
            .font(.caption)
            .padding(.horizontal)
        }
        .padding()
    }
}
```

### カスタマイズされたSlider
```swift
struct CustomSliderExample: View {
    @State private var brightness: Double = 0.5
    
    var body: some View {
        VStack {
            Text("画面の明るさ")
                .font(.headline)
            
            HStack {
                Image(systemName: "sun.min")
                
                Slider(value: $brightness, in: 0...1)
                    .accentColor(.yellow)
                
                Image(systemName: "sun.max.fill")
            }
            .padding()
            
            Text("明るさ: \(Int(brightness * 100))%")
                .font(.caption)
        }
        .padding()
    }
}
```

---

## Stepper - ステッパー

Stepperは値の増減に使用します。

### 基本的なStepper
```swift
struct BasicStepperExample: View {
    @State private var quantity = 1
    
    var body: some View {
        VStack {
            Stepper("数量: \(quantity)", value: $quantity, in: 1...10)
                .padding()
            
            Text("合計金額: ¥\(quantity * 1000)")
                .font(.headline)
        }
        .padding()
    }
}
```

### カスタムStepper
```swift
struct CustomStepperExample: View {
    @State private var temperature: Double = 20.0
    
    var body: some View {
        VStack {
            Text("エアコン温度設定")
                .font(.headline)
            
            HStack {
                Button(action: { temperature -= 0.5 }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                }
                .disabled(temperature <= 16.0)
                
                Text("\(temperature, specifier: "%.1f")°C")
                    .font(.title2)
                    .frame(width: 80)
                
                Button(action: { temperature += 0.5 }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .foregroundColor(.red)
                }
                .disabled(temperature >= 30.0)
            }
            
            Text("設定範囲: 16.0°C - 30.0°C")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
    }
}
```

---

## 実践的な使用例

すべての入力コンポーネントを組み合わせた実用的なフォーム例です。

### ユーザー登録フォーム
```swift
struct UserRegistrationForm: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var age = 25
    @State private var gender = "選択してください"
    @State private var birthDate = Date()
    @State private var agreeToTerms = false
    @State private var notificationEnabled = true
    @State private var experience: Double = 1
    
    let genderOptions = ["選択してください", "男性", "女性", "その他", "回答しない"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("基本情報")) {
                    TextField("氏名", text: $name)
                    TextField("メールアドレス", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    SecureField("パスワード", text: $password)
                }
                
                Section(header: Text("詳細情報")) {
                    Stepper("年齢: \(age)", value: $age, in: 13...100)
                    
                    Picker("性別", selection: $gender) {
                        ForEach(genderOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    
                    DatePicker("生年月日", selection: $birthDate, displayedComponents: .date)
                    
                    VStack(alignment: .leading) {
                        Text("経験年数: \(Int(experience))年")
                        Slider(value: $experience, in: 0...20, step: 1)
                    }
                }
                
                Section(header: Text("設定")) {
                    Toggle("利用規約に同意する", isOn: $agreeToTerms)
                    Toggle("通知を受け取る", isOn: $notificationEnabled)
                }
                
                Section {
                    Button("登録") {
                        registerUser()
                    }
                    .disabled(!isFormValid)
                }
            }
            .navigationTitle("ユーザー登録")
        }
    }
    
    private var isFormValid: Bool {
        !name.isEmpty && !email.isEmpty && !password.isEmpty && 
        gender != "選択してください" && agreeToTerms
    }
    
    private func registerUser() {
        // 登録処理をここに実装
        print("ユーザー登録: \(name), \(email)")
    }
}
```

---

## まとめ

SwiftUIの入力コンポーネントを効果的に使うためのポイント:

1. **@State**を使って入力値の状態を管理する
2. **$バインディング**を使って双方向データバインディングを実現する
3. 適切な**キーボードタイプ**と**入力制限**を設定する
4. **バリデーション**を実装してユーザビリティを向上させる
5. **アクセシビリティ**を考慮したラベルと説明を追加する

これらのコンポーネントを組み合わせることで、直感的で使いやすいユーザーインターフェースを構築できます。

---

## 参考リンク

- [Apple公式 - TextField](https://developer.apple.com/documentation/swiftui/textfield)
- [Apple公式 - Toggle](https://developer.apple.com/documentation/swiftui/toggle)
- [Apple公式 - Picker](https://developer.apple.com/documentation/swiftui/picker)
- [Apple公式 - DatePicker](https://developer.apple.com/documentation/swiftui/datepicker)
- [Apple公式 - Slider](https://developer.apple.com/documentation/swiftui/slider)
- [Apple公式 - Stepper](https://developer.apple.com/documentation/swiftui/stepper)
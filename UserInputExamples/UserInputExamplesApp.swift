import SwiftUI

// MARK: - Main App
@main
struct UserInputExamplesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// MARK: - Content View (Main Navigation)
struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                Section("基本的な入力コンポーネント") {
                    NavigationLink("TextField - テキスト入力", destination: TextFieldExamplesView())
                    NavigationLink("Toggle - チェックボックス", destination: ToggleExamplesView())
                    NavigationLink("Picker - 選択メニュー", destination: PickerExamplesView())
                }
                
                Section("高度な入力コンポーネント") {
                    NavigationLink("DatePicker - 日付選択", destination: DatePickerExamplesView())
                    NavigationLink("Slider - スライダー", destination: SliderExamplesView())
                    NavigationLink("Stepper - ステッパー", destination: StepperExamplesView())
                }
                
                Section("実践例") {
                    NavigationLink("ユーザー登録フォーム", destination: UserRegistrationForm())
                    NavigationLink("設定画面", destination: SettingsView())
                }
            }
            .navigationTitle("SwiftUI 入力コンポーネント")
        }
    }
}

// MARK: - TextField Examples
struct TextFieldExamplesView: View {
    @State private var basicText = ""
    @State private var password = ""
    @State private var email = ""
    @State private var numberText = ""
    @State private var multilineText = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                Group {
                    Text("基本的なTextField")
                        .font(.headline)
                    TextField("名前を入力してください", text: $basicText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Text("入力内容: \(basicText)")
                        .foregroundColor(.gray)
                }
                
                Divider()
                
                Group {
                    Text("パスワード入力")
                        .font(.headline)
                    SecureField("パスワード", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Divider()
                
                Group {
                    Text("メールアドレス入力")
                        .font(.headline)
                    TextField("メールアドレス", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Divider()
                
                Group {
                    Text("数値入力")
                        .font(.headline)
                    TextField("数値を入力", text: $numberText)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Divider()
                
                Group {
                    Text("複数行テキスト")
                        .font(.headline)
                    TextEditor(text: $multilineText)
                        .frame(height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                }
            }
            .padding()
        }
        .navigationTitle("TextField Examples")
    }
}

// MARK: - Toggle Examples
struct ToggleExamplesView: View {
    @State private var basicToggle = false
    @State private var notifications = true
    @State private var darkMode = false
    @State private var autoSave = true
    @State private var agreeToTerms = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                Group {
                    Text("基本的なToggle")
                        .font(.headline)
                    Toggle("通知を受け取る", isOn: $basicToggle)
                    Text("状態: \(basicToggle ? "オン" : "オフ")")
                        .foregroundColor(.gray)
                }
                
                Divider()
                
                Group {
                    Text("設定メニュー風Toggle")
                        .font(.headline)
                    VStack(alignment: .leading, spacing: 10) {
                        Toggle("プッシュ通知", isOn: $notifications)
                        Toggle("ダークモード", isOn: $darkMode)
                        Toggle("自動保存", isOn: $autoSave)
                    }
                }
                
                Divider()
                
                Group {
                    Text("カスタムToggle（チェックボックス風）")
                        .font(.headline)
                    Toggle("利用規約に同意する", isOn: $agreeToTerms)
                        .toggleStyle(CheckboxToggleStyle())
                }
            }
            .padding()
        }
        .navigationTitle("Toggle Examples")
    }
}

// カスタムToggleスタイル
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

// MARK: - Picker Examples
struct PickerExamplesView: View {
    @State private var selectedTransport = "車"
    @State private var selectedAge = 25
    @State private var selectedCategory = "技術書"
    @State private var selectedPlan = "Basic"
    
    let transportOptions = ["車", "電車", "バス", "徒歩"]
    let ages = Array(18...80)
    let categories = ["技術書", "小説", "ビジネス", "自己啓発", "料理", "旅行"]
    let plans = ["Basic", "Pro", "Enterprise"]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                Group {
                    Text("セグメントスタイル（ラジオボタン風）")
                        .font(.headline)
                    Picker("交通手段", selection: $selectedTransport) {
                        ForEach(transportOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    Text("選択: \(selectedTransport)")
                        .foregroundColor(.gray)
                }
                
                Divider()
                
                Group {
                    Text("ホイールスタイル")
                        .font(.headline)
                    Picker("年齢", selection: $selectedAge) {
                        ForEach(ages, id: \.self) { age in
                            Text("\(age)歳").tag(age)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 120)
                    Text("選択: \(selectedAge)歳")
                        .foregroundColor(.gray)
                }
                
                Divider()
                
                Group {
                    Text("メニュースタイル（ドロップダウン）")
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
                    Text("選択: \(selectedCategory)")
                        .foregroundColor(.gray)
                }
                
                Divider()
                
                Group {
                    Text("カスタムラジオボタン")
                        .font(.headline)
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(plans, id: \.self) { plan in
                            RadioButton(
                                text: plan,
                                isSelected: selectedPlan == plan
                            ) {
                                selectedPlan = plan
                            }
                        }
                    }
                    Text("選択: \(selectedPlan)")
                        .foregroundColor(.gray)
                }
            }
            .padding()
        }
        .navigationTitle("Picker Examples")
    }
}

// カスタムラジオボタン
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

// MARK: - DatePicker Examples
struct DatePickerExamplesView: View {
    @State private var selectedDate = Date()
    @State private var selectedTime = Date()
    @State private var reservationDate = Date()
    @State private var birthDate = Calendar.current.date(byAdding: .year, value: -25, to: Date()) ?? Date()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                Group {
                    Text("基本的な日付選択")
                        .font(.headline)
                    DatePicker("日付を選択", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                    Text("選択: \(selectedDate, formatter: dateFormatter)")
                        .foregroundColor(.gray)
                }
                
                Divider()
                
                Group {
                    Text("時刻選択")
                        .font(.headline)
                    DatePicker("時刻を選択", selection: $selectedTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(WheelDatePickerStyle())
                    Text("選択: \(selectedTime, formatter: timeFormatter)")
                        .foregroundColor(.gray)
                }
                
                Divider()
                
                Group {
                    Text("日付範囲制限（今日から3ヶ月後まで）")
                        .font(.headline)
                    DatePicker(
                        "予約日",
                        selection: $reservationDate,
                        in: Date()...Calendar.current.date(byAdding: .month, value: 3, to: Date())!,
                        displayedComponents: .date
                    )
                    .datePickerStyle(CompactDatePickerStyle())
                    Text("予約日: \(reservationDate, formatter: dateFormatter)")
                        .foregroundColor(.gray)
                }
                
                Divider()
                
                Group {
                    Text("生年月日（過去の日付のみ）")
                        .font(.headline)
                    DatePicker(
                        "生年月日",
                        selection: $birthDate,
                        in: ...Date(),
                        displayedComponents: .date
                    )
                    .datePickerStyle(CompactDatePickerStyle())
                    Text("生年月日: \(birthDate, formatter: dateFormatter)")
                        .foregroundColor(.gray)
                }
            }
            .padding()
        }
        .navigationTitle("DatePicker Examples")
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }
}

// MARK: - Slider Examples
struct SliderExamplesView: View {
    @State private var volume: Double = 50
    @State private var brightness: Double = 0.5
    @State private var temperature: Double = 22.0
    @State private var price: Double = 1000
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                
                Group {
                    Text("基本的なSlider")
                        .font(.headline)
                    VStack {
                        Text("音量: \(Int(volume))")
                        Slider(value: $volume, in: 0...100, step: 1)
                        HStack {
                            Text("0")
                            Spacer()
                            Text("100")
                        }
                        .font(.caption)
                        .foregroundColor(.gray)
                    }
                }
                
                Divider()
                
                Group {
                    Text("カスタマイズされたSlider")
                        .font(.headline)
                    VStack {
                        Text("画面の明るさ")
                        HStack {
                            Image(systemName: "sun.min")
                            Slider(value: $brightness, in: 0...1)
                                .accentColor(.yellow)
                            Image(systemName: "sun.max.fill")
                        }
                        Text("明るさ: \(Int(brightness * 100))%")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                Divider()
                
                Group {
                    Text("温度設定Slider")
                        .font(.headline)
                    VStack {
                        Text("エアコン温度: \(temperature, specifier: "%.1f")°C")
                        Slider(value: $temperature, in: 16...30, step: 0.5)
                            .accentColor(temperature < 20 ? .blue : temperature > 25 ? .red : .green)
                        HStack {
                            Text("16°C")
                            Spacer()
                            Text("30°C")
                        }
                        .font(.caption)
                        .foregroundColor(.gray)
                    }
                }
                
                Divider()
                
                Group {
                    Text("価格範囲Slider")
                        .font(.headline)
                    VStack {
                        Text("予算: ¥\(Int(price))")
                        Slider(value: $price, in: 100...10000, step: 100)
                            .accentColor(.green)
                        HStack {
                            Text("¥100")
                            Spacer()
                            Text("¥10,000")
                        }
                        .font(.caption)
                        .foregroundColor(.gray)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Slider Examples")
    }
}

// MARK: - Stepper Examples
struct StepperExamplesView: View {
    @State private var quantity = 1
    @State private var temperature: Double = 20.0
    @State private var fontSize: Double = 16
    @State private var participants = 2
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                
                Group {
                    Text("基本的なStepper")
                        .font(.headline)
                    VStack(alignment: .leading) {
                        Stepper("数量: \(quantity)", value: $quantity, in: 1...10)
                        Text("単価: ¥1,000")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("合計: ¥\(quantity * 1000)")
                            .font(.title2)
                            .bold()
                    }
                }
                
                Divider()
                
                Group {
                    Text("カスタムStepper（温度設定）")
                        .font(.headline)
                    VStack {
                        Text("エアコン温度設定")
                            .font(.subheadline)
                        
                        HStack {
                            Button(action: { 
                                if temperature > 16.0 {
                                    temperature -= 0.5
                                }
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.blue)
                            }
                            .disabled(temperature <= 16.0)
                            
                            Text("\(temperature, specifier: "%.1f")°C")
                                .font(.title2)
                                .frame(width: 80)
                            
                            Button(action: { 
                                if temperature < 30.0 {
                                    temperature += 0.5
                                }
                            }) {
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
                }
                
                Divider()
                
                Group {
                    Text("フォントサイズStepper")
                        .font(.headline)
                    VStack {
                        Stepper("フォントサイズ: \(Int(fontSize))", value: $fontSize, in: 12...24, step: 2)
                        Text("これがサンプルテキストです")
                            .font(.system(size: fontSize))
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
                
                Divider()
                
                Group {
                    Text("参加者数Stepper")
                        .font(.headline)
                    VStack(alignment: .leading) {
                        Stepper("参加者数: \(participants)名", value: $participants, in: 1...20)
                        Text("1人あたり: ¥2,500")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("総額: ¥\(participants * 2500)")
                            .font(.title3)
                            .bold()
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Stepper Examples")
    }
}

// MARK: - User Registration Form
struct UserRegistrationForm: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var age = 25
    @State private var gender = "選択してください"
    @State private var birthDate = Date()
    @State private var agreeToTerms = false
    @State private var notificationEnabled = true
    @State private var experience: Double = 1
    @State private var interests: Set<String> = []
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    let genderOptions = ["選択してください", "男性", "女性", "その他", "回答しない"]
    let interestOptions = ["プログラミング", "デザイン", "マーケティング", "データ分析", "AI・機械学習", "セキュリティ"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("基本情報")) {
                    TextField("氏名", text: $name)
                    TextField("メールアドレス", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    SecureField("パスワード", text: $password)
                    SecureField("パスワード確認", text: $confirmPassword)
                        .foregroundColor(passwordsMatch ? .primary : .red)
                }
                
                Section(header: Text("詳細情報")) {
                    Stepper("年齢: \(age)", value: $age, in: 13...100)
                    
                    Picker("性別", selection: $gender) {
                        ForEach(genderOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    
                    DatePicker("生年月日", selection: $birthDate, in: ...Date(), displayedComponents: .date)
                    
                    VStack(alignment: .leading) {
                        Text("プログラミング経験: \(Int(experience))年")
                        Slider(value: $experience, in: 0...20, step: 1)
                    }
                }
                
                Section(header: Text("興味のある分野")) {
                    ForEach(interestOptions, id: \.self) { interest in
                        Toggle(interest, isOn: Binding(
                            get: { interests.contains(interest) },
                            set: { isOn in
                                if isOn {
                                    interests.insert(interest)
                                } else {
                                    interests.remove(interest)
                                }
                            }
                        ))
                    }
                }
                
                Section(header: Text("設定")) {
                    Toggle("利用規約に同意する", isOn: $agreeToTerms)
                        .toggleStyle(CheckboxToggleStyle())
                    Toggle("通知を受け取る", isOn: $notificationEnabled)
                }
                
                Section {
                    Button("登録") {
                        registerUser()
                    }
                    .disabled(!isFormValid)
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("ユーザー登録")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("登録結果"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private var passwordsMatch: Bool {
        password == confirmPassword || confirmPassword.isEmpty
    }
    
    private var isFormValid: Bool {
        !name.isEmpty && 
        !email.isEmpty && 
        !password.isEmpty && 
        passwordsMatch &&
        gender != "選択してください" && 
        agreeToTerms
    }
    
    private func registerUser() {
        if isFormValid {
            alertMessage = """
            登録が完了しました！
            
            名前: \(name)
            メール: \(email)
            年齢: \(age)
            性別: \(gender)
            経験年数: \(Int(experience))年
            興味分野: \(interests.joined(separator: ", "))
            通知設定: \(notificationEnabled ? "有効" : "無効")
            """
        } else {
            alertMessage = "入力内容に不備があります。"
        }
        showAlert = true
    }
}

// MARK: - Settings View
struct SettingsView: View {
    @State private var notificationsEnabled = true
    @State private var darkModeEnabled = false
    @State private var autoSaveEnabled = true
    @State private var soundEnabled = true
    @State private var language = "日本語"
    @State private var fontSize: Double = 16
    @State private var cacheSize: Double = 100
    @State private var updateFrequency = "毎日"
    
    let languages = ["日本語", "English", "中文", "한국어"]
    let updateOptions = ["リアルタイム", "毎時間", "毎日", "手動"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("通知設定")) {
                    Toggle("プッシュ通知", isOn: $notificationsEnabled)
                    Toggle("サウンド", isOn: $soundEnabled)
                        .disabled(!notificationsEnabled)
                }
                
                Section(header: Text("表示設定")) {
                    Toggle("ダークモード", isOn: $darkModeEnabled)
                    
                    VStack(alignment: .leading) {
                        Text("フォントサイズ: \(Int(fontSize))pt")
                        Slider(value: $fontSize, in: 12...24, step: 2)
                    }
                    
                    Picker("言語", selection: $language) {
                        ForEach(languages, id: \.self) { lang in
                            Text(lang).tag(lang)
                        }
                    }
                }
                
                Section(header: Text("データ設定")) {
                    Toggle("自動保存", isOn: $autoSaveEnabled)
                    
                    VStack(alignment: .leading) {
                        Text("キャッシュサイズ: \(Int(cacheSize))MB")
                        Slider(value: $cacheSize, in: 10...500, step: 10)
                        HStack {
                            Text("10MB")
                            Spacer()
                            Text("500MB")
                        }
                        .font(.caption)
                        .foregroundColor(.gray)
                    }
                    
                    Picker("更新頻度", selection: $updateFrequency) {
                        ForEach(updateOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("情報")) {
                    HStack {
                        Text("バージョン")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.gray)
                    }
                    
                    Button("キャッシュをクリア") {
                        // キャッシュクリア処理
                    }
                    .foregroundColor(.red)
                    
                    Button("設定をリセット") {
                        resetSettings()
                    }
                    .foregroundColor(.orange)
                }
            }
            .navigationTitle("設定")
        }
    }
    
    private func resetSettings() {
        notificationsEnabled = true
        darkModeEnabled = false
        autoSaveEnabled = true
        soundEnabled = true
        language = "日本語"
        fontSize = 16
        cacheSize = 100
        updateFrequency = "毎日"
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
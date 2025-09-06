import SwiftUI

// MARK: - Picker Examples
// ラジオボタン、ドロップダウンメニューなど選択コンポーネントのサンプルファイル

struct PickerExamplesApp: App {
    var body: some Scene {
        WindowGroup {
            PickerExamplesView()
        }
    }
}

struct PickerExamplesView: View {
    // MARK: - State Variables
    @State private var selectedTransport = "車"
    @State private var selectedAge = 25
    @State private var selectedCategory = "技術書"
    @State private var selectedPlan = "Basic"
    @State private var selectedColor = "青"
    @State private var selectedSize = "M"
    @State private var selectedCountry = "日本"
    @State private var selectedLanguage = "日本語"
    @State private var selectedPriority = Priority.medium
    @State private var selectedDifficulty = Difficulty.beginner
    
    // データ配列
    let transportOptions = ["車", "電車", "バス", "徒歩", "自転車", "バイク"]
    let ages = Array(18...80)
    let categories = ["技術書", "小説", "ビジネス", "自己啓発", "料理", "旅行", "アート", "歴史"]
    let plans = ["Basic", "Pro", "Enterprise"]
    let colors = ["赤", "青", "緑", "黄", "紫", "オレンジ", "ピンク", "黒", "白"]
    let sizes = ["XS", "S", "M", "L", "XL", "XXL"]
    let countries = ["日本", "アメリカ", "イギリス", "フランス", "ドイツ", "中国", "韓国", "オーストラリア"]
    let languages = ["日本語", "English", "中文", "한국어", "Français", "Deutsch", "Español"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    
                    // セグメントスタイル（ラジオボタン風）
                    ExampleSection(title: "セグメントスタイル（ラジオボタン風）") {
                        Text("交通手段を選択してください")
                            .font(.subheadline)
                        
                        Picker("交通手段", selection: $selectedTransport) {
                            ForEach(transportOptions.prefix(4), id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        ResultView(label: "選択された交通手段", value: selectedTransport, icon: transportIcon(selectedTransport))
                    }
                    
                    // ホイールスタイル
                    ExampleSection(title: "ホイールスタイル") {
                        Text("年齢を選択してください")
                            .font(.subheadline)
                        
                        Picker("年齢", selection: $selectedAge) {
                            ForEach(ages, id: \.self) { age in
                                Text("\(age)歳").tag(age)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(height: 120)
                        .clipped()
                        
                        ResultView(label: "選択された年齢", value: "\(selectedAge)歳", icon: "person.fill")
                    }
                    
                    // メニュースタイル（ドロップダウン）
                    ExampleSection(title: "メニュースタイル（ドロップダウン）") {
                        Text("カテゴリを選択してください")
                            .font(.subheadline)
                        
                        Picker("カテゴリ", selection: $selectedCategory) {
                            ForEach(categories, id: \.self) { category in
                                HStack {
                                    Image(systemName: categoryIcon(category))
                                    Text(category)
                                }
                                .tag(category)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        
                        ResultView(label: "選択されたカテゴリ", value: selectedCategory, icon: categoryIcon(selectedCategory))
                    }
                    
                    // カスタムラジオボタン
                    ExampleSection(title: "カスタムラジオボタン") {
                        Text("プランを選択してください")
                            .font(.subheadline)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(plans, id: \.self) { plan in
                                PlanRadioButton(
                                    plan: plan,
                                    isSelected: selectedPlan == plan
                                ) {
                                    selectedPlan = plan
                                }
                            }
                        }
                        
                        PlanSummaryView(selectedPlan: selectedPlan)
                    }
                    
                    // カラーピッカー風セレクター
                    ExampleSection(title: "カラーセレクター") {
                        Text("色を選択してください")
                            .font(.subheadline)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 10) {
                            ForEach(colors, id: \.self) { color in
                                ColorOption(
                                    color: color,
                                    isSelected: selectedColor == color
                                ) {
                                    selectedColor = color
                                }
                            }
                        }
                        
                        ResultView(label: "選択された色", value: selectedColor, icon: "paintpalette.fill")
                    }
                    
                    // サイズピッカー
                    ExampleSection(title: "サイズピッカー") {
                        Text("サイズを選択してください")
                            .font(.subheadline)
                        
                        HStack(spacing: 10) {
                            ForEach(sizes, id: \.self) { size in
                                SizeOption(
                                    size: size,
                                    isSelected: selectedSize == size
                                ) {
                                    selectedSize = size
                                }
                            }
                        }
                        
                        ResultView(label: "選択されたサイズ", value: selectedSize, icon: "tshirt.fill")
                    }
                    
                    // 国選択（検索機能付き）
                    ExampleSection(title: "国選択（インライン表示）") {
                        Picker("国を選択", selection: $selectedCountry) {
                            ForEach(countries, id: \.self) { country in
                                HStack {
                                    Text(countryFlag(country))
                                    Text(country)
                                }
                                .tag(country)
                            }
                        }
                        .pickerStyle(InlinePickerStyle())
                        
                        ResultView(label: "選択された国", value: selectedCountry, icon: "globe")
                    }
                    
                    // 列挙型を使ったピッカー
                    ExampleSection(title: "列挙型ピッカー（優先度）") {
                        Picker("優先度", selection: $selectedPriority) {
                            ForEach(Priority.allCases, id: \.self) { priority in
                                HStack {
                                    Image(systemName: priority.icon)
                                        .foregroundColor(priority.color)
                                    Text(priority.displayName)
                                }
                                .tag(priority)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        PriorityResultView(priority: selectedPriority)
                    }
                    
                    // 難易度ピッカー（カスタムスタイル）
                    ExampleSection(title: "難易度セレクター") {
                        Text("難易度を選択してください")
                            .font(.subheadline)
                        
                        VStack(spacing: 10) {
                            ForEach(Difficulty.allCases, id: \.self) { difficulty in
                                DifficultyOption(
                                    difficulty: difficulty,
                                    isSelected: selectedDifficulty == difficulty
                                ) {
                                    selectedDifficulty = difficulty
                                }
                            }
                        }
                        
                        DifficultyResultView(difficulty: selectedDifficulty)
                    }
                    
                    // 複数選択のシミュレーション
                    ExampleSection(title: "複数選択風ピッカー") {
                        MultiSelectLanguageView(selectedLanguages: $selectedLanguage)
                    }
                }
                .padding()
            }
            .navigationTitle("Picker Examples")
        }
    }
    
    // アイコン取得ヘルパー関数
    private func transportIcon(_ transport: String) -> String {
        switch transport {
        case "車": return "car.fill"
        case "電車": return "tram.fill"
        case "バス": return "bus.fill"
        case "徒歩": return "figure.walk"
        case "自転車": return "bicycle"
        case "バイク": return "motorcycle"
        default: return "questionmark"
        }
    }
    
    private func categoryIcon(_ category: String) -> String {
        switch category {
        case "技術書": return "laptopcomputer"
        case "小説": return "book.fill"
        case "ビジネス": return "briefcase.fill"
        case "自己啓発": return "brain.head.profile"
        case "料理": return "fork.knife"
        case "旅行": return "airplane"
        case "アート": return "paintbrush.fill"
        case "歴史": return "building.columns.fill"
        default: return "book"
        }
    }
    
    private func countryFlag(_ country: String) -> String {
        switch country {
        case "日本": return "🇯🇵"
        case "アメリカ": return "🇺🇸"
        case "イギリス": return "🇬🇧"
        case "フランス": return "🇫🇷"
        case "ドイツ": return "🇩🇪"
        case "中国": return "🇨🇳"
        case "韓国": return "🇰🇷"
        case "オーストラリア": return "🇦🇺"
        default: return "🌍"
        }
    }
}

// MARK: - Data Models

enum Priority: String, CaseIterable {
    case low = "low"
    case medium = "medium"
    case high = "high"
    
    var displayName: String {
        switch self {
        case .low: return "低"
        case .medium: return "中"
        case .high: return "高"
        }
    }
    
    var icon: String {
        switch self {
        case .low: return "arrow.down.circle"
        case .medium: return "minus.circle"
        case .high: return "arrow.up.circle"
        }
    }
    
    var color: Color {
        switch self {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }
}

enum Difficulty: String, CaseIterable {
    case beginner = "beginner"
    case intermediate = "intermediate"
    case advanced = "advanced"
    case expert = "expert"
    
    var displayName: String {
        switch self {
        case .beginner: return "初級"
        case .intermediate: return "中級"
        case .advanced: return "上級"
        case .expert: return "エキスパート"
        }
    }
    
    var description: String {
        switch self {
        case .beginner: return "基本的な知識があればOK"
        case .intermediate: return "ある程度の経験が必要"
        case .advanced: return "十分な経験と知識が必要"
        case .expert: return "専門的な知識が必要"
        }
    }
    
    var stars: Int {
        switch self {
        case .beginner: return 1
        case .intermediate: return 2
        case .advanced: return 3
        case .expert: return 4
        }
    }
}

// MARK: - Helper Views

struct ExampleSection<Content: View>: View {
    let title: String
    let content: () -> Content
    
    init(title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            content()
        }
    }
}

struct ResultView: View {
    let label: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
            Text("\(label): \(value)")
                .font(.caption)
                .foregroundColor(.gray)
            Spacer()
        }
        .padding(8)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(6)
    }
}

struct PlanRadioButton: View {
    let plan: String
    let isSelected: Bool
    let action: () -> Void
    
    private var planDetails: (price: String, features: [String]) {
        switch plan {
        case "Basic":
            return ("¥1,000/月", ["基本機能", "メールサポート"])
        case "Pro":
            return ("¥3,000/月", ["すべての機能", "優先サポート", "API利用"])
        case "Enterprise":
            return ("お問い合わせ", ["カスタム機能", "専任サポート", "SLA保証"])
        default:
            return ("", [])
        }
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                    .foregroundColor(isSelected ? .blue : .gray)
                    .font(.system(size: 20))
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(plan)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Text(planDetails.price)
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.blue)
                    }
                    
                    ForEach(planDetails.features, id: \.self) { feature in
                        Text("• \(feature)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
            }
            .padding()
            .background(isSelected ? Color.blue.opacity(0.1) : Color.gray.opacity(0.05))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3), lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct PlanSummaryView: View {
    let selectedPlan: String
    
    var body: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
            Text("選択されたプラン: \(selectedPlan)")
                .font(.caption)
                .bold()
            Spacer()
        }
        .padding(8)
        .background(Color.green.opacity(0.1))
        .cornerRadius(6)
    }
}

struct ColorOption: View {
    let color: String
    let isSelected: Bool
    let action: () -> Void
    
    private var swiftUIColor: Color {
        switch color {
        case "赤": return .red
        case "青": return .blue
        case "緑": return .green
        case "黄": return .yellow
        case "紫": return .purple
        case "オレンジ": return .orange
        case "ピンク": return .pink
        case "黒": return .black
        case "白": return .white
        default: return .gray
        }
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Circle()
                    .fill(swiftUIColor)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Circle()
                            .stroke(Color.primary, lineWidth: isSelected ? 3 : 1)
                    )
                    .overlay(
                        Image(systemName: "checkmark")
                            .foregroundColor(color == "白" || color == "黄" ? .black : .white)
                            .font(.system(size: 12, weight: .bold))
                            .opacity(isSelected ? 1 : 0)
                    )
                
                Text(color)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SizeOption: View {
    let size: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(size)
                .font(.headline)
                .foregroundColor(isSelected ? .white : .primary)
                .frame(width: 40, height: 40)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.2))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue, lineWidth: isSelected ? 2 : 1)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct PriorityResultView: View {
    let priority: Priority
    
    var body: some View {
        HStack {
            Image(systemName: priority.icon)
                .foregroundColor(priority.color)
            Text("優先度: \(priority.displayName)")
                .font(.caption)
                .bold()
            Spacer()
        }
        .padding(8)
        .background(priority.color.opacity(0.1))
        .cornerRadius(6)
    }
}

struct DifficultyOption: View {
    let difficulty: Difficulty
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(difficulty.displayName)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        HStack(spacing: 2) {
                            ForEach(1...4, id: \.self) { index in
                                Image(systemName: "star.fill")
                                    .foregroundColor(index <= difficulty.stars ? .orange : .gray.opacity(0.3))
                                    .font(.system(size: 12))
                            }
                        }
                    }
                    
                    Text(difficulty.description)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .blue : .gray)
                    .font(.system(size: 20))
            }
            .padding()
            .background(isSelected ? Color.blue.opacity(0.1) : Color.gray.opacity(0.05))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3), lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct DifficultyResultView: View {
    let difficulty: Difficulty
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("選択された難易度: \(difficulty.displayName)")
                    .font(.caption)
                    .bold()
                
                Spacer()
                
                HStack(spacing: 2) {
                    ForEach(1...4, id: \.self) { index in
                        Image(systemName: "star.fill")
                            .foregroundColor(index <= difficulty.stars ? .orange : .gray.opacity(0.3))
                            .font(.system(size: 10))
                    }
                }
            }
            
            Text(difficulty.description)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(8)
        .background(Color.orange.opacity(0.1))
        .cornerRadius(6)
    }
}

struct MultiSelectLanguageView: View {
    @Binding var selectedLanguages: String
    @State private var selectedLanguageSet: Set<String> = []
    
    let languages = ["日本語", "English", "中文", "한국어", "Français", "Deutsch", "Español"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("使用可能な言語を選択してください（複数選択可）")
                .font(.subheadline)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                ForEach(languages, id: \.self) { language in
                    LanguageToggleButton(
                        language: language,
                        isSelected: selectedLanguageSet.contains(language)
                    ) {
                        if selectedLanguageSet.contains(language) {
                            selectedLanguageSet.remove(language)
                        } else {
                            selectedLanguageSet.insert(language)
                        }
                        updateSelectedLanguages()
                    }
                }
            }
            
            if !selectedLanguageSet.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("選択された言語 (\(selectedLanguageSet.count)):")
                        .font(.caption)
                        .bold()
                    
                    Text(selectedLanguageSet.sorted().joined(separator: ", "))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(8)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(6)
            }
        }
        .onAppear {
            if !selectedLanguages.isEmpty {
                selectedLanguageSet = Set(selectedLanguages.components(separatedBy: ", "))
            }
        }
    }
    
    private func updateSelectedLanguages() {
        selectedLanguages = selectedLanguageSet.sorted().joined(separator: ", ")
    }
}

struct LanguageToggleButton: View {
    let language: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .foregroundColor(isSelected ? .blue : .gray)
                Text(language)
                    .font(.caption)
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding(6)
            .background(isSelected ? Color.blue.opacity(0.1) : Color.gray.opacity(0.05))
            .cornerRadius(6)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview
#Preview {
    PickerExamplesView()
}
import SwiftUI

// MARK: - Toggle Examples
// チェックボックスとToggleの様々なパターンを示すサンプルファイル

struct ToggleExamplesApp: App {
    var body: some Scene {
        WindowGroup {
            ToggleExamplesView()
        }
    }
}

struct ToggleExamplesView: View {
    // MARK: - State Variables
    @State private var basicToggle = false
    @State private var notificationsEnabled = true
    @State private var darkModeEnabled = false
    @State private var soundEnabled = true
    @State private var vibrationEnabled = false
    @State private var agreeToTerms = false
    @State private var subscribeNewsletter = false
    @State private var allowLocationAccess = false
    @State private var enableBiometrics = false
    
    // 複数選択用
    @State private var selectedFeatures: Set<Feature> = []
    @State private var privacySettings = PrivacySettings()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    
                    // 基本的なToggle
                    ExampleSection(title: "基本的なToggle") {
                        Toggle("通知を受け取る", isOn: $basicToggle)
                        
                        Text("状態: \(basicToggle ? "オン" : "オフ")")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    // 設定メニュー風Toggle群
                    ExampleSection(title: "設定メニュー") {
                        VStack(alignment: .leading, spacing: 15) {
                            Toggle("プッシュ通知", isOn: $notificationsEnabled)
                            Toggle("ダークモード", isOn: $darkModeEnabled)
                            Toggle("サウンド", isOn: $soundEnabled)
                                .disabled(!notificationsEnabled) // 通知がオフの場合は無効
                            Toggle("バイブレーション", isOn: $vibrationEnabled)
                                .disabled(!notificationsEnabled)
                        }
                        
                        // 設定状況の表示
                        SettingsSummaryView(
                            notifications: notificationsEnabled,
                            darkMode: darkModeEnabled,
                            sound: soundEnabled,
                            vibration: vibrationEnabled
                        )
                    }
                    
                    // カスタムToggleスタイル（チェックボックス風）
                    ExampleSection(title: "チェックボックススタイル") {
                        VStack(alignment: .leading, spacing: 10) {
                            Toggle("利用規約に同意する", isOn: $agreeToTerms)
                                .toggleStyle(CheckboxToggleStyle())
                            
                            Toggle("ニュースレターを受け取る", isOn: $subscribeNewsletter)
                                .toggleStyle(CheckboxToggleStyle())
                            
                            Toggle("位置情報の使用を許可する", isOn: $allowLocationAccess)
                                .toggleStyle(CheckboxToggleStyle())
                            
                            Toggle("生体認証を有効にする", isOn: $enableBiometrics)
                                .toggleStyle(CheckboxToggleStyle())
                        }
                        
                        // 同意状況の確認
                        ConsentStatusView(
                            terms: agreeToTerms,
                            newsletter: subscribeNewsletter,
                            location: allowLocationAccess,
                            biometrics: enableBiometrics
                        )
                    }
                    
                    // カスタムToggleスタイル（スイッチ風）
                    ExampleSection(title: "カスタムスイッチスタイル") {
                        Toggle("自動更新", isOn: $basicToggle)
                            .toggleStyle(CustomSwitchToggleStyle())
                    }
                    
                    // 複数選択（機能一覧）
                    ExampleSection(title: "機能選択（複数選択可能）") {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(Feature.allCases, id: \.self) { feature in
                                Toggle(feature.displayName, isOn: Binding(
                                    get: { selectedFeatures.contains(feature) },
                                    set: { isSelected in
                                        if isSelected {
                                            selectedFeatures.insert(feature)
                                        } else {
                                            selectedFeatures.remove(feature)
                                        }
                                    }
                                ))
                                .toggleStyle(FeatureToggleStyle())
                            }
                        }
                        
                        // 選択された機能の表示
                        SelectedFeaturesView(features: selectedFeatures)
                    }
                    
                    // プライバシー設定
                    ExampleSection(title: "プライバシー設定") {
                        VStack(alignment: .leading, spacing: 15) {
                            Toggle("分析データの送信", isOn: $privacySettings.allowAnalytics)
                                .toggleStyle(PrivacyToggleStyle())
                            
                            Toggle("広告のパーソナライゼーション", isOn: $privacySettings.allowPersonalizedAds)
                                .toggleStyle(PrivacyToggleStyle())
                            
                            Toggle("クラッシュレポートの送信", isOn: $privacySettings.allowCrashReports)
                                .toggleStyle(PrivacyToggleStyle())
                            
                            Toggle("利用状況の追跡", isOn: $privacySettings.allowUsageTracking)
                                .toggleStyle(PrivacyToggleStyle())
                        }
                        
                        PrivacySettingsSummaryView(settings: privacySettings)
                    }
                    
                    // 条件付きToggle
                    ExampleSection(title: "条件付き表示") {
                        Toggle("マスター設定", isOn: $notificationsEnabled)
                        
                        if notificationsEnabled {
                            VStack(alignment: .leading, spacing: 10) {
                                Toggle("  メール通知", isOn: $subscribeNewsletter)
                                    .toggleStyle(SubToggleStyle())
                                
                                Toggle("  プッシュ通知", isOn: $soundEnabled)
                                    .toggleStyle(SubToggleStyle())
                                
                                Toggle("  SMS通知", isOn: $vibrationEnabled)
                                    .toggleStyle(SubToggleStyle())
                            }
                            .padding(.leading)
                            .transition(.opacity.combined(with: .slide))
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Toggle Examples")
        }
        .animation(.easeInOut, value: notificationsEnabled)
    }
}

// MARK: - Data Models

enum Feature: String, CaseIterable {
    case autoSave = "auto_save"
    case darkMode = "dark_mode"
    case notifications = "notifications"
    case offlineMode = "offline_mode"
    case cloudSync = "cloud_sync"
    case advancedSearch = "advanced_search"
    
    var displayName: String {
        switch self {
        case .autoSave: return "自動保存"
        case .darkMode: return "ダークモード"
        case .notifications: return "通知機能"
        case .offlineMode: return "オフラインモード"
        case .cloudSync: return "クラウド同期"
        case .advancedSearch: return "高度な検索"
        }
    }
    
    var icon: String {
        switch self {
        case .autoSave: return "square.and.arrow.down"
        case .darkMode: return "moon.fill"
        case .notifications: return "bell.fill"
        case .offlineMode: return "wifi.slash"
        case .cloudSync: return "icloud.fill"
        case .advancedSearch: return "magnifyingglass.circle"
        }
    }
}

struct PrivacySettings {
    var allowAnalytics = false
    var allowPersonalizedAds = false
    var allowCrashReports = true
    var allowUsageTracking = false
}

// MARK: - Helper Views

struct SettingsSummaryView: View {
    let notifications: Bool
    let darkMode: Bool
    let sound: Bool
    let vibration: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("設定状況:")
                .font(.subheadline)
                .bold()
            
            Text("通知: \(notifications ? "有効" : "無効")")
                .font(.caption)
                .foregroundColor(notifications ? .green : .red)
            
            Text("外観: \(darkMode ? "ダーク" : "ライト")")
                .font(.caption)
                .foregroundColor(.gray)
            
            Text("サウンド: \(sound && notifications ? "有効" : "無効")")
                .font(.caption)
                .foregroundColor(sound && notifications ? .green : .gray)
            
            Text("バイブレーション: \(vibration && notifications ? "有効" : "無効")")
                .font(.caption)
                .foregroundColor(vibration && notifications ? .green : .gray)
        }
        .padding(10)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

struct ConsentStatusView: View {
    let terms: Bool
    let newsletter: Bool
    let location: Bool
    let biometrics: Bool
    
    var allConsentsGiven: Bool {
        terms && newsletter && location && biometrics
    }
    
    var body: some View {
        HStack {
            Image(systemName: allConsentsGiven ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                .foregroundColor(allConsentsGiven ? .green : .orange)
            
            Text(allConsentsGiven ? "すべての同意が完了しています" : "未完了の同意があります")
                .font(.caption)
                .foregroundColor(allConsentsGiven ? .green : .orange)
            
            Spacer()
        }
        .padding(8)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(6)
    }
}

struct SelectedFeaturesView: View {
    let features: Set<Feature>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("選択された機能 (\(features.count)):")
                .font(.subheadline)
                .bold()
            
            if features.isEmpty {
                Text("機能が選択されていません")
                    .font(.caption)
                    .foregroundColor(.gray)
            } else {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 5) {
                    ForEach(Array(features), id: \.self) { feature in
                        HStack {
                            Image(systemName: feature.icon)
                            Text(feature.displayName)
                        }
                        .font(.caption)
                        .padding(6)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(6)
                    }
                }
            }
        }
        .padding(10)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

struct PrivacySettingsSummaryView: View {
    let settings: PrivacySettings
    
    var privacyScore: Int {
        var score = 4
        if settings.allowAnalytics { score -= 1 }
        if settings.allowPersonalizedAds { score -= 1 }
        if settings.allowUsageTracking { score -= 1 }
        return score
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("プライバシーレベル")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                HStack {
                    ForEach(1...4, id: \.self) { index in
                        Circle()
                            .fill(index <= privacyScore ? Color.green : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                    
                    Text(privacyLevelText)
                        .font(.caption)
                        .bold()
                        .foregroundColor(privacyScore > 2 ? .green : .orange)
                }
            }
            
            Spacer()
        }
        .padding(10)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
    
    private var privacyLevelText: String {
        switch privacyScore {
        case 4: return "最高"
        case 3: return "高"
        case 2: return "中"
        case 1: return "低"
        default: return "最低"
        }
    }
}

// MARK: - Custom Toggle Styles

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
                .font(.system(size: 16))
        }
    }
}

struct CustomSwitchToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            
            Spacer()
            
            RoundedRectangle(cornerRadius: 16)
                .fill(configuration.isOn ? Color.green : Color.gray)
                .frame(width: 50, height: 30)
                .overlay(
                    Circle()
                        .fill(Color.white)
                        .shadow(radius: 1)
                        .padding(2)
                        .offset(x: configuration.isOn ? 10 : -10)
                )
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        configuration.isOn.toggle()
                    }
                }
        }
    }
}

struct FeatureToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                .foregroundColor(configuration.isOn ? .blue : .gray)
                .font(.system(size: 18))
            
            configuration.label
            
            Spacer()
        }
        .padding(8)
        .background(configuration.isOn ? Color.blue.opacity(0.1) : Color.clear)
        .cornerRadius(8)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.1)) {
                configuration.isOn.toggle()
            }
        }
    }
}

struct PrivacyToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: "shield.fill")
                .foregroundColor(configuration.isOn ? .red : .green)
                .font(.system(size: 16))
            
            configuration.label
            
            Spacer()
            
            Image(systemName: configuration.isOn ? "eye.fill" : "eye.slash.fill")
                .foregroundColor(configuration.isOn ? .red : .green)
                .font(.system(size: 14))
        }
        .padding(8)
        .background(configuration.isOn ? Color.red.opacity(0.1) : Color.green.opacity(0.1))
        .cornerRadius(8)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                configuration.isOn.toggle()
            }
        }
    }
}

struct SubToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                .foregroundColor(configuration.isOn ? .blue : .gray)
                .font(.system(size: 16))
            
            configuration.label
                .font(.system(size: 14))
            
            Spacer()
        }
        .onTapGesture {
            configuration.isOn.toggle()
        }
    }
}

// MARK: - Preview
#Preview {
    ToggleExamplesView()
}